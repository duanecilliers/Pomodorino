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

                // Shortcut info
                Text("Keyboard Shortcut")
                    .font(.headline)

                HStack {
                    Text("Start / Pause")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("⌃⌥P")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(6)
                        .font(.system(.body, design: .monospaced))
                }

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
