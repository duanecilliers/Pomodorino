import SwiftUI

enum PopoverTab: String, CaseIterable {
    case timer = "Timer"
    case stats = "Stats"
    case settings = "Settings"
}

struct PopoverView: View {
    @ObservedObject var timer: PomodoroTimer
    @ObservedObject var settings: AppSettings
    @ObservedObject var analyticsStore: AnalyticsStore
    @State private var selectedTab: PopoverTab = .timer

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                ForEach(PopoverTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 12)

            Divider()
                .padding(.top, 8)

            switch selectedTab {
            case .timer:
                TimerView(timer: timer)
            case .stats:
                StatsView(analyticsStore: analyticsStore)
            case .settings:
                SettingsView(settings: settings)
            }
        }
        .frame(width: 320, height: 420)
    }
}
