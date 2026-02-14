import Foundation

struct DailyStats: Codable {
    var completedPomodoros: Int = 0
    var totalFocusMinutes: Int = 0
}

struct AnalyticsData: Codable {
    var dailyStats: [String: DailyStats] = [:]
}

class AnalyticsStore: ObservableObject {
    @Published private(set) var data: AnalyticsData

    private let fileURL: URL
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        ).first!
        let appDir = appSupport.appendingPathComponent("Pomodoro")

        try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)

        fileURL = appDir.appendingPathComponent("analytics.json")

        if let jsonData = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode(AnalyticsData.self, from: jsonData)
        {
            data = decoded
        } else {
            data = AnalyticsData()
        }
    }

    func recordCompletedPomodoro(focusMinutes: Int) {
        let key = dateFormatter.string(from: Date())
        var stats = data.dailyStats[key] ?? DailyStats()
        stats.completedPomodoros += 1
        stats.totalFocusMinutes += focusMinutes
        data.dailyStats[key] = stats
        save()
    }

    func statsForToday() -> DailyStats {
        let key = dateFormatter.string(from: Date())
        return data.dailyStats[key] ?? DailyStats()
    }

    func statsForWeek() -> DailyStats {
        return aggregateStats(days: 7)
    }

    func statsForMonth() -> DailyStats {
        return aggregateStats(days: 30)
    }

    func dailyStatsForPeriod(days: Int) -> [(date: Date, stats: DailyStats)] {
        var result: [(date: Date, stats: DailyStats)] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for i in (0..<days).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let key = dateFormatter.string(from: date)
                let stats = data.dailyStats[key] ?? DailyStats()
                result.append((date: date, stats: stats))
            }
        }

        return result
    }

    private func aggregateStats(days: Int) -> DailyStats {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var aggregate = DailyStats()

        for i in 0..<days {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let key = dateFormatter.string(from: date)
                if let stats = data.dailyStats[key] {
                    aggregate.completedPomodoros += stats.completedPomodoros
                    aggregate.totalFocusMinutes += stats.totalFocusMinutes
                }
            }
        }

        return aggregate
    }

    private func save() {
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: fileURL)
        } catch {
            print("Failed to save analytics: \(error)")
        }
        objectWillChange.send()
    }
}
