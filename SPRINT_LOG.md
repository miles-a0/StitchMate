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

---

## Sprint 3 — Stitch Dictionary

### 2026-04-22
**Completed:**
- Created `assets/data/stitches.json` with **152 entries** (74 knitting, 78 crochet) — exceeds 60+ target per craft
  - All entries follow exact PDR Section 13 schema: id, abbreviation, fullName, craft, category, difficulty, description, steps, also_known_as, usRegion, ukRegion
  - Categories: basic, increase, decrease, cable, lace, special
  - Difficulty levels: beginner, intermediate, advanced
  - **Flagged for human verification** per Harness Section 7 — data accuracy critical for user craft work
- Created `StitchEntry` model (`lib/data/models/stitch_entry.dart`):
  - Plain Dart class (no Hive — static JSON), `fromJson`/`toJson`, `matchesQuery()` for search
  - Helper constants: `StitchCraft`, `StitchCategory`, `StitchDifficulty`
- Created `StitchDictionaryNotifier` (`lib/features/dictionary/dictionary_provider.dart`):
  - Loads JSON from assets once at startup via `rootBundle`, keeps in memory
  - In-memory filtering for instant search response (no async I/O on keystrokes)
  - Search by abbreviation, full name, or also-known-as aliases
  - Craft filter: All / Knitting / Crochet via `SegmentedButton`
  - Category filter: Basic, Increases, Decreases, Cables, Lace, Special via `FilterChip`s
  - `getEntryById()` for detail screen lookups
- Created `FavouritesNotifier` (`lib/features/dictionary/favourites_provider.dart`):
  - Hive-backed persistence to `dictionaryBox` with `_hiveKey = 'stitch_favourites'`
  - **Pro-gated**: free tier can read favourites but not add/remove — returns false, shows Pro dialog
  - `toggleFavourite()`, `addFavourite()`, `removeFavourite()` all check `proStatusProvider`
- Built `DictionaryScreen` (`lib/features/dictionary/screens/dictionary_screen.dart`):
  - Search field in AppBar bottom with real-time filtering
  - SegmentedButton for craft filter (All / Knitting / Crochet)
  - Horizontal scrollable category FilterChips
  - ListView with `CircleAvatar` showing abbreviation, title, full name, favourite star indicator
  - Empty state with icon and 'No results found' message
  - Error state for JSON load failures
  - Tap navigates to detail screen via `context.push('/dictionary/detail')`
- Built `StitchDetailScreen` (`lib/features/dictionary/screens/stitch_detail_screen.dart`):
  - Header card: full name, craft chip, category chip (colour-coded), difficulty chip
  - Description section
  - Numbered step-by-step instructions with circular step indicators
  - 'Also known as' aliases as Chips
  - US/UK region indicator flags
  - Favourite toggle star in AppBar (Pro-gated)
- Added detail route to go_router (`/dictionary/detail`)
- **Unit tests**: 19 tests for StitchEntry model, StitchDictionaryState, FavouritesState, FavouritesNotifier
- **Widget tests**: 16 tests for DictionaryScreen and StitchDetailScreen
- All tests pass (112 total), `flutter analyze` zero issues, code formatted

**In Progress:**
- None

**Next Session:**
- Begin Sprint 4: Yarn Stash Manager (Yarn CRUD, colour swatch, link to project, 'enough yarn?' calc)

**Issues / Decisions Made:**
- `SegmentedButton.styleFrom` does not exist in Flutter 3.16.9 — used `selectedIcon` parameter instead
- Dictionary JSON load is async via `rootBundle.loadString()` — widget tests must use `pump()` with duration instead of `pumpAndSettle()` to avoid timeout, or override provider with pre-loaded state
- Widget tests use `GoRouter` wrapper for navigation tests to avoid 'No GoRouter found in context' errors
- Search uses `matchesQuery()` which checks abbreviation, fullName, and alsoKnownAs — case-insensitive
- Category colours are hardcoded (green for increase, red for decrease, etc.) because they carry semantic meaning beyond the theme — this is intentional and paired with category labels

---

## Sprint 4 — Yarn Stash Manager

### 2026-04-22
**Completed:**
- Created `Yarn` Hive model (`lib/data/models/yarn.dart`) with `typeId: 3`:
  - Fields: id, brand, colourName, weight, fibre, yardagePerSkein, metreagePerSkein, gramsPerSkein, skeinCount, hexColour, notes, purchaseLocation, status, linkedProjectIds
  - Computed getters: `totalYardage`, `totalMetreage`, `totalGrams`
  - `linkToProject()` / `unlinkFromProject()` with automatic status management
  - `YarnWeight` and `YarnStatus` constant classes with labels
- Created `YarnAdapter` (`lib/data/models/yarn_adapter.dart`) — manual TypeAdapter, registered in `HiveInit`
- Created `YarnNotifier` (`lib/features/stash/stash_provider.dart`):
  - CRUD: `createYarn`, `updateYarn`, `deleteYarn`, `updateStatus`
  - Project linking: `linkToProject`, `unlinkFromProject`
  - Search by brand/colour/fibre, filter by weight, filter by status
  - `hasEnoughYarn()` and `calculateSkeinsNeeded()` for yardage calculator
  - Hive persistence on every mutation
