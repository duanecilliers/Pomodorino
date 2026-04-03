import Foundation
import Combine

class DistractionBlocker: ObservableObject {
    @Published private(set) var isBlocking: Bool = false
    
    private let settings: AppSettings
    
    private static let sentinelStart = "# Pomodorino-Block-Start"
    private static let sentinelEnd = "# Pomodorino-Block-End"
    
    init(settings: AppSettings) {
        self.settings = settings
    }
    
    func activateBlocking() {
        guard settings.distractionBlockerEnabled else { return }
        guard !isBlocking else { return }
        guard !settings.blockedDomains.isEmpty else { return }
        
        // Build hosts entries — use 0.0.0.0 for faster failure and better browser compatibility
        let hostsEntries = settings.blockedDomains.map { "0.0.0.0 \($0)" }.joined(separator: "\\\\n")
        
        // Build shell script: update hosts and flush OS DNS cache
        // Note: browsers have their own DNS cache (~60s TTL) so blocking
        // takes effect on new navigations after the cache expires
        let script = """
            sed -i '' '/# Pomodorino-Block-Start/,/# Pomodorino-Block-End/d' /etc/hosts; \
            printf '\\\\n# Pomodorino-Block-Start\\\\n\(hostsEntries)\\\\n# Pomodorino-Block-End\\\\n' >> /etc/hosts; \
            dscacheutil -flushcache; killall -HUP mDNSResponder
            """
        
        if runPrivileged(script: script) {
            DispatchQueue.main.async {
                self.isBlocking = true
            }
        } else {
            print("Warning: Failed to activate distraction blocking")
        }
    }
    
    func deactivateBlocking() {
        guard isBlocking else { return }
        
        // Build shell script to remove block and flush DNS cache
        let script = """
            sed -i '' '/# Pomodorino-Block-Start/,/# Pomodorino-Block-End/d' /etc/hosts; \
            dscacheutil -flushcache; killall -HUP mDNSResponder
            """
        
        runPrivileged(script: script)
        
        // Set isBlocking = false regardless of success (best-effort cleanup)
        DispatchQueue.main.async {
            self.isBlocking = false
        }
    }
    
    private func runPrivileged(script: String) -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", "do shell script \"\(script)\" with administrator privileges"]
        
        let pipe = Pipe()
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            if process.terminationStatus == 0 {
                return true
            } else {
                let errorData = pipe.fileHandleForReading.readDataToEndOfFile()
                let errorString = String(data: errorData, encoding: .utf8) ?? "Unknown error"
                print("osascript failed with status \(process.terminationStatus): \(errorString)")
                return false
            }
        } catch {
            print("Failed to run osascript: \(error)")
            return false
        }
    }
}