import Foundation
import Combine
import ServiceManagement

class AppSettings: ObservableObject {
    @Published var workDuration: Int {
        didSet { UserDefaults.standard.set(workDuration, forKey: "workDuration") }
    }
    @Published var shortBreakDuration: Int {
        didSet { UserDefaults.standard.set(shortBreakDuration, forKey: "shortBreakDuration") }
    }
    @Published var longBreakDuration: Int {
        didSet { UserDefaults.standard.set(longBreakDuration, forKey: "longBreakDuration") }
    }
    @Published var pomodorosBeforeLongBreak: Int {
        didSet { UserDefaults.standard.set(pomodorosBeforeLongBreak, forKey: "pomodorosBeforeLongBreak") }
    }
    @Published var autoStartNextSession: Bool {
        didSet { UserDefaults.standard.set(autoStartNextSession, forKey: "autoStartNextSession") }
    }
    @Published var audioEnabled: Bool {
        didSet { UserDefaults.standard.set(audioEnabled, forKey: "audioEnabled") }
    }
    @Published var tickerEnabled: Bool {
        didSet { UserDefaults.standard.set(tickerEnabled, forKey: "tickerEnabled") }
    }
    @Published var launchAtLogin: Bool {
        didSet {
            UserDefaults.standard.set(launchAtLogin, forKey: "launchAtLogin")
            updateLaunchAtLogin()
        }
    }
    @Published var distractionBlockerEnabled: Bool {
        didSet { UserDefaults.standard.set(distractionBlockerEnabled, forKey: "distractionBlockerEnabled") }
    }
    @Published var blockedDomains: [String] {
        didSet {
            if let data = try? JSONEncoder().encode(blockedDomains),
               let jsonString = String(data: data, encoding: .utf8) {
                UserDefaults.standard.set(jsonString, forKey: "blockedDomains")
            }
        }
    }

    init() {
        let defaults = UserDefaults.standard

        defaults.register(defaults: [
            "workDuration": 25,
            "shortBreakDuration": 5,
            "longBreakDuration": 15,
            "pomodorosBeforeLongBreak": 4,
            "autoStartNextSession": false,
            "audioEnabled": true,
            "tickerEnabled": true,
            "launchAtLogin": false,
            "distractionBlockerEnabled": false,
            "blockedDomains": "[\"youtube.com\",\"www.youtube.com\"]",
        ])

        self.workDuration = defaults.integer(forKey: "workDuration")
        self.shortBreakDuration = defaults.integer(forKey: "shortBreakDuration")
        self.longBreakDuration = defaults.integer(forKey: "longBreakDuration")
        self.pomodorosBeforeLongBreak = defaults.integer(forKey: "pomodorosBeforeLongBreak")
        self.autoStartNextSession = defaults.bool(forKey: "autoStartNextSession")
        self.audioEnabled = defaults.bool(forKey: "audioEnabled")
        self.tickerEnabled = defaults.bool(forKey: "tickerEnabled")
        self.launchAtLogin = defaults.bool(forKey: "launchAtLogin")
        self.distractionBlockerEnabled = defaults.bool(forKey: "distractionBlockerEnabled")
        
        // Handle blockedDomains with JSON decoding
        if let jsonString = defaults.string(forKey: "blockedDomains"),
           let data = jsonString.data(using: .utf8),
           let domains = try? JSONDecoder().decode([String].self, from: data) {
            self.blockedDomains = domains
        } else {
            self.blockedDomains = ["youtube.com", "www.youtube.com"]
        }
    }

    private func updateLaunchAtLogin() {
        do {
            if launchAtLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Launch at login error: \(error)")
        }
    }
}
