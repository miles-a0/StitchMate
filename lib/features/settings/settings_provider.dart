import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers.dart';
import '../../data/models/project.dart';

/// Immutable state class for app settings.
class SettingsState {
  const SettingsState({
    this.themeMode = ThemeModeOption.system,
    this.accentColour = AccentColour.mauve,
    this.defaultCraftType = CraftType.knit,
    this.unitSystem = UnitSystem.metric,
    this.counterHaptics = true,
    this.counterSound = CounterSound.off,
    this.keepScreenAwake = true,
    this.hasCompletedOnboarding = false,
    this.isLoading = false,
    this.error,
  });

  final ThemeModeOption themeMode;
  final AccentColour accentColour;
  final CraftType defaultCraftType;
  final UnitSystem unitSystem;
  final bool counterHaptics;
  final CounterSound counterSound;
  final bool keepScreenAwake;
  final bool hasCompletedOnboarding;
  final bool isLoading;
  final String? error;

  SettingsState copyWith({
    ThemeModeOption? themeMode,
    AccentColour? accentColour,
    CraftType? defaultCraftType,
    UnitSystem? unitSystem,
    bool? counterHaptics,
    CounterSound? counterSound,
    bool? keepScreenAwake,
    bool? hasCompletedOnboarding,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      accentColour: accentColour ?? this.accentColour,
      defaultCraftType: defaultCraftType ?? this.defaultCraftType,
      unitSystem: unitSystem ?? this.unitSystem,
      counterHaptics: counterHaptics ?? this.counterHaptics,
      counterSound: counterSound ?? this.counterSound,
      keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Accent colour options.
enum AccentColour {
  mauve,
  teal,
  coral,
  sage,
  indigo,
  rust,
}

/// Counter sound options.
enum CounterSound {
  off,
  soft,
  loud,
}

/// Riverpod StateNotifier for app settings.
///
/// All settings persist to SharedPreferences immediately.
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadFromPrefs();
  }

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyAccentColour = 'accent_colour';
  static const String _keyDefaultCraft = 'default_craft';
  static const String _keyUnitSystem = 'unit_system';
  static const String _keyCounterHaptics = 'counter_haptics';
  static const String _keyCounterSound = 'counter_sound';
  static const String _keyKeepScreenAwake = 'keep_screen_awake';
  static const String _keyOnboarding = 'onboarding_completed';

  /// Load all settings from SharedPreferences.
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = state.copyWith(
        themeMode: ThemeModeOption.values[
            prefs.getInt(_keyThemeMode) ?? ThemeModeOption.system.index],
        accentColour: AccentColour
            .values[prefs.getInt(_keyAccentColour) ?? AccentColour.mauve.index],
        defaultCraftType: CraftType
            .values[prefs.getInt(_keyDefaultCraft) ?? CraftType.knit.index],
        unitSystem: UnitSystem
            .values[prefs.getInt(_keyUnitSystem) ?? UnitSystem.metric.index],
        counterHaptics: prefs.getBool(_keyCounterHaptics) ?? true,
        counterSound: CounterSound
            .values[prefs.getInt(_keyCounterSound) ?? CounterSound.off.index],
        keepScreenAwake: prefs.getBool(_keyKeepScreenAwake) ?? true,
        hasCompletedOnboarding: prefs.getBool(_keyOnboarding) ?? false,
      );
    } catch (_) {
      // SharedPreferences not available in test environment.
    }
  }

  /// Set theme mode.
  Future<void> setThemeMode(ThemeModeOption value) async {
    state = state.copyWith(themeMode: value);
    await _setInt(_keyThemeMode, value.index);
  }

  /// Set accent colour.
  Future<void> setAccentColour(AccentColour value) async {
    state = state.copyWith(accentColour: value);
    await _setInt(_keyAccentColour, value.index);
  }

  /// Set default craft type.
  Future<void> setDefaultCraftType(CraftType value) async {
    state = state.copyWith(defaultCraftType: value);
    await _setInt(_keyDefaultCraft, value.index);
  }

  /// Set unit system.
  Future<void> setUnitSystem(UnitSystem value) async {
    state = state.copyWith(unitSystem: value);
    await _setInt(_keyUnitSystem, value.index);
  }

  /// Set counter haptics.
  Future<void> setCounterHaptics(bool value) async {
    state = state.copyWith(counterHaptics: value);
    await _setBool(_keyCounterHaptics, value);
  }

  /// Set counter sound.
  Future<void> setCounterSound(CounterSound value) async {
    state = state.copyWith(counterSound: value);
    await _setInt(_keyCounterSound, value.index);
  }

  /// Set keep screen awake.
  Future<void> setKeepScreenAwake(bool value) async {
    state = state.copyWith(keepScreenAwake: value);
    await _setBool(_keyKeepScreenAwake, value);
  }

  /// Mark onboarding as completed.
  Future<void> completeOnboarding() async {
    state = state.copyWith(hasCompletedOnboarding: true);
    await _setBool(_keyOnboarding, true);
  }

  // ── SharedPreferences helpers ──

  Future<void> _setInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } catch (_) {
      // SharedPreferences not available in test environment.
    }
  }

  Future<void> _setBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (_) {
      // SharedPreferences not available in test environment.
    }
  }
}

/// Provider for settings state.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
