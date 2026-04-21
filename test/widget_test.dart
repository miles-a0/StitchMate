import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stitch_mate/main.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('StitchMateApp builds without error', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: StitchMateApp()),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('ScaffoldWithNavBar renders on narrow screens', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: StitchMateApp()),
      );
      await tester.pumpAndSettle();

      // Verify the scaffold with nav bar is present by looking for nav labels.
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Dictionary'), findsOneWidget);
      expect(find.text('Stash'), findsOneWidget);
      expect(find.text('Tools'), findsOneWidget);
    });

    testWidgets('NavigationRail appears on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: StitchMateApp()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('BottomNavigationBar appears on narrow screens',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: StitchMateApp()),
      );
      await tester.pumpAndSettle();

      // On narrow screens we should see the nav labels in a BottomNavigationBar.
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
    });

    testWidgets('Tapping nav items switches tabs', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: StitchMateApp()),
      );
      await tester.pumpAndSettle();

      // Tap Projects tab
      await tester.tap(find.text('Projects'));
      await tester.pumpAndSettle();

      expect(find.text('Projects Screen — Sprint 2'), findsOneWidget);

      // Tap Dictionary tab
      await tester.tap(find.text('Dictionary'));
      await tester.pumpAndSettle();

      expect(find.text('Dictionary Screen — Sprint 3'), findsOneWidget);
    });
  });
}
