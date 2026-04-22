import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stitch_mate/features/dictionary/screens/dictionary_screen.dart';
import 'package:stitch_mate/features/dictionary/screens/stitch_detail_screen.dart';
import 'package:stitch_mate/features/dictionary/dictionary_provider.dart';
import 'package:stitch_mate/features/dictionary/favourites_provider.dart';
import 'package:stitch_mate/data/models/stitch_entry.dart';

/// Helper to create a testable dictionary with mock entries.
Widget createDictionaryScope({
  List<StitchEntry>? entries,
  List<String>? favouriteIds,
  bool isPro = false,
}) {
  final dictNotifier = StitchDictionaryNotifier();
  // Override state directly with test data.
  dictNotifier.state = StitchDictionaryState(
    allEntries: entries ?? _testEntries,
    filteredEntries: entries ?? _testEntries,
    isLoading: false,
  );

  final favNotifier = FavouritesNotifier(isPro: isPro);
  favNotifier.state = FavouritesState(
    favouriteIds: favouriteIds ?? const <String>[],
    isLoading: false,
  );

  final router = GoRouter(
    initialLocation: '/dictionary',
    routes: <RouteBase>[
      GoRoute(
        path: '/dictionary',
        builder: (context, state) => const DictionaryScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final stitchId = state.extra as String?;
              return stitchId == null
                  ? const Scaffold(body: Center(child: Text('No stitch')))
                  : StitchDetailScreen(stitchId: stitchId);
            },
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
      stitchFavouritesProvider.overrideWith((ref) => favNotifier),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

final List<StitchEntry> _testEntries = <StitchEntry>[
  const StitchEntry(
    id: 'k2tog',
    abbreviation: 'k2tog',
    fullName: 'Knit Two Together',
    craft: 'knitting',
    category: 'decrease',
    difficulty: 'beginner',
    description: 'Decrease one stitch by knitting two together.',
    steps: <String>['Insert needle into 2 stitches.', 'Knit together.'],
    alsoKnownAs: <String>[],
    usRegion: true,
    ukRegion: true,
  ),
  const StitchEntry(
    id: 'sc',
    abbreviation: 'sc',
    fullName: 'Single Crochet',
    craft: 'crochet',
    category: 'basic',
    difficulty: 'beginner',
    description: 'The shortest standard crochet stitch.',
    steps: <String>[
      'Insert hook.',
      'Yarn over and pull up loop.',
      'Pull through both loops.'
    ],
    alsoKnownAs: <String>[],
    usRegion: true,
    ukRegion: false,
  ),
  const StitchEntry(
    id: 'yo',
    abbreviation: 'yo',
    fullName: 'Yarn Over',
    craft: 'knitting',
    category: 'increase',
    difficulty: 'beginner',
    description: 'Create an extra stitch.',
    steps: <String>['Bring yarn to front.', 'Knit next stitch.'],
    alsoKnownAs: <String>['Yarn Forward'],
    usRegion: true,
    ukRegion: true,
  ),
];

void main() {
  group('DictionaryScreen Widget Tests', () {
    testWidgets('DictionaryScreen shows search field', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search abbreviations or names...'), findsOneWidget);
    });

    testWidgets('DictionaryScreen shows craft filter tabs', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      expect(find.text('Both'), findsOneWidget);
      expect(find.text('Knitting'), findsOneWidget);
      expect(find.text('Crochet'), findsOneWidget);
    });

    testWidgets('DictionaryScreen shows category chips', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('Increases'), findsOneWidget);
      expect(find.text('Decreases'), findsOneWidget);
      expect(find.text('Cables'), findsOneWidget);
      expect(find.text('Lace'), findsOneWidget);
      expect(find.text('Special Techniques'), findsOneWidget);
    });

    testWidgets('DictionaryScreen shows all entries by default',
        (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      // Use find.text with full name to avoid ambiguity with avatar abbreviations.
      expect(find.text('Knit Two Together'), findsOneWidget);
      expect(find.text('Single Crochet'), findsOneWidget);
      expect(find.text('Yarn Over'), findsOneWidget);
    });

    testWidgets('DictionaryScreen filters by craft type', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      // Tap Crochet tab
      await tester.tap(find.text('Crochet'));
      await tester.pumpAndSettle();

      // Should only show crochet entries (use full names to avoid ambiguity)
      expect(find.text('Single Crochet'), findsOneWidget);
      expect(find.text('Knit Two Together'), findsNothing);
      expect(find.text('Yarn Over'), findsNothing);
    });

    testWidgets('DictionaryScreen filters by category', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      // Tap Decreases chip
      await tester.tap(find.text('Decreases'));
      await tester.pumpAndSettle();

      expect(find.text('k2tog'), findsOneWidget);
      expect(find.text('yo'), findsNothing);
      expect(find.text('sc'), findsNothing);
    });

    testWidgets('DictionaryScreen search filters entries', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      // Type in search field
      await tester.enterText(find.byType(TextField), 'k2');
      await tester.pumpAndSettle();

      expect(find.text('k2tog'), findsOneWidget);
      expect(find.text('sc'), findsNothing);
      expect(find.text('yo'), findsNothing);
    });

    testWidgets('DictionaryScreen search by full name', (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'crochet');
      await tester.pumpAndSettle();

      expect(find.text('Single Crochet'), findsOneWidget);
      expect(find.text('Knit Two Together'), findsNothing);
    });

    testWidgets('DictionaryScreen shows empty state when no matches',
        (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('DictionaryScreen shows favourite stars', (tester) async {
      await tester.pumpWidget(
        createDictionaryScope(
          favouriteIds: const <String>['k2tog'],
        ),
      );
      await tester.pumpAndSettle();

      // Should find star icons for favourites
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('DictionaryScreen tapping entry navigates to detail',
        (tester) async {
      await tester.pumpWidget(createDictionaryScope());
      await tester.pumpAndSettle();

      // Tap on the ListTile containing k2tog (tap the full name text)
      await tester.tap(find.text('Knit Two Together'));
      await tester.pumpAndSettle();

      // Should show detail screen
      expect(find.text('Knit Two Together'), findsOneWidget);
    });
  });

  group('StitchDetailScreen Widget Tests', () {
    testWidgets('StitchDetailScreen displays stitch info', (tester) async {
      final dictNotifier = StitchDictionaryNotifier();
      dictNotifier.state = StitchDictionaryState(
        allEntries: _testEntries,
        filteredEntries: _testEntries,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
            stitchFavouritesProvider.overrideWith(
              (ref) => FavouritesNotifier(isPro: true),
            ),
          ],
          child: const MaterialApp(
            home: StitchDetailScreen(stitchId: 'k2tog'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('k2tog'), findsOneWidget); // AppBar title
      expect(find.text('Knit Two Together'), findsOneWidget);
      expect(find.text('Decrease one stitch by knitting two together.'),
          findsOneWidget);
    });

    testWidgets('StitchDetailScreen shows steps', (tester) async {
      final dictNotifier = StitchDictionaryNotifier();
      dictNotifier.state = StitchDictionaryState(
        allEntries: _testEntries,
        filteredEntries: _testEntries,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
            stitchFavouritesProvider.overrideWith(
              (ref) => FavouritesNotifier(isPro: true),
            ),
          ],
          child: const MaterialApp(
            home: StitchDetailScreen(stitchId: 'k2tog'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Insert needle into 2 stitches.'), findsOneWidget);
    });

    testWidgets('StitchDetailScreen shows region indicators', (tester) async {
      final dictNotifier = StitchDictionaryNotifier();
      dictNotifier.state = StitchDictionaryState(
        allEntries: _testEntries,
        filteredEntries: _testEntries,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
            stitchFavouritesProvider.overrideWith(
              (ref) => FavouritesNotifier(isPro: true),
            ),
          ],
          child: const MaterialApp(
            home: StitchDetailScreen(stitchId: 'k2tog'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('US'), findsOneWidget);
      expect(find.text('UK'), findsOneWidget);
    });

    testWidgets('StitchDetailScreen favourite toggle for Pro', (tester) async {
      final dictNotifier = StitchDictionaryNotifier();
      dictNotifier.state = StitchDictionaryState(
        allEntries: _testEntries,
        filteredEntries: _testEntries,
        isLoading: false,
      );

      final favNotifier = FavouritesNotifier(isPro: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
            stitchFavouritesProvider.overrideWith((ref) => favNotifier),
          ],
          child: const MaterialApp(
            home: StitchDetailScreen(stitchId: 'k2tog'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap star to favourite
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      expect(favNotifier.state.isFavourite('k2tog'), true);

      // Tap again to unfavourite
      await tester.tap(find.byIcon(Icons.star));
      await tester.pumpAndSettle();

      expect(favNotifier.state.isFavourite('k2tog'), false);
    });

    testWidgets('StitchDetailScreen favourite blocked for free tier',
        (tester) async {
      final dictNotifier = StitchDictionaryNotifier();
      dictNotifier.state = StitchDictionaryState(
        allEntries: _testEntries,
        filteredEntries: _testEntries,
        isLoading: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stitchDictionaryProvider.overrideWith((ref) => dictNotifier),
            stitchFavouritesProvider.overrideWith(
              (ref) => FavouritesNotifier(isPro: false),
            ),
          ],
          child: const MaterialApp(
            home: StitchDetailScreen(stitchId: 'k2tog'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap star — should show Pro dialog
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      expect(find.text('Pro Feature'), findsOneWidget);
    });
  });
}
