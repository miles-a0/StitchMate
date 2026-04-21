import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/hive_init.dart';

/// Provider for favourite stitch IDs.
///
/// Pro-gated: free tier can read favourites but not add/remove.
/// All changes persist to Hive immediately.
final stitchFavouritesProvider =
    StateNotifierProvider<FavouritesNotifier, FavouritesState>((ref) {
  final isPro = ref.watch(proStatusProvider);
  return FavouritesNotifier(isPro: isPro);
});

/// Immutable state for favourites.
class FavouritesState {
  const FavouritesState({
    this.favouriteIds = const <String>[],
    this.isLoading = true,
    this.error,
  });

  final List<String> favouriteIds;
  final bool isLoading;
  final String? error;

  FavouritesState copyWith({
    List<String>? favouriteIds,
    bool? isLoading,
    String? error,
  }) {
    return FavouritesState(
      favouriteIds: favouriteIds ?? this.favouriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: error == _clearSentinel ? null : (error ?? this.error),
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  FavouritesState clearError() => copyWith(error: _clearSentinel);

  /// Check if a stitch ID is favourited.
  bool isFavourite(String id) => favouriteIds.contains(id);

  @override
  String toString() {
    return 'FavouritesState(count: ${favouriteIds.length})';
  }
}

/// Notifier that manages favourite stitch IDs with Hive persistence.
class FavouritesNotifier extends StateNotifier<FavouritesState> {
  FavouritesNotifier({required bool isPro})
      : _isPro = isPro,
        super(const FavouritesState()) {
    _loadFromHive();
  }

  final bool _isPro;
  static const String _hiveKey = 'stitch_favourites';

  /// Load favourites from Hive.
  void _loadFromHive() {
    try {
      final box = HiveInit.dictionaryBox;
      final saved = box.get(_hiveKey);
      if (saved is List<dynamic>) {
        final ids = saved.cast<String>();
        state = state.copyWith(favouriteIds: ids, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      // Hive not initialised in test environment.
      state = state.copyWith(isLoading: false);
    }
  }

  /// Toggle favourite status for a stitch ID.
  ///
  /// Returns true if successful, false if Pro is required.
  bool toggleFavourite(String id) {
    if (!_isPro) {
      return false; // Pro feature — cannot modify.
    }

    final currentIds = List<String>.from(state.favouriteIds);
    if (currentIds.contains(id)) {
      currentIds.remove(id);
    } else {
      currentIds.add(id);
    }

    state = state.copyWith(favouriteIds: currentIds);
    _persist(currentIds);
    return true;
  }

  /// Add a favourite.
  bool addFavourite(String id) {
    if (!_isPro) return false;
    if (state.favouriteIds.contains(id)) return true;

    final updated = List<String>.from(state.favouriteIds)..add(id);
    state = state.copyWith(favouriteIds: updated);
    _persist(updated);
    return true;
  }

  /// Remove a favourite.
  bool removeFavourite(String id) {
    if (!_isPro) return false;
    if (!state.favouriteIds.contains(id)) return true;

    final updated = List<String>.from(state.favouriteIds)..remove(id);
    state = state.copyWith(favouriteIds: updated);
    _persist(updated);
    return true;
  }

  /// Persist favourites to Hive.
  void _persist(List<String> ids) {
    try {
      HiveInit.dictionaryBox.put(_hiveKey, ids);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }
}
