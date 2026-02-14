import Foundation

enum TimerState: String, Codable {
    case idle
    case running
    case paused
}

enum SessionType: String, Codable {
    case work
    case shortBreak
    case longBreak

    var displayName: String {
        switch self {
        case .work: return "Work"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }
}
