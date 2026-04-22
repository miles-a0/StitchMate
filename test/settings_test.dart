import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_mate/core/providers.dart';
import 'package:stitch_mate/data/models/project.dart';
import 'package:stitch_mate/features/settings/settings_provider.dart';

void main() {
  group('SettingsState', () {
    test('default state has expected values', () {
      const state = SettingsState();

      expect(state.themeMode, ThemeModeOption.system);
      expect(state.accentColour, AccentColour.mauve);
      expect(state.defaultCraftType, CraftType.knit);
      expect(state.unitSystem, UnitSystem.metric);
      expect(state.counterHaptics, true);
      expect(state.counterSound, CounterSound.off);
      expect(state.keepScreenAwake, true);
      expect(state.hasCompletedOnboarding, false);
    });

    test('copyWith updates fields', () {
      const state = SettingsState();
      final updated = state.copyWith(
        themeMode: ThemeModeOption.dark,
        counterHaptics: false,
        hasCompletedOnboarding: true,
      );

      expect(updated.themeMode, ThemeModeOption.dark);
      expect(updated.counterHaptics, false);
      expect(updated.hasCompletedOnboarding, true);
      expect(updated.accentColour, AccentColour.mauve); // unchanged
    });
  });

  group('SettingsNotifier', () {
    late SettingsNotifier notifier;

    setUp(() {
      notifier = SettingsNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state uses defaults', () {
      expect(notifier.state.themeMode, ThemeModeOption.system);
      expect(notifier.state.counterHaptics, true);
    });

    test('setThemeMode updates state', () async {
      await notifier.setThemeMode(ThemeModeOption.dark);
      expect(notifier.state.themeMode, ThemeModeOption.dark);
    });

    test('setAccentColour updates state', () async {
      await notifier.setAccentColour(AccentColour.teal);
      expect(notifier.state.accentColour, AccentColour.teal);
    });

    test('setDefaultCraftType updates state', () async {
      await notifier.setDefaultCraftType(CraftType.crochet);
      expect(notifier.state.defaultCraftType, CraftType.crochet);
    });

    test('setUnitSystem updates state', () async {
      await notifier.setUnitSystem(UnitSystem.imperial);
      expect(notifier.state.unitSystem, UnitSystem.imperial);
    });

    test('setCounterHaptics updates state', () async {
      await notifier.setCounterHaptics(false);
      expect(notifier.state.counterHaptics, false);
    });

    test('setCounterSound updates state', () async {
      await notifier.setCounterSound(CounterSound.loud);
      expect(notifier.state.counterSound, CounterSound.loud);
    });

    test('setKeepScreenAwake updates state', () async {
      await notifier.setKeepScreenAwake(false);
      expect(notifier.state.keepScreenAwake, false);
    });

    test('completeOnboarding updates state', () async {
      await notifier.completeOnboarding();
      expect(notifier.state.hasCompletedOnboarding, true);
    });
  });
}
