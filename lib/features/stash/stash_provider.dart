import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers.dart';
import '../../data/local/hive_init.dart';
import '../../data/models/yarn.dart';

/// Provider for yarn stash state.
final yarnStashProvider = StateNotifierProvider<YarnNotifier, YarnState>(
  (ref) => YarnNotifier(isPro: ref.watch(proStatusProvider)),
);

/// Immutable state for yarn stash.
class YarnState {
  const YarnState({
    this.yarns = const <Yarn>[],
    this.filteredYarns = const <Yarn>[],
    this.isLoading = true,
    this.error,
    this.searchQuery = '',
    this.selectedWeight,
    this.selectedStatus,
  });

  final List<Yarn> yarns;
  final List<Yarn> filteredYarns;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedWeight;
  final String? selectedStatus;

  YarnState copyWith({
    List<Yarn>? yarns,
    List<Yarn>? filteredYarns,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedWeight,
    String? selectedStatus,
  }) {
    return YarnState(
      yarns: yarns ?? this.yarns,
      filteredYarns: filteredYarns ?? this.filteredYarns,
      isLoading: isLoading ?? this.isLoading,
      error: error == _clearSentinel ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedWeight: selectedWeight == _clearSentinel
          ? null
          : (selectedWeight ?? this.selectedWeight),
      selectedStatus: selectedStatus == _clearSentinel
          ? null
          : (selectedStatus ?? this.selectedStatus),
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  YarnState clearError() => copyWith(error: _clearSentinel);
  YarnState clearWeight() => copyWith(selectedWeight: _clearSentinel);
  YarnState clearStatus() => copyWith(selectedStatus: _clearSentinel);

  /// Total skeins in stash.
  int get totalSkeins => yarns.fold(0, (sum, y) => sum + y.skeinCount);

  /// Total unique yarns.
  int get totalYarns => yarns.length;
}

/// Notifier that manages yarn stash with Hive persistence.
class YarnNotifier extends StateNotifier<YarnState> {
  YarnNotifier({required bool isPro}) : super(const YarnState()) {
    _loadFromHive();
  }

  static const String _hiveKey = 'yarn_list';
  final _uuid = const Uuid();

  /// Load yarns from Hive.
  void _loadFromHive() {
    try {
      final box = HiveInit.yarnBox;
      final saved = box.get(_hiveKey);
      if (saved is List<dynamic>) {
        final yarns = saved.cast<Yarn>();
        state = state.copyWith(
          yarns: yarns,
          filteredYarns: yarns,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Persist yarns to Hive.
  void _persist() {
    try {
      HiveInit.yarnBox.put(_hiveKey, state.yarns);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  /// Create a new yarn entry.
  void createYarn({
    required String brand,
    required String colourName,
    required String weight,
    required String fibre,
    required int yardagePerSkein,
    required int metreagePerSkein,
    required int gramsPerSkein,
    required int skeinCount,
    required String hexColour,
    String notes = '',
    String? purchaseLocation,
    List<String> photoUris = const <String>[],
  }) {
    final yarn = Yarn(
      id: _uuid.v4(),
      brand: brand,
      colourName: colourName,
      weight: weight,
      fibre: fibre,
      yardagePerSkein: yardagePerSkein,
      metreagePerSkein: metreagePerSkein,
      gramsPerSkein: gramsPerSkein,
      skeinCount: skeinCount,
      hexColour: hexColour,
      notes: notes,
      purchaseLocation: purchaseLocation,
      photoUris: photoUris,
    );

    final updated = List<Yarn>.from(state.yarns)..add(yarn);
    state = state.copyWith(yarns: updated, filteredYarns: updated);
    _persist();
  }

  /// Update an existing yarn.
  void updateYarn(Yarn yarn) {
    final updated = state.yarns.map((y) => y.id == yarn.id ? yarn : y).toList();
    state = state.copyWith(yarns: updated);
    _applyCurrentFilters(updated);
    _persist();
  }

  /// Delete a yarn by ID.
  void deleteYarn(String id) {
    final updated = state.yarns.where((y) => y.id != id).toList();
    state = state.copyWith(yarns: updated);
    _applyCurrentFilters(updated);
    _persist();
  }

  /// Update yarn status.
  void updateStatus(String id, String status) {
    final yarn = getYarnById(id);
    if (yarn == null) return;

    final updated = yarn.copyWith(status: status);
    updateYarn(updated);
  }

  /// Link yarn to a project.
  void linkToProject(String yarnId, String projectId) {
    final yarn = getYarnById(yarnId);
    if (yarn == null) return;

    final updated = yarn.linkToProject(projectId);
    updateYarn(updated);
  }

  /// Unlink yarn from a project.
  void unlinkFromProject(String yarnId, String projectId) {
    final yarn = getYarnById(yarnId);
    if (yarn == null) return;

    final updated = yarn.unlinkFromProject(projectId);
    updateYarn(updated);
  }

  /// Search yarns by query.
  void search(String query) {
    final lowerQuery = query.trim().toLowerCase();
    final filtered = _applyFilters(
      yarns: state.yarns,
      query: lowerQuery,
      weight: state.selectedWeight,
      status: state.selectedStatus,
    );
    state = state.copyWith(searchQuery: query, filteredYarns: filtered);
  }

  /// Filter by weight.
  void setWeightFilter(String? weight) {
    final filtered = _applyFilters(
      yarns: state.yarns,
      query: state.searchQuery.toLowerCase(),
      weight: weight,
      status: state.selectedStatus,
    );
    state = state.copyWith(selectedWeight: weight, filteredYarns: filtered);
  }

  /// Filter by status.
  void setStatusFilter(String? status) {
    final filtered = _applyFilters(
      yarns: state.yarns,
      query: state.searchQuery.toLowerCase(),
      weight: state.selectedWeight,
      status: status,
    );
    state = state.copyWith(selectedStatus: status, filteredYarns: filtered);
  }

  /// Clear all filters.
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedWeight: YarnState._clearSentinel,
      selectedStatus: YarnState._clearSentinel,
      filteredYarns: state.yarns,
    );
  }

  /// Get yarn by ID.
  Yarn? getYarnById(String id) {
    try {
      return state.yarns.firstWhere((y) => y.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get yarns linked to a project.
  List<Yarn> getYarnsForProject(String projectId) {
    return state.yarns
        .where((y) => y.linkedProjectIds.contains(projectId))
        .toList();
  }

  /// Check if enough yarn for a project.
  ///
  /// Returns true if total yardage >= needed yardage.
  bool hasEnoughYarn(String yarnId, int neededYardage) {
    final yarn = getYarnById(yarnId);
    if (yarn == null) return false;
    return yarn.totalYardage >= neededYardage;
  }

  /// Calculate how much yarn is needed.
  ///
  /// Returns the number of skeins needed, rounded up.
  int calculateSkeinsNeeded(String yarnId, int neededYardage) {
    final yarn = getYarnById(yarnId);
    if (yarn == null || yarn.yardagePerSkein <= 0) return 0;
    return (neededYardage / yarn.yardagePerSkein).ceil();
  }

  void _applyCurrentFilters(List<Yarn> yarns) {
    final filtered = _applyFilters(
      yarns: yarns,
      query: state.searchQuery.toLowerCase(),
      weight: state.selectedWeight,
      status: state.selectedStatus,
    );
    state = state.copyWith(filteredYarns: filtered);
  }

  List<Yarn> _applyFilters({
    required List<Yarn> yarns,
    required String query,
    required String? weight,
    required String? status,
  }) {
    return yarns.where((yarn) {
      if (weight != null && yarn.weight != weight) return false;
      if (status != null && yarn.status != status) return false;
      if (query.isNotEmpty) {
        final matches = yarn.brand.toLowerCase().contains(query) ||
            yarn.colourName.toLowerCase().contains(query) ||
            yarn.fibre.toLowerCase().contains(query);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }
}
