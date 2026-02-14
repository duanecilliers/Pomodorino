# ROADMAP.md — Pomodoro

## Overview

**5 phases** | **26 requirements** | Build order optimized for dependencies

## Phases

### Phase 1: Timer Core
**Goal:** Working timer engine with all state transitions

**Requirements:** TIMER-01 through TIMER-09 (9 requirements)

**Success Criteria:**
1. Timer counts down from configured duration
2. State machine handles all transitions (work → break → work)
3. Long break triggers after 4 pomodoros
4. Timer state persists if app restarts mid-session

**Dependencies:** None (foundation)

---

### Phase 2: Menu Bar UI
**Goal:** Functional menu bar interface showing timer and controls

**Requirements:** UI-01 through UI-06 (6 requirements)

**Success Criteria:**
1. Menu bar shows countdown in real-time
2. Dropdown panel opens on click
3. All controls (start/pause/reset/skip) work
4. Visual state reflects timer state (colors/icons)

**Dependencies:** Phase 1 (Timer Core)

---

### Phase 3: Audio & Shortcuts
**Goal:** Audio feedback and global keyboard control

**Requirements:** AUDIO-01 through AUDIO-03, KEY-01 (4 requirements)

**Success Criteria:**
1. Completion chime plays at session end
2. Ticker audible in final 10 seconds
3. `⌃⌥P` starts/pauses timer from any app
4. Audio respects mute setting

**Dependencies:** Phase 1 (Timer Core)

---

### Phase 4: Settings & System
**Goal:** User preferences and system integration

**Requirements:** SET-01 through SET-07, SYS-01 through SYS-03 (10 requirements)

**Success Criteria:**
1. Settings panel accessible from dropdown
2. All durations configurable
3. Settings persist via UserDefaults
4. Launch at login works
5. macOS notifications appear on session complete

**Dependencies:** Phase 2 (Menu Bar UI)

---

### Phase 5: Analytics
**Goal:** Local tracking and stats display

**Requirements:** STATS-01 through STATS-06 (6 requirements)

**Success Criteria:**
1. Daily pomodoro count tracked
2. Focus time accumulated correctly
3. Stats viewable in dropdown (today/week/month)
4. Data persists in local JSON file
5. No data leaves the device

**Dependencies:** Phase 1 (Timer Core), Phase 2 (Menu Bar UI)

---

## Phase Graph

```
Phase 1 (Timer Core)
    ├── Phase 2 (Menu Bar UI)
    │       └── Phase 4 (Settings & System)
    ├── Phase 3 (Audio & Shortcuts)
    └── Phase 5 (Analytics) [also depends on Phase 2]
```

## Execution Order

1. **Phase 1** — Timer Core (blocking, everything depends on it)
2. **Phase 2** — Menu Bar UI (unlocks phases 4 and 5)
3. **Phase 3** — Audio & Shortcuts (can run parallel with Phase 2)
4. **Phase 4** — Settings & System
5. **Phase 5** — Analytics

---
*Last updated: 2026-02-14*