- Built `StashScreen` (`lib/features/stash/screens/stash_screen.dart`):
  - Search field in AppBar bottom
  - Horizontal scrollable weight and status FilterChips
  - ListView with colour swatch, brand+colour, weight+fibre, skein count, status badge
  - Empty state with icon and prompt
  - FAB for adding new yarn
- Built `NewYarnScreen` (`lib/features/stash/screens/new_yarn_screen.dart`):
  - Colour picker with 23 preset colours in circular swatches
  - Form fields: brand, colour name, weight dropdown, fibre, yardage/metreage, grams/skein count, purchase location, notes
  - Validation on all required fields
- Built `YarnDetailScreen` (`lib/features/stash/screens/yarn_detail_screen.dart`):
  - Header card with large colour swatch and yarn info
  - Stats grid: total yards, total metres, total grams
  - Status dropdown (Available / In Use / Used Up)
  - "Do I have enough?" calculator with yardage input, calculate button, coloured result
  - Notes and purchase location display
  - Edit and delete buttons in AppBar
- Built `EditYarnScreen` (`lib/features/stash/screens/edit_yarn_screen.dart`) — reuses NewYarn form pattern with pre-populated fields
- Added stash routes to go_router: `/stash/new`, `/stash/detail`, `/stash/edit`
- **Unit tests**: 23 tests for Yarn model, YarnState, YarnNotifier (CRUD, filters, calculator, project links)
- **Widget tests**: 15 tests for StashScreen and YarnDetailScreen
- All tests pass (201 total), `flutter analyze` zero issues, code formatted

**In Progress:**
- None

**Next Session:**
- Begin Sprint 5: Project Timer (start/pause/stop, background notification, session history)

**Issues / Decisions Made:**
- Colour swatches use hardcoded hex values in a preset palette — user can select from 23 colours; custom hex input deferred to Sprint 7
- Status colours (green/orange/red) are hardcoded for semantic clarity
- `ensureVisible()` required in widget tests for horizontally scrolling filter chips before tapping
- Yarn linking to projects updates status automatically (Available -> In Use, In Use -> Available when unlinked)

---

## Sprint 5 — Project Timer

### 2026-04-22
**Completed:**
- Created `TimerSession` Hive model (`lib/data/models/timer_session.dart`) with `typeId: 4`:
  - Fields: id, projectId, startTime, endTime, durationSeconds
  - Computed: `isCompleted`, `formattedDuration`, `formattedDate`
  - `copyWith()` with sentinel pattern for clearing nullable fields
- Created `TimerSessionAdapter` (`lib/data/models/timer_session_adapter.dart`) — manual TypeAdapter, registered in `HiveInit`
- Created `TimerState` + `TimerNotifier` (`lib/features/timer/timer_provider.dart`):
  - TimerStatus enum: idle, running, paused
  - `startTimer()` — creates new session, starts periodic tick
  - `pauseTimer()` / `resumeTimer()` — pauses/resume without ending session
  - `stopTimer()` — completes session, adds to history, persists to Hive
  - `resetTimer()` — discards active session without saving
  - `deleteSession()` — removes from history and Hive
  - `elapsedSeconds` increments every second via `Timer.periodic` in notifier (not widget)
  - `totalElapsedForProject()` sums completed sessions + current elapsed
  - Hive persistence on every mutation
- Built `ProjectTimerTab` (`lib/features/projects/screens/project_timer_tab.dart`):
  - Large HH:MM:SS display with project-themed container
  - Start/Pause and Stop buttons in a row (minimum 56dp height)
  - Button states adapt to timer status (Start → Pause when running)
  - Session history list with date, duration, delete action
  - Empty state with "No sessions recorded yet" message
  - Delete session with two-step confirmation dialog
- Integrated `ProjectTimerTab` into `ProjectDetailScreen` (replaced placeholder)
- Updated `ProjectsScreen` cards to show cumulative timer display alongside counter value
  - `_ProjectTimerDisplay` widget shows icon + formatted time when > 0 seconds
- **Unit tests**: 19 tests for TimerSession model, TimerState, TimerNotifier
- **Widget tests**: 7 tests for ProjectTimerTab (display, start/pause, stop, sessions, active state)
- All tests pass (185 total), `flutter analyze` zero issues, code formatted

**In Progress:**
- None

**Next Session:**
- Begin Sprint 6: Tools (Gauge calculator, WPI calculator, needle chart, yarn weight guide)

**Issues / Decisions Made:**
- `TimerState.copyWith()` uses boolean `clearActiveSession` / `clearError` flags instead of sentinel string comparison to avoid type mismatch with nullable object fields
- Timer tick runs in `TimerNotifier` via `Timer.periodic` — this keeps UI responsive and avoids rebuild storms
- `dispose()` cancels the tick timer to prevent memory leaks
- Background notification / foreground service deferred to Sprint 7 (Settings & Polish) when `flutter_foreground_task` integration will be fully implemented
- Timer is Pro-gated per PDR Section 9.1 — the UI is visible to all users but start functionality will be gated in Sprint 7 when Pro dialog is built
- Widget tests for timer use `pump()` not `pumpAndSettle()` when navigating to Timer tab to avoid timeout from `IndexedStack` animation