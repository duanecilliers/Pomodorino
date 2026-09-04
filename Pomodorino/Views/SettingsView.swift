import AppKit
import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                // Durations
                Text("Durations")
                    .font(.headline)

                Stepper(
                    "Work: \(settings.workDuration) min",
                    value: $settings.workDuration, in: 1...60
                )
                Stepper(
                    "Short Break: \(settings.shortBreakDuration) min",
                    value: $settings.shortBreakDuration, in: 1...30
                )
                Stepper(
                    "Long Break: \(settings.longBreakDuration) min",
                    value: $settings.longBreakDuration, in: 1...60
                )
                Stepper(
                    "Sessions before long break: \(settings.pomodorosBeforeLongBreak)",
                    value: $settings.pomodorosBeforeLongBreak, in: 2...10
                )

                Divider()

                // Audio
                Text("Audio")
                    .font(.headline)

                Toggle("Completion sound", isOn: $settings.audioEnabled)
                Toggle("10-second countdown ticker", isOn: $settings.tickerEnabled)

                Divider()

                // Behavior
                Text("Behavior")
                    .font(.headline)

                Toggle("Auto-start next session", isOn: $settings.autoStartNextSession)
                Toggle("Launch at login", isOn: $settings.launchAtLogin)

                Divider()

                // Global shortcut
                Text("Keyboard Shortcut")
                    .font(.headline)

                HStack {
                    Text("Start / Pause")
                        .foregroundColor(.secondary)
                    Spacer()
                    ShortcutRecorder(
                        keyCode: $settings.shortcutKeyCode,
                        modifiers: $settings.shortcutModifiers
                    )
                    .frame(width: 120, height: 28)
                    Button("Reset") {
                        settings.shortcutKeyCode = 35
                        settings.shortcutModifiers = 6144
                    }
                    .controlSize(.small)
                }

                Text("Click the shortcut, then press a key combination with at least one modifier.")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Divider()

                Button("Quit Pomodoro") {
                    NSApplication.shared.terminate(nil)
                }
                .foregroundColor(.red)
            }
            .padding()
        }
    }
}

private struct ShortcutRecorder: NSViewRepresentable {
    @Binding var keyCode: Int
    @Binding var modifiers: Int

    func makeNSView(context: Context) -> ShortcutRecorderButton {
        let button = ShortcutRecorderButton()
        button.onShortcut = { keyCode, modifiers in
            self.keyCode = keyCode
            self.modifiers = modifiers
        }
        return button
    }

    func updateNSView(_ button: ShortcutRecorderButton, context: Context) {
        button.title = ShortcutManager.displayString(keyCode: keyCode, modifiers: modifiers)
    }
}

private final class ShortcutRecorderButton: NSButton {
    var onShortcut: ((Int, Int) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func mouseDown(with event: NSEvent) {
        window?.makeFirstResponder(self)
        super.mouseDown(with: event)
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {
            window?.makeFirstResponder(nil)
            return
        }

        let modifiers = ShortcutManager.carbonModifiers(from: event.modifierFlags)
        guard modifiers != 0 else {
            NSSound.beep()
            return
        }

        onShortcut?(Int(event.keyCode), modifiers)
        window?.makeFirstResponder(nil)
    }
}
