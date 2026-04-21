import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stitch_mate/features/counter/screens/counter_screen.dart';

void main() {
  group('CounterScreen Widget Tests', () {
    testWidgets('CounterScreen displays initial value', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CounterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Tapping increment button increases value', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CounterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the increment button (the large button with add icon).
      final incrementButton = find.byIcon(Icons.add);
      expect(incrementButton, findsOneWidget);

      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Lock button toggles lock state', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CounterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Increment first to verify later that lock works.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Find all IconButtons in the AppBar and tap the first one (lock toggle).
      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsAtLeastNWidgets(2));
      await tester.tap(iconButtons.first);
      await tester.pumpAndSettle();

      // Try to increment while locked (tap the lock icon in the AppBar).
      final lockInAppBar = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.lock),
      );
      await tester.tap(lockInAppBar);
      await tester.pumpAndSettle();

      // Value should still be 1 because counter is locked.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Reset shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CounterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Increment a few times.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      // Tap reset.
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Confirmation dialog should appear.
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Are you sure you want to reset the counter to 0?'),
          findsOneWidget);

      // Cancel.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Value should still be 2.
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('Reset confirms and resets to 0', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CounterScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Increment.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);

      // Tap reset.
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Confirm reset.
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Value should be 0.
      expect(find.text('0'), findsOneWidget);
    });
  });
}
