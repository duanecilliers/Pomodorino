import SwiftUI

struct TimerView: View {
    @ObservedObject var timer: PomodoroTimer

    private var stateColor: Color {
        switch timer.timerState {
        case .idle:
            return .secondary
        case .running:
            return timer.sessionType == .work ? .red : .green
        case .paused:
            return .secondary
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Session type
            Text(timer.sessionType.displayName)
                .font(.headline)
                .foregroundColor(stateColor)

            // Circular progress timer
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: timer.progress)
                    .stroke(stateColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.5), value: timer.progress)

                VStack(spacing: 4) {
                    Text(timer.formattedTime)
                        .font(.system(size: 40, weight: .medium, design: .monospaced))

                    if timer.timerState == .paused {
                        Text("PAUSED")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 160, height: 160)

            // Session count
            Text(
                "Session \(timer.currentSessionIndex + 1) of \(timer.settings.pomodorosBeforeLongBreak)"
            )
            .font(.subheadline)
            .foregroundColor(.secondary)

            // Completed count
            Text(
                "\(timer.completedPomodoros) pomodoro\(timer.completedPomodoros == 1 ? "" : "s") completed"
            )
            .font(.caption)
            .foregroundColor(.secondary)

            // Controls
            HStack(spacing: 20) {
                Button(action: timer.reset) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .disabled(timer.timerState == .idle)
                .opacity(timer.timerState == .idle ? 0.4 : 1.0)

                Button(action: timer.toggleStartPause) {
                    Image(
                        systemName: timer.timerState == .running
                            ? "pause.circle.fill" : "play.circle.fill"
                    )
                    .font(.system(size: 44))
                    .foregroundColor(stateColor == .secondary ? .accentColor : stateColor)
                }
                .buttonStyle(.plain)

                Button(action: timer.skip) {
                    Image(systemName: "forward.end")
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding()
    }
}
