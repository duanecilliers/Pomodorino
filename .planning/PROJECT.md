# PROJECT.md — Pomodoro

## What This Is

A native macOS menu bar Pomodoro timer app. Lightweight, distraction-free, no ads, no bloat. Timer visible in the menu bar at all times. Click for controls and stats.

## Core Value

**The ONE thing that must work:** Timer countdown visible in menu bar, start/pause/reset controls accessible in one click.

## Why This Exists

Every existing Pomodoro app is either bloated with unnecessary features, riddled with ads, or tries to do too much. This is the Pomodoro timer that gets out of the way and lets you focus.

## What Success Looks Like

- App lives in menu bar, shows countdown timer
- Click to reveal minimal control panel
- Completion chimes + 10-second countdown ticker (toggleable)
- Local-only analytics (daily/weekly/monthly stats)
- Global keyboard shortcut `⌃⌥P` to start/pause
- Launches at login
- Zero ads, zero cloud sync, zero bloat

## Target User

Developers and knowledge workers who want a Pomodoro timer that doesn't suck.

## Technical Constraints

- Native macOS (Swift + SwiftUI)
- Menu bar app (NSStatusBar/NSStatusItem)
- Local storage only (UserDefaults or JSON file)
- macOS 13+ (Ventura and later)
- No dependencies on external services

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Native Swift/SwiftUI | Performance, proper menu bar integration, no Electron bloat | Confirmed |
| Local storage only | Privacy, simplicity, no backend needed | Confirmed |
| Single global shortcut | Keep it simple, one action (toggle) is enough | `⌃⌥P` |
| 10-second countdown ticker | Audible warning before session ends, toggleable | Confirmed |

## Out of Scope (v1)

- Cloud sync
- Team/shared timers
- Task/project tagging
- Integration with other apps
- iOS companion app

---
*Last updated: 2026-02-14 after initialization*
