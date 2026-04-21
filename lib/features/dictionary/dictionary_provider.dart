import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/stitch_entry.dart';

/// Provider that loads the stitch dictionary once and exposes search/filter.
///
/// The JSON is loaded from assets at startup and kept in memory.
/// All filtering is done in-memory for instant search response.
final stitchDictionaryProvider =
    StateNotifierProvider<StitchDictionaryNotifier, StitchDictionaryState>(
  (ref) => StitchDictionaryNotifier(),
);

/// Immutable state for the dictionary feature.
class StitchDictionaryState {
  const StitchDictionaryState({
    this.allEntries = const <StitchEntry>[],
    this.filteredEntries = const <StitchEntry>[],
    this.isLoading = true,
    this.error,
    this.searchQuery = '',
    this.selectedCraft = CraftFilter.all,
    this.selectedCategory,
  });

  final List<StitchEntry> allEntries;
  final List<StitchEntry> filteredEntries;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final CraftFilter selectedCraft;
  final String? selectedCategory;

  StitchDictionaryState copyWith({
    List<StitchEntry>? allEntries,
    List<StitchEntry>? filteredEntries,
    bool? isLoading,
    String? error,
    String? searchQuery,
    CraftFilter? selectedCraft,
    String? selectedCategory,
  }) {
    return StitchDictionaryState(
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      isLoading: isLoading ?? this.isLoading,
      error: error == _clearSentinel ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCraft: selectedCraft ?? this.selectedCraft,
      selectedCategory: selectedCategory == _clearSentinel
          ? null
          : (selectedCategory ?? this.selectedCategory),
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  StitchDictionaryState clearError() => copyWith(error: _clearSentinel);
  StitchDictionaryState clearCategory() => copyWith(selectedCategory: _clearSentinel);

  /// Get favourite-able entries (all of them).
  List<StitchEntry> get entries => filteredEntries;

  /// Check if a category is currently selected.
  bool isCategorySelected(String category) => selectedCategory == category;
}

/// Filter options for craft type.
enum CraftFilter { all, knitting, crochet }

/// Notifier that manages stitch dictionary state.
class StitchDictionaryNotifier extends StateNotifier<StitchDictionaryState> {
  StitchDictionaryNotifier() : super(const StitchDictionaryState()) {
    _loadDictionary();
  }

  /// Load stitches.json from assets.
  Future<void> _loadDictionary() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/stitches.json',
      );
      final jsonList = json.decode(jsonString) as List<dynamic>;
      final entries = jsonList
          .map((json) => StitchEntry.fromJson(json as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        allEntries: entries,
        filteredEntries: entries,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load stitch dictionary: $e',
      );
    }
  }

  /// Search entries by query string.
  void search(String query) {
    final lowerQuery = query.trim().toLowerCase();
    final filtered = _applyFilters(
      query: lowerQuery,
      craft: state.selectedCraft,
      category: state.selectedCategory,
    );
    state = state.copyWith(
      searchQuery: query,
      filteredEntries: filtered,
    );
  }

  /// Filter by craft type.
  void setCraftFilter(CraftFilter craft) {
    final filtered = _applyFilters(
      query: state.searchQuery.toLowerCase(),
      craft: craft,
      category: state.selectedCategory,
    );
    state = state.copyWith(
      selectedCraft: craft,
      filteredEntries: filtered,
    );
  }

  /// Filter by category.
  void setCategoryFilter(String? category) {
    final filtered = _applyFilters(
      query: state.searchQuery.toLowerCase(),
      craft: state.selectedCraft,
      category: category,
    );
    state = state.copyWith(
      selectedCategory: category,
      filteredEntries: filtered,
    );
  }

  /// Clear all filters.
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCraft: CraftFilter.all,
      selectedCategory: StitchDictionaryState._clearSentinel,
      filteredEntries: state.allEntries,
    );
  }

  /// Apply all active filters to the full entry list.
  List<StitchEntry> _applyFilters({
    required String query,
    required CraftFilter craft,
    required String? category,
  }) {
    return state.allEntries.where((entry) {
      // Craft filter.
      if (craft == CraftFilter.knitting && entry.craft != StitchCraft.knitting) {
        return false;
      }
      if (craft == CraftFilter.crochet && entry.craft != StitchCraft.crochet) {
        return false;
      }

      // Category filter.
      if (category != null && entry.category != category) {
        return false;
      }

      // Search query.
      if (query.isNotEmpty && !entry.matchesQuery(query)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get a single entry by ID.
  StitchEntry? getEntryById(String id) {
    try {
      return state.allEntries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
