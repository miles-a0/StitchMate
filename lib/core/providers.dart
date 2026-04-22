import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/settings_provider.dart';

/// Base Riverpod providers for StitchMate.
///
/// All feature-specific providers live in their respective feature folders.
/// This file contains only shared / app-level providers.

/// Example: A simple provider that can be used to verify Riverpod is wired up.
final helloWorldProvider = Provider<String>((ref) {
  return 'Hello from Riverpod v2';
});

/// App-level loading state provider.
/// Features can set this to true during heavy initialisation.
final appLoadingProvider = StateProvider<bool>((ref) => false);

/// App-level error message provider.
/// Features can set this to display global error banners.
final appErrorProvider = StateProvider<String?>((ref) => null);

/// Theme mode provider (light / dark / system).
/// Delegates to settingsProvider for persistence.
final themeModeProvider = StateProvider<ThemeModeOption>((ref) {
  return ref.watch(settingsProvider.select((s) => s.themeMode));
});

enum ThemeModeOption { light, dark, system }

/// Unit system provider (metric / imperial).
/// Delegates to settingsProvider for persistence.
final unitSystemProvider = StateProvider<UnitSystem>((ref) {
  return ref.watch(settingsProvider.select((s) => s.unitSystem));
});

enum UnitSystem { metric, imperial }

/// Pro status provider.
/// All Pro feature gates must check this provider.
/// Use a debug override flag during development only.
final proStatusProvider = StateProvider<bool>((ref) {
  // TODO: Replace with real purchase verification.
  // For development, use a debug override if needed.
  const bool devProOverride = false;
  return devProOverride;
});

/// Counter haptics enabled provider.
/// Delegates to settingsProvider for persistence.
final counterHapticsProvider = StateProvider<bool>((ref) {
  return ref.watch(settingsProvider.select((s) => s.counterHaptics));
});

/// Counter sound provider.
/// Delegates to settingsProvider for persistence.
final counterSoundProvider = StateProvider<CounterSound>((ref) {
  return ref.watch(settingsProvider.select((s) => s.counterSound));
});

/// Keep screen awake while counter active provider.
/// Delegates to settingsProvider for persistence.
final keepScreenAwakeProvider = StateProvider<bool>((ref) {
  return ref.watch(settingsProvider.select((s) => s.keepScreenAwake));
});
