# StitchMate

A lightweight, beautifully designed mobile companion app for knitters and crocheters.

> **Core Philosophy:** Do fewer things, but do them exceptionally well.

## Features (MVP v1.0)

### Core Tools
- **Row Counter** — Large tap target (≥40% screen height), haptic feedback, sound, lock mode, swipe-to-decrement, long-press set value, reminder banners, target progress bar
- **Project Manager** — Create, organise, and track knitting & crochet projects with status management (Active / Paused / Completed / Frogged)
- **Project Timer** — Start/pause/stop timer per project with session history and cumulative time tracking
- **Stitch Dictionary** — Offline reference with 152 entries (74 knitting, 78 crochet), searchable by abbreviation, name, or alias
- **Yarn Stash Manager** — Track yarn inventory with colour swatches, project linking, and "Do I have enough?" calculator

### Calculator & Reference Tools
- **Gauge Calculator** — Forward/reverse stitch and row calculations with metric/imperial toggle
- **WPI Calculator** — Identify yarn weight from wraps-per-inch measurement
- **Needle & Hook Chart** — US / metric / UK conversion tables for knitting needles and crochet hooks
- **Yarn Weight Guide** — Detailed reference for all 8 standard weights with recommendations

### Personalisation
- **Light / Dark / System theme**
- **6 accent colour presets**
- **Default craft type** (Knitting / Crochet / Both)
- **Units** (Metric / Imperial)
- **Counter haptics & sound** (Off / Soft / Loud)
- **Keep screen awake** while counting

### Data & Privacy
- **Data Export/Import** — Full JSON backup via share sheet
- **Privacy Policy** — All data stays local, no tracking, no analytics
- **Onboarding flow** — 3-screen welcome for first-time users

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.16.9 (iOS & Android) |
| State Management | Riverpod v2 |
| Local Database | Hive (NoSQL) |
| Settings | SharedPreferences |
| Navigation | go_router |
| Design | Material 3 (Material You) |
| Font | Nunito (Google Fonts) |
| Primary Colour | #7B3F6E (warm mauve) |

## Getting Started

### Prerequisites
- Flutter SDK 3.16.9 or compatible
- Dart 3.2.6+
- Android Studio / Xcode for device simulators

### Installation

```bash
# Clone the repository
git clone https://github.com/miles-a0/StitchMate.git
cd StitchMate

# Install dependencies
flutter pub get

# Run on connected device or simulator
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run analyzer
flutter analyze

# Format code
dart format lib/ test/
```

## Project Structure

```
lib/
├── main.dart              # App entry point, onboarding gate, theme
├── core/
│   ├── theme.dart         # Material 3 light/dark themes
│   ├── dimensions.dart    # Spacing & sizing constants
│   ├── strings.dart       # All user-visible strings (l10n-ready)
│   └── providers.dart     # App-level Riverpod providers
├── data/
│   ├── local/
│   │   └── hive_init.dart # Hive init & adapter registration
│   └── models/            # Counter, Project, Yarn, TimerSession
│       └── *_adapter.dart # Manual Hive TypeAdapters
├── features/
│   ├── counter/           # Row counter feature
│   ├── projects/          # Project manager (CRUD, detail, counter tab, timer tab)
│   ├── dictionary/        # Stitch dictionary (search, filter, favourites)
│   ├── stash/             # Yarn stash (CRUD, calculator, project links)
│   ├── calculator/        # Tools: gauge, WPI, needle chart, yarn weight guide
│   └── settings/          # Settings, onboarding, export/import, privacy policy
└── routing/
    └── app_router.dart    # go_router configuration
```

## Architecture Principles

- **Feature-first folder structure** — every feature is self-contained
- **No cross-feature imports** — features communicate through shared core providers only
- **All business logic in Riverpod** — no `setState()` for state management
- **Immediate persistence** — Hive writes on every mutation, not on app close
- **Zero analyzer warnings** — clean code enforced before every commit
- **Responsive layouts** — LayoutBuilder for phone/tablet adaptability

## Testing

- **244 tests** covering all features
- Unit tests for models, state, and notifier logic
- Widget tests for all screens and user interactions
- All tests pass with zero failures

## Development Standards

This project follows the StitchMate Harness constraints:
- PEV loop: Plan → Execute → Verify
- Sprint-based development (9 sprints total)
- Conventional commit messages
- GitHub push after every passing sprint

## License

Proprietary — All rights reserved.

## Acknowledgements

Built with love for knitters and crocheters. Open source packages used:
- Flutter & Dart (Google)
- Riverpod (Remi Rousselet)
- Hive (Simon Leier)
- go_router (Flutter team)
- Google Fonts (Google)
- audioplayers (Blue Fire)
- share_plus (Flutter Community)
- path_provider (Flutter team)
