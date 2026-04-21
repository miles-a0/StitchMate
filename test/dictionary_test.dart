import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_mate/data/models/stitch_entry.dart';
import 'package:stitch_mate/features/dictionary/dictionary_provider.dart';
import 'package:stitch_mate/features/dictionary/favourites_provider.dart';

void main() {
  group('StitchEntry Model', () {
    test('StitchEntry fromJson parses correctly', () {
      final json = <String, dynamic>{
        'id': 'k2tog',
        'abbreviation': 'k2tog',
        'fullName': 'Knit Two Together',
        'craft': 'knitting',
        'category': 'decrease',
        'difficulty': 'beginner',
        'description': 'Decrease one stitch.',
        'steps': <String>['Insert needle into 2 stitches.', 'Knit together.'],
        'also_known_as': <String>[],
        'usRegion': true,
        'ukRegion': true,
      };

      final entry = StitchEntry.fromJson(json);

      expect(entry.id, 'k2tog');
      expect(entry.abbreviation, 'k2tog');
      expect(entry.fullName, 'Knit Two Together');
      expect(entry.craft, 'knitting');
      expect(entry.category, 'decrease');
      expect(entry.difficulty, 'beginner');
      expect(entry.description, 'Decrease one stitch.');
      expect(entry.steps.length, 2);
      expect(entry.usRegion, true);
      expect(entry.ukRegion, true);
    });

    test('StitchEntry toJson round-trips correctly', () {
      const entry = StitchEntry(
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
      );

      final json = entry.toJson();
      final restored = StitchEntry.fromJson(json);

      expect(restored.id, entry.id);
      expect(restored.abbreviation, entry.abbreviation);
      expect(restored.steps, entry.steps);
      expect(restored.alsoKnownAs, entry.alsoKnownAs);
    });

    test('StitchEntry matchesQuery by abbreviation', () {
      const entry = StitchEntry(
        id: 'k2tog',
        abbreviation: 'k2tog',
        fullName: 'Knit Two Together',
        craft: 'knitting',
        category: 'decrease',
        difficulty: 'beginner',
        description: 'Desc',
        steps: <String>[],
        alsoKnownAs: <String>[],
        usRegion: true,
        ukRegion: true,
      );

      expect(entry.matchesQuery('k2'), true);
      expect(entry.matchesQuery('K2'), true);
      expect(entry.matchesQuery('xyz'), false);
    });

    test('StitchEntry matchesQuery by fullName', () {
      const entry = StitchEntry(
        id: 'k2tog',
        abbreviation: 'k2tog',
        fullName: 'Knit Two Together',
        craft: 'knitting',
        category: 'decrease',
        difficulty: 'beginner',
        description: 'Desc',
        steps: <String>[],
        alsoKnownAs: <String>[],
        usRegion: true,
        ukRegion: true,
      );

      expect(entry.matchesQuery('knit'), true);
      expect(entry.matchesQuery('Together'), true);
      expect(entry.matchesQuery('purl'), false);
    });

    test('StitchEntry matchesQuery by alsoKnownAs', () {
      const entry = StitchEntry(
        id: 'kfb',
        abbreviation: 'kfb',
        fullName: 'Knit Front and Back',
        craft: 'knitting',
        category: 'increase',
        difficulty: 'beginner',
        description: 'Desc',
        steps: <String>[],
        alsoKnownAs: <String>['Bar Increase'],
        usRegion: true,
        ukRegion: true,
      );

      expect(entry.matchesQuery('bar'), true);
      expect(entry.matchesQuery('increase'), true);
      expect(entry.matchesQuery('ssk'), false);
    });
  });

  group('StitchDictionaryState', () {
    test('copyWith updates fields', () {
      const state = StitchDictionaryState();
      final updated = state.copyWith(
        searchQuery: 'k2tog',
        selectedCraft: CraftFilter.knitting,
      );

      expect(updated.searchQuery, 'k2tog');
      expect(updated.selectedCraft, CraftFilter.knitting);
      expect(updated.isLoading, true); // unchanged
    });

    test('clearError removes error', () {
      const state = StitchDictionaryState(error: 'Some error');
      final cleared = state.clearError();

      expect(cleared.error, null);
    });

    test('clearCategory removes category', () {
      const state = StitchDictionaryState(selectedCategory: 'basic');
      final cleared = state.clearCategory();

      expect(cleared.selectedCategory, null);
    });

    test('isCategorySelected works correctly', () {
      const state = StitchDictionaryState(selectedCategory: 'decrease');

      expect(state.isCategorySelected('decrease'), true);
      expect(state.isCategorySelected('basic'), false);
    });
  });

  group('FavouritesState', () {
    test('isFavourite returns correct value', () {
      const state = FavouritesState(favouriteIds: <String>['k2tog', 'yo']);

      expect(state.isFavourite('k2tog'), true);
      expect(state.isFavourite('yo'), true);
      expect(state.isFavourite('ssk'), false);
    });

    test('copyWith updates fields', () {
      const state = FavouritesState();
      final updated = state.copyWith(favouriteIds: <String>['k2tog']);

      expect(updated.favouriteIds, <String>['k2tog']);
      expect(updated.isLoading, true); // unchanged
    });

    test('clearError removes error', () {
      const state = FavouritesState(error: 'Error');
      final cleared = state.clearError();

      expect(cleared.error, null);
    });
  });

  group('FavouritesNotifier Logic', () {
    test('toggleFavourite adds and removes', () {
      final notifier = FavouritesNotifier(isPro: true);

      // Add
      final added = notifier.toggleFavourite('k2tog');
      expect(added, true);
      expect(notifier.state.isFavourite('k2tog'), true);

      // Remove
      final removed = notifier.toggleFavourite('k2tog');
      expect(removed, true);
      expect(notifier.state.isFavourite('k2tog'), false);
    });

    test('toggleFavourite blocked for free tier', () {
      final notifier = FavouritesNotifier(isPro: false);

      final result = notifier.toggleFavourite('k2tog');
      expect(result, false);
      expect(notifier.state.isFavourite('k2tog'), false);
    });

    test('addFavourite adds id', () {
      final notifier = FavouritesNotifier(isPro: true);

      final result = notifier.addFavourite('yo');
      expect(result, true);
      expect(notifier.state.isFavourite('yo'), true);
    });

    test('addFavourite blocked for free tier', () {
      final notifier = FavouritesNotifier(isPro: false);

      final result = notifier.addFavourite('yo');
      expect(result, false);
    });

    test('removeFavourite removes id', () {
      final notifier = FavouritesNotifier(isPro: true);
      notifier.addFavourite('yo');

      final result = notifier.removeFavourite('yo');
      expect(result, true);
      expect(notifier.state.isFavourite('yo'), false);
    });

    test('removeFavourite blocked for free tier', () {
      final notifier = FavouritesNotifier(isPro: true);
      notifier.addFavourite('yo');

      final freeNotifier = FavouritesNotifier(isPro: false);
      freeNotifier.addFavourite('yo'); // Should be blocked
      expect(freeNotifier.state.isFavourite('yo'), false);
    });

    test('multiple favourites tracked independently', () {
      final notifier = FavouritesNotifier(isPro: true);

      notifier.addFavourite('k2tog');
      notifier.addFavourite('ssk');
      notifier.addFavourite('yo');

      expect(notifier.state.favouriteIds.length, 3);
      expect(notifier.state.isFavourite('k2tog'), true);
      expect(notifier.state.isFavourite('ssk'), true);
      expect(notifier.state.isFavourite('yo'), true);
    });
  });
}
