## Sprint 0 — Project Setup

### 2026-04-21
**Completed:**
- Created feature-first folder structure (`lib/features/`, `lib/core/`, `lib/data/`, `lib/routing/`)
- Set up core layer: `theme.dart` (Material 3, #7B3F6E, Nunito), `dimensions.dart`, `strings.dart`
- Set up Hive initialisation with lazy box opening (`lib/data/local/hive_init.dart`)
- Set up Riverpod v2 base providers (`lib/core/providers.dart`)
- Created go_router navigation shell with 5 tabs + responsive LayoutBuilder (BottomNav / NavigationRail)
- Integrated everything into `main.dart` with `ProviderScope` and `MaterialApp.router`
- Created placeholder screens for all 5 tabs
- Added initial unit tests and widget tests
- Created GitHub repository: https://github.com/miles-a0/StitchMate
- Updated `pubspec.yaml` with all required dependencies

**In Progress:**
- Validation: `flutter analyze` and `flutter test` (pending Flutter SDK setup completion)

**Next Session:**
- Complete Sprint 0 validation (flutter analyze, flutter test, dart format)
- Begin Sprint 1: Row Counter feature

**Issues / Decisions Made:**
- Flutter SDK 3.16.9 used due to macOS 12.7.6 compatibility (latest stable requires macOS 14+)
- Package versions adjusted to be compatible with Flutter 3.16.9 / Dart 3.2.6
- `google_fonts` will be used instead of bundled font files to avoid asset management overhead
- `flutter_foreground_task` included for future timer background service (Sprint 6)

---

## Sprint 1 — Row Counter

### 2026-04-21
**Completed:**
- Created `Counter` Hive model with `typeId: 1` and manual TypeAdapter (`lib/data/models/counter.dart`, `counter_adapter.dart`)
- Registered `CounterAdapter` in `HiveInit.initialise()`
- Created immutable `CounterState` with `copyWith()` and reminder flags
- Created `CounterNotifier` (StateNotifier) with increment/decrement/setValue/lock/reset/reminder logic
- **Hive persistence on every mutation** — `_persist()` called in all mutating methods
- Built `CounterScreen` UI:
  - Large increment button (>= 40% screen height via LayoutBuilder)
  - Large-font display (96sp) with FittedBox for arm's-length readability
  - Swipe-down-to-decrement on the increment button
  - Long-press display to open set-value dialog
  - Lock toggle in AppBar with visual indicator
  - Two-step reset confirmation dialog
  - Reminder banner when stitch marker interval reached
  - Target progress bar (if targetValue set)
- Added haptic feedback (`HapticFeedback.mediumImpact`) and sound (`AudioPlayer`) on increment
- **Unit tests**: 20 tests covering model, state, notifier logic (increment, decrement, lock, reset, reminders)
- **Widget tests**: 5 tests covering display, increment, lock, reset confirmation, reset action
- All tests pass (35 total), `flutter analyze` zero issues, code formatted
- Pushed to GitHub: `85fc237`

**In Progress:**
- None

**Next Session:**
- Begin Sprint 2: Project Manager (Project CRUD, project detail, link counter to project)

**Issues / Decisions Made:**
- `hive_generator` requires `build_runner` which has compatibility issues with Flutter 3.16.9; opted for **manual TypeAdapter** to avoid generator dependency
- CounterNotifier gracefully handles missing Hive initialisation in test environment (try/catch in `_loadFromHive` and `_persist`)
- Reminder logic uses modulo (`newValue % reminderEvery == 0`) — triggers at 5, 10, 15 etc.
- Sound asset (`sounds/click.mp3`) is referenced but not bundled yet — will be added in Sprint 7 (polish) when assets are finalised

---

## Sprint 2 — Project Manager

### 2026-04-21
**Completed:**
- Fixed `ProjectDetailScreen` — removed all hardcoded strings, now uses `AppStrings` constants exclusively
- Extracted `_CounterTab` into standalone `ProjectCounterTab` widget (`lib/features/projects/screens/project_counter_tab.dart`)
- `ProjectCounterTab` features:
  - Full counter functionality: increment, swipe-to-decrement, lock toggle, reset
  - Long-press display to open set-value dialog (reuses `SetValueDialog` from counter feature)
  - Two-step reset confirmation dialog
  - Reminder banner when stitch marker interval reached
  - Target progress bar with percentage (if targetValue set)
  - Haptic feedback on increment
- Created `EditProjectScreen` (`lib/features/projects/screens/edit_project_screen.dart`):
  - Pre-populates form with existing project data
  - Editable: name, craft type, start date, notes, needle/hook size
  - Validation: required name, max 50 chars; notes max 1000 chars
  - Date picker for start date
  - Saves via `ProjectsNotifier.updateProject()` with immediate Hive persistence
- Added edit route to go_router (`/projects/edit`)
- Added edit button to `ProjectDetailScreen` AppBar
- Added new string constants to `AppStrings`: `counterResetConfirm`, `counterCurrentValue`, `counterSwipeHint`
- **Unit tests**: 17 tests for Project model, ProjectsState, ProjectsNotifier (added 6 new edge-case tests)
- **Widget tests**: 15 tests for ProjectsScreen and ProjectDetailScreen (added 8 new tests)
- All tests pass (77 total), `flutter analyze` zero issues, code formatted

**In Progress:**
- None

**Next Session:**
- Begin Sprint 3: Stitch Dictionary (static JSON data, search, browse, favourites)

**Issues / Decisions Made:**
- `ProjectCounterTab` reuses `CounterIncrementButton` and `SetValueDialog` from the counter feature — this is allowed as they are shared UI widgets, not business logic
- `EditProjectScreen` follows the same form pattern as `NewProjectScreen` but with pre-populated fields and `updateProject` instead of `createProject`
- Status dropdown in `ProjectDetailScreen` AppBar allows one-tap status changes; completed/frogged statuses auto-set endDate
- Notes and Photos tabs are read-only placeholders for Sprint 7 (Settings & Polish) when full editing will be implemented
- Counter reminder and target progress are computed from counter state in the widget — no separate state needed