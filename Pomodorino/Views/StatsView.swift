import SwiftUI

enum StatsPeriod: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
}

struct StatsView: View {
    @ObservedObject var analyticsStore: AnalyticsStore
    @State private var selectedPeriod: StatsPeriod = .today

    private var stats: DailyStats {
        switch selectedPeriod {
        case .today: return analyticsStore.statsForToday()
        case .week: return analyticsStore.statsForWeek()
        case .month: return analyticsStore.statsForMonth()
        }
    }

    private var periodDays: Int {
        switch selectedPeriod {
        case .today: return 1
        case .week: return 7
        case .month: return 30
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("", selection: $selectedPeriod) {
                ForEach(StatsPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            HStack(spacing: 12) {
                StatCard(
                    title: "Pomodoros",
                    value: "\(stats.completedPomodoros)",
                    icon: "flame.fill",
                    color: .orange
                )
                StatCard(
                    title: "Focus Time",
                    value: formatFocusTime(stats.totalFocusMinutes),
                    icon: "clock.fill",
                    color: .blue
                )
            }
            .padding(.horizontal)

            if selectedPeriod != .today {
                BarChartView(
                    data: analyticsStore.dailyStatsForPeriod(days: periodDays),
                    period: selectedPeriod
                )
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
    }

    private func formatFocusTime(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        }
        let hours = minutes / 60
        let mins = minutes % 60
        return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct BarChartView: View {
    let data: [(date: Date, stats: DailyStats)]
    let period: StatsPeriod

    private var maxPomodoros: Int {
        max(data.map(\.stats.completedPomodoros).max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Daily Pomodoros")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .bottom, spacing: period == .week ? 8 : 2) {
                ForEach(Array(data.enumerated()), id: \.offset) { _, entry in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                entry.stats.completedPomodoros > 0
                                    ? Color.orange : Color.gray.opacity(0.2)
                            )
                            .frame(
                                width: period == .week ? 24 : 6,
                                height: max(
                                    4,
                                    CGFloat(entry.stats.completedPomodoros)
                                        / CGFloat(maxPomodoros) * 80)
                            )

                        if period == .week {
                            Text(dayLabel(entry.date))
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
        }
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
