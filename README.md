# StitchMate

A lightweight, beautifully designed mobile companion app for knitters and crocheters.

> **Core Philosophy:** Do fewer things, but do them exceptionally well.

## Features (MVP v1.0)

- **Row Counter** — Large tap target, haptics, sound, lock mode, multiple counters
- **Project Manager** — Create, organise, and track knitting & crochet projects
- **Stitch Dictionary** — Offline reference for knitting & crochet abbreviations
- **Yarn Stash Manager** — Track your yarn inventory with colour swatches
- **Project Timer** — Background timer with session history
- **Gauge Calculator** — Essential maths tool for swatch calculations
- **Needle & Hook Chart** — Size conversion reference
- **Yarn Weight Guide & WPI Calculator** — Identify yarn weights

## Tech Stack

- **Framework:** Flutter (iOS & Android)
- **State Management:** Riverpod v2
- **Local Persistence:** Hive + SharedPreferences
- **Navigation:** go_router
- **Design:** Material 3 (Material You)

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── core/           # App-wide constants, theme, utils
├── data/           # Local database (Hive) & data models
├── features/       # Feature-first modules
│   ├── counter/
│   ├── projects/
│   ├── dictionary/
│   ├── stash/
│   ├── calculator/
│   ├── reference/
│   └── settings/
└── routing/        # go_router configuration
```

## Development

This project follows the StitchMate Harness constraints:
- Feature-first folder structure
- No cross-feature imports
- All state in Riverpod
- Immediate Hive persistence on mutation
- Zero analyzer warnings

## License

Proprietary — All rights reserved.