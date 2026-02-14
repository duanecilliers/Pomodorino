import Foundation
import Combine

class PomodoroTimer: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var timerState: TimerState = .idle
    @Published var sessionType: SessionType = .work
    @Published var completedPomodoros: Int = 0
    @Published var currentSessionIndex: Int = 0

    let settings: AppSettings
    private let audioManager: AudioManager
    private let analyticsStore: AnalyticsStore
    private var timer: Timer?
    private var endDate: Date?
    private var cancellables = Set<AnyCancellable>()

    var onSessionComplete: ((SessionType) -> Void)?

    var totalDuration: TimeInterval {
        switch sessionType {
        case .work: return TimeInterval(settings.workDuration * 60)
        case .shortBreak: return TimeInterval(settings.shortBreakDuration * 60)
        case .longBreak: return TimeInterval(settings.longBreakDuration * 60)
        }
    }

    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return 1.0 - (timeRemaining / totalDuration)
    }

    var formattedTime: String {
        let total = max(0, Int(ceil(timeRemaining)))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init(settings: AppSettings, audioManager: AudioManager, analyticsStore: AnalyticsStore) {
        self.settings = settings
        self.audioManager = audioManager
        self.analyticsStore = analyticsStore
        self.timeRemaining = TimeInterval(settings.workDuration * 60)

        // Update timeRemaining when settings change while idle
        Publishers.CombineLatest3(
            settings.$workDuration,
            settings.$shortBreakDuration,
            settings.$longBreakDuration
        )
        .dropFirst()
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _, _, _ in
            guard let self = self, self.timerState == .idle else { return }
            self.timeRemaining = self.totalDuration
        }
        .store(in: &cancellables)
    }

    func start() {
        guard timerState != .running else { return }

        if timerState == .idle {
            timeRemaining = totalDuration
        }

        endDate = Date().addingTimeInterval(timeRemaining)
        timerState = .running
        startTimer()
    }

    func pause() {
        guard timerState == .running else { return }
        if let endDate = endDate {
            timeRemaining = max(0, endDate.timeIntervalSinceNow)
        }
        timerState = .paused
        stopTimer()
        endDate = nil
    }

    func toggleStartPause() {
        if timerState == .running {
            pause()
        } else {
            start()
        }
    }

    func reset() {
        stopTimer()
        endDate = nil
        timerState = .idle
        timeRemaining = totalDuration
    }

    func skip() {
        stopTimer()
        endDate = nil
        let completedType = sessionType
        if sessionType == .work {
            transitionToBreak()
        } else {
            transitionToWork()
        }
        onSessionComplete?(completedType)
    }

    private func startTimer() {
        timer = Timer(timeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func tick() {
        guard let endDate = endDate else { return }

        let remaining = endDate.timeIntervalSinceNow

        if remaining <= 0 {
            timeRemaining = 0
            sessionCompleted()
            return
        }

        let previousWholeSeconds = Int(ceil(timeRemaining))
        timeRemaining = remaining
        let currentWholeSeconds = Int(ceil(remaining))

        // Play tick in the last 10 seconds when crossing a second boundary
        if currentWholeSeconds <= 10 && currentWholeSeconds > 0
            && currentWholeSeconds != previousWholeSeconds
        {
            audioManager.playTick()
        }
    }

    private func sessionCompleted() {
        stopTimer()
        endDate = nil
        audioManager.playCompletionChime()

        let completedType = sessionType

        if sessionType == .work {
            completedPomodoros += 1
            currentSessionIndex += 1
            analyticsStore.recordCompletedPomodoro(focusMinutes: settings.workDuration)
            transitionToBreak()
        } else {
            transitionToWork()
        }

        onSessionComplete?(completedType)
    }

    private func transitionToBreak() {
        if currentSessionIndex >= settings.pomodorosBeforeLongBreak {
            sessionType = .longBreak
            currentSessionIndex = 0
        } else {
            sessionType = .shortBreak
        }
        timeRemaining = totalDuration

        if settings.autoStartNextSession {
            start()
        } else {
            timerState = .idle
        }
    }

    private func transitionToWork() {
        sessionType = .work
        timeRemaining = totalDuration

        if settings.autoStartNextSession {
            start()
        } else {
            timerState = .idle
        }
    }
}
