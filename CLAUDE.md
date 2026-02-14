# CLAUDE.md

## Commit Rules

- **Never** include `Co-Authored-By` trailers in commit messages
- Keep commit messages concise and conventional (feat/fix/chore/docs prefix)

## Project

Pomodorino is a native macOS menu bar Pomodoro timer. Swift/SwiftUI, macOS 13+.

## Build

```bash
open Pomodorino.xcodeproj
# ⌘B to build, ⌘R to run
```

## Structure

```
Pomodorino/
├── App/           # AppDelegate, entry point
├── Models/        # PomodoroTimer, AppSettings, AnalyticsStore
├── Views/         # SwiftUI views (Popover, Timer, Settings, Stats)
├── Services/      # Audio, Notifications, Shortcuts
└── Resources/     # Assets, Info.plist, entitlements
```
