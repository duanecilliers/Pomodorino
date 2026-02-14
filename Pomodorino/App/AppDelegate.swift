import AppKit
import Combine
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!

    private var settings: AppSettings!
    private var pomodoroTimer: PomodoroTimer!
    private var audioManager: AudioManager!
    private var analyticsStore: AnalyticsStore!
    private var shortcutManager: ShortcutManager!
    private var notificationManager: NotificationManager!

    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize dependencies
        settings = AppSettings()
        audioManager = AudioManager(settings: settings)
        analyticsStore = AnalyticsStore()
        pomodoroTimer = PomodoroTimer(
            settings: settings,
            audioManager: audioManager,
            analyticsStore: analyticsStore
        )
        notificationManager = NotificationManager()
        notificationManager.requestPermission()

        // Session completion notifications
        pomodoroTimer.onSessionComplete = { [weak self] completedType in
            switch completedType {
            case .work:
                self?.notificationManager.sendNotification(
                    title: "Pomodoro",
                    body: "Great work! Time for a break."
                )
            case .shortBreak, .longBreak:
                self?.notificationManager.sendNotification(
                    title: "Pomodoro",
                    body: "Break is over! Time to focus."
                )
            }
        }

        // Setup status bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Setup popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 420)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: PopoverView(
                timer: pomodoroTimer,
                settings: settings,
                analyticsStore: analyticsStore
            )
        )

        // Observe timer changes for status bar updates
        pomodoroTimer.$timeRemaining
            .combineLatest(pomodoroTimer.$timerState, pomodoroTimer.$sessionType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _, _ in
                self?.updateStatusBar()
            }
            .store(in: &cancellables)

        // Setup global keyboard shortcut (⌃⌥P)
        shortcutManager = ShortcutManager()
        shortcutManager.onToggle = { [weak self] in
            self?.pomodoroTimer.toggleStartPause()
        }
        shortcutManager.register()

        updateStatusBar()
    }

    private func updateStatusBar() {
        guard let button = statusItem.button else { return }

        let symbolName: String
        let tintColor: NSColor

        switch pomodoroTimer.timerState {
        case .idle:
            symbolName = "timer"
            tintColor = .secondaryLabelColor
        case .running:
            if pomodoroTimer.sessionType == .work {
                symbolName = "flame.fill"
                tintColor = .systemRed
            } else {
                symbolName = "leaf.fill"
                tintColor = .systemGreen
            }
        case .paused:
            symbolName = "pause.circle"
            tintColor = .secondaryLabelColor
        }

        if let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Pomodoro") {
            let config = NSImage.SymbolConfiguration(pointSize: 13, weight: .medium)
                .applying(.init(paletteColors: [tintColor]))
            let configuredImage = image.withSymbolConfiguration(config)!
            configuredImage.isTemplate = false
            button.image = configuredImage
        }

        button.title = " \(pomodoroTimer.formattedTime)"
        button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .medium)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
