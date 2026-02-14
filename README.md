# 🍅 Pomodorino

*A little tomato for your menu bar.*

The Pomodoro timer for people who tried the others and got annoyed.

![macOS](https://img.shields.io/badge/macOS-13%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)

---

## Why Pomodorino?

Every Pomodoro app eventually becomes bloated. They add task management, team features, integrations, subscriptions, and ads. Pomodorino doesn't.

| | Other Apps | Pomodorino |
|---|---|---|
| **Ads** | Yes | No |
| **Subscription** | $5-10/month | Free |
| **Account required** | Usually | Never |
| **Cloud sync** | Your data on their servers | Local only |
| **Task management** | Bolted on | Not included |
| **Integrations** | Slack, Notion, etc. | None |
| **App size** | 50-200MB | ~5MB |

**Your focus data never leaves your Mac.**

---

## Features

- **Menu bar timer** — Always visible countdown
- **One-click controls** — Start, pause, reset, skip
- **Global shortcut** — `⌃⌥P` to toggle from anywhere
- **Completion chimes** — With 10-second countdown ticker
- **Local analytics** — Daily, weekly, monthly stats
- **Launch at login** — Always ready
- **Configurable** — Work/break durations, audio toggle

---

## Install

### From Source

```bash
git clone https://github.com/yourusername/pomodorino.git
cd pomodorino
open Pomodorino.xcodeproj
# Build with ⌘B, Run with ⌘R
```

### Homebrew (coming soon)

```bash
brew install --cask pomodorino
```

---

## Usage

1. Click the tomato in your menu bar
2. Press **Start**
3. Work for 25 minutes
4. Take a break when it chimes
5. Repeat

After 4 pomodoros, you get a long break. That's it.

**Keyboard shortcut:** `⌃⌥P` toggles start/pause from any app.

---

## Settings

- Work duration (default: 25 min)
- Short break (default: 5 min)
- Long break (default: 15 min)
- Pomodoros before long break (default: 4)
- Auto-start next session
- Audio on/off
- Launch at login

---

## Privacy

Pomodorino collects nothing. Your stats are stored in a local JSON file on your Mac. No analytics. No telemetry. No accounts. No cloud.

---

## Requirements

- macOS 13 (Ventura) or later

---

## License

MIT — do whatever you want.

---

*Built with zero bloat in Cape Town 🇿🇦*
