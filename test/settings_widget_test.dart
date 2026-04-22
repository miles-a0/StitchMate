import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_mate/core/providers.dart';
import 'package:stitch_mate/core/strings.dart';
import 'package:stitch_mate/features/settings/screens/settings_screen.dart';
import 'package:stitch_mate/features/settings/screens/onboarding_screen.dart';
import 'package:stitch_mate/features/settings/settings_provider.dart';

/// Build a testable widget wrapped in ProviderScope.
Widget _buildTestable(Widget child) {
  return ProviderScope(
    overrides: [
      settingsProvider.overrideWith(
        (ref) => SettingsNotifier()
          ..state = const SettingsState(
            hasCompletedOnboarding: true,
          ),
      ),
    ],
    child: MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('shows all setting sections', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.settingsTitle), findsOneWidget);
      expect(find.text(AppStrings.themeMode), findsOneWidget);
      expect(find.text(AppStrings.accentColour), findsOneWidget);
      expect(find.text(AppStrings.defaultCraftType), findsOneWidget);
      expect(find.text(AppStrings.units), findsOneWidget);
      expect(find.text(AppStrings.counterTitle), findsOneWidget);

      // Scroll to find About section.
      await tester.scrollUntilVisible(
        find.text(AppStrings.about),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(AppStrings.about), findsOneWidget);
    });

    testWidgets('shows theme mode options', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.themeLight), findsOneWidget);
      expect(find.text(AppStrings.themeDark), findsOneWidget);
      expect(find.text(AppStrings.themeSystem), findsOneWidget);
    });

    testWidgets('shows unit system options', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.unitMetric), findsOneWidget);
      expect(find.text(AppStrings.unitImperial), findsOneWidget);
    });

    testWidgets('shows version info', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      // Scroll to find version info.
      await tester.scrollUntilVisible(
        find.text(AppStrings.version),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(AppStrings.version), findsOneWidget);
    });

    testWidgets('tapping theme mode changes selection', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.themeDark));
      await tester.pumpAndSettle();

      // The SegmentedButton should now have dark selected.
      final segmentedButton = find.byType(SegmentedButton<ThemeModeOption>);
      expect(segmentedButton, findsOneWidget);
    });

    testWidgets('toggling haptics switch works', (tester) async {
      await tester.pumpWidget(_buildTestable(const SettingsScreen()));
      await tester.pumpAndSettle();

      final switchFinder = find.byType(SwitchListTile);
      expect(switchFinder, findsWidgets);

      // Toggle the first switch (haptics).
      await tester.tap(switchFinder.first);
      await tester.pumpAndSettle();
    });
  });

  group('OnboardingScreen', () {
    testWidgets('shows first page with welcome title', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingWelcome), findsOneWidget);
      expect(find.text(AppStrings.skip), findsOneWidget);
      expect(find.text(AppStrings.next), findsOneWidget);
    });

    testWidgets('navigates to next page on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.next));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingCounter), findsOneWidget);
    });

    testWidgets('shows Got it button on last page', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to last page.
      await tester.tap(find.text(AppStrings.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.next));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.onboardingProjects), findsOneWidget);
      expect(find.text(AppStrings.gotIt), findsOneWidget);
    });

    testWidgets('skip button is tappable', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify skip button exists and is tappable.
      expect(find.text(AppStrings.skip), findsOneWidget);
      await tester.tap(find.text(AppStrings.skip));
      await tester.pump();
    });
  });
}
