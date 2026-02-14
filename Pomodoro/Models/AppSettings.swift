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
        ])

        self.workDuration = defaults.integer(forKey: "workDuration")
        self.shortBreakDuration = defaults.integer(forKey: "shortBreakDuration")
        self.longBreakDuration = defaults.integer(forKey: "longBreakDuration")
        self.pomodorosBeforeLongBreak = defaults.integer(forKey: "pomodorosBeforeLongBreak")
        self.autoStartNextSession = defaults.bool(forKey: "autoStartNextSession")
        self.audioEnabled = defaults.bool(forKey: "audioEnabled")
        self.tickerEnabled = defaults.bool(forKey: "tickerEnabled")
        self.launchAtLogin = defaults.bool(forKey: "launchAtLogin")
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
