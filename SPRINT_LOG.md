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