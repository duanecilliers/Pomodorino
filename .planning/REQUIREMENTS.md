# REQUIREMENTS.md — Pomodoro

## v1 Requirements

### Timer Core (TIMER)
- [ ] **TIMER-01**: User can see remaining time in menu bar at all times
- [ ] **TIMER-02**: User can start a Pomodoro session (25 min default)
- [ ] **TIMER-03**: User can pause the current session
- [ ] **TIMER-04**: User can resume a paused session
- [ ] **TIMER-05**: User can reset the current session
- [ ] **TIMER-06**: User can skip to the next session (work → break or break → work)
- [ ] **TIMER-07**: Timer automatically transitions to break after work session
- [ ] **TIMER-08**: Timer automatically transitions to work after break session
- [ ] **TIMER-09**: Long break triggers after 4 completed pomodoros

### Menu Bar UI (UI)
- [ ] **UI-01**: App displays as menu bar icon with timer countdown
- [ ] **UI-02**: Click menu bar icon reveals dropdown panel
- [ ] **UI-03**: Dropdown shows current session type (Work/Short Break/Long Break)
- [ ] **UI-04**: Dropdown shows session count (e.g., "2 of 4")
- [ ] **UI-05**: Dropdown has Start/Pause/Reset/Skip buttons
- [ ] **UI-06**: Menu bar icon changes color based on state (work/break/paused)

### Audio (AUDIO)
- [ ] **AUDIO-01**: Completion chime plays when session ends
- [ ] **AUDIO-02**: 10-second countdown ticker plays before session ends
- [ ] **AUDIO-03**: User can toggle audio on/off in settings

### Keyboard Shortcuts (KEY)
- [ ] **KEY-01**: Global shortcut `⌃⌥P` toggles start/pause from anywhere

### Settings (SET)
- [ ] **SET-01**: User can configure work duration (default 25 min)
- [ ] **SET-02**: User can configure short break duration (default 5 min)
- [ ] **SET-03**: User can configure long break duration (default 15 min)
- [ ] **SET-04**: User can configure pomodoros before long break (default 4)
- [ ] **SET-05**: User can toggle auto-start next session
- [ ] **SET-06**: User can toggle audio on/off
- [ ] **SET-07**: Settings persist across app restarts

### Analytics (STATS)
- [ ] **STATS-01**: App tracks completed pomodoros per day
- [ ] **STATS-02**: App tracks total focus time per day
- [ ] **STATS-03**: User can view today's stats in dropdown
- [ ] **STATS-04**: User can view weekly stats
- [ ] **STATS-05**: User can view monthly stats
- [ ] **STATS-06**: All data stored locally only

### System Integration (SYS)
- [ ] **SYS-01**: App launches at login (configurable)
- [ ] **SYS-02**: macOS notification when session completes
- [ ] **SYS-03**: App runs on macOS 13+ (Ventura and later)

## v2 Requirements (Deferred)

- Task/project tagging for pomodoros
- Export analytics to CSV
- Daily/weekly goals
- Focus mode integration (Do Not Disturb)

## Out of Scope

- Cloud sync — privacy first, no backend complexity
- Team/shared timers — this is a personal productivity tool
- iOS companion — desktop only for v1
- Integration with other apps — keep it standalone

## Traceability

| Requirement | Phase |
|-------------|-------|
| TIMER-* | Phase 1 |
| UI-* | Phase 2 |
| AUDIO-* | Phase 3 |
| KEY-* | Phase 3 |
| SET-* | Phase 4 |
| STATS-* | Phase 5 |
| SYS-* | Phase 4 |

---
*Last updated: 2026-02-14*
