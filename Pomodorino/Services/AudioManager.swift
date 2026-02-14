import AppKit

class AudioManager {
    private let settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }

    func playCompletionChime() {
        guard settings.audioEnabled else { return }
        NSSound(named: "Glass")?.play()
    }

    func playTick() {
        guard settings.audioEnabled && settings.tickerEnabled else { return }
        NSSound(named: "Tink")?.play()
    }
}
