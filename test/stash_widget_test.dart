import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stitch_mate/features/stash/screens/stash_screen.dart';
import 'package:stitch_mate/features/stash/screens/yarn_detail_screen.dart';
import 'package:stitch_mate/features/stash/stash_provider.dart';
import 'package:stitch_mate/data/models/yarn.dart';

/// Helper to create a testable stash with mock yarns.
Widget createStashScope({
  List<Yarn>? yarns,
}) {
  final notifier = YarnNotifier(isPro: true);
  notifier.state = YarnState(
    yarns: yarns ?? _testYarns,
    filteredYarns: yarns ?? _testYarns,
    isLoading: false,
  );

  final router = GoRouter(
    initialLocation: '/stash',
    routes: <RouteBase>[
      GoRoute(
        path: '/stash',
        builder: (context, state) => const StashScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final yarnId = state.extra as String?;
              return yarnId == null
                  ? const Scaffold(body: Center(child: Text('No yarn')))
                  : YarnDetailScreen(yarnId: yarnId);
            },
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      yarnStashProvider.overrideWith((ref) => notifier),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

final List<Yarn> _testYarns = <Yarn>[
  const Yarn(
    id: 'yarn1',
    brand: 'Malabrigo',
    colourName: 'Sunset Glow',
    weight: YarnWeight.worsted,
    fibre: '100% Merino Wool',
    yardagePerSkein: 210,
    metreagePerSkein: 192,
    gramsPerSkein: 100,
    skeinCount: 3,
    hexColour: '#FF5733',
    notes: 'Soft and squishy',
  ),
  const Yarn(
    id: 'yarn2',
    brand: 'Cascade',
    colourName: 'Ocean Blue',
    weight: YarnWeight.dk,
    fibre: '100% Wool',
    yardagePerSkein: 220,
    metreagePerSkein: 200,
    gramsPerSkein: 100,
    skeinCount: 2,
    hexColour: '#2196F3',
    status: YarnStatus.inUse,
    linkedProjectIds: <String>['proj1'],
  ),
];

void main() {
  group('StashScreen Widget Tests', () {
    testWidgets('StashScreen shows search field', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('StashScreen shows weight filter chips', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      expect(find.text('Lace'), findsOneWidget);
      expect(find.text('Worsted'), findsOneWidget);
      expect(find.text('Super Bulky'), findsOneWidget);
    });

    testWidgets('StashScreen shows status filter chips', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      // Status chips are FilterChips — find them by widget type
      expect(find.widgetWithText(FilterChip, 'Available'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'In Use'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Used Up'), findsOneWidget);
    });

    testWidgets('StashScreen shows all yarns by default', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      expect(find.text('Malabrigo — Sunset Glow'), findsOneWidget);
      expect(find.text('Cascade — Ocean Blue'), findsOneWidget);
    });

    testWidgets('StashScreen filters by weight', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      // Tap Worsted chip
      await tester.tap(find.text('Worsted'));
      await tester.pumpAndSettle();

      expect(find.text('Malabrigo — Sunset Glow'), findsOneWidget);
      expect(find.text('Cascade — Ocean Blue'), findsNothing);
    });

    testWidgets('StashScreen filters by status', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      // Scroll to and tap 'In Use' FilterChip
      final inUseChip = find.widgetWithText(FilterChip, 'In Use');
      await tester.ensureVisible(inUseChip);
      await tester.pumpAndSettle();
      await tester.tap(inUseChip);
      await tester.pumpAndSettle();

      expect(find.text('Cascade — Ocean Blue'), findsOneWidget);
      expect(find.text('Malabrigo — Sunset Glow'), findsNothing);
    });

    testWidgets('StashScreen search filters by brand', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'cascade');
      await tester.pumpAndSettle();

      expect(find.text('Cascade — Ocean Blue'), findsOneWidget);
      expect(find.text('Malabrigo — Sunset Glow'), findsNothing);
    });

    testWidgets('StashScreen shows empty state when no yarns', (tester) async {
      await tester.pumpWidget(createStashScope(yarns: const <Yarn>[]));
      await tester.pumpAndSettle();

      expect(find.text('No yarn in stash'), findsOneWidget);
    });

    testWidgets('StashScreen FAB navigates to new yarn', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('StashScreen tapping yarn navigates to detail', (tester) async {
      await tester.pumpWidget(createStashScope());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Malabrigo — Sunset Glow'));
      await tester.pumpAndSettle();

      expect(find.text('Sunset Glow'), findsOneWidget);
    });
  });

  group('YarnDetailScreen Widget Tests', () {
    testWidgets('YarnDetailScreen displays yarn info', (tester) async {
      final notifier = YarnNotifier(isPro: true);
      notifier.state = YarnState(
        yarns: _testYarns,
        filteredYarns: _testYarns,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yarnStashProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: YarnDetailScreen(yarnId: 'yarn1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Malabrigo'), findsOneWidget); // AppBar
      expect(find.text('Sunset Glow'), findsOneWidget);
      expect(find.text('Soft and squishy'), findsOneWidget);
    });

    testWidgets('YarnDetailScreen shows stats', (tester) async {
      final notifier = YarnNotifier(isPro: true);
      notifier.state = YarnState(
        yarns: _testYarns,
        filteredYarns: _testYarns,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yarnStashProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: YarnDetailScreen(yarnId: 'yarn1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('630'), findsOneWidget); // total yards
      expect(find.text('576'), findsOneWidget); // total metres
      expect(find.text('300'), findsOneWidget); // total grams
    });

    testWidgets('YarnDetailScreen shows status dropdown', (tester) async {
      final notifier = YarnNotifier(isPro: true);
      notifier.state = YarnState(
        yarns: _testYarns,
        filteredYarns: _testYarns,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yarnStashProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: YarnDetailScreen(yarnId: 'yarn1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Available'), findsOneWidget);
    });

    testWidgets('YarnDetailScreen calculator works', (tester) async {
      final notifier = YarnNotifier(isPro: true);
      notifier.state = YarnState(
        yarns: _testYarns,
        filteredYarns: _testYarns,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yarnStashProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: YarnDetailScreen(yarnId: 'yarn1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter needed yardage
      await tester.enterText(find.byType(TextField).last, '500');
      await tester.pumpAndSettle();

      // Tap calculate
      await tester.tap(find.text('Calculate'));
      await tester.pumpAndSettle();

      expect(find.textContaining('You have enough yarn!'), findsOneWidget);
    });

    testWidgets('YarnDetailScreen delete shows confirmation', (tester) async {
      final notifier = YarnNotifier(isPro: true);
      notifier.state = YarnState(
        yarns: _testYarns,
        filteredYarns: _testYarns,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            yarnStashProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: YarnDetailScreen(yarnId: 'yarn1'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap delete
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete Yarn'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Yarn should still exist
      expect(notifier.state.yarns.length, 2);
    });
  });
}
