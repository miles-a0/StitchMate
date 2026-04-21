import 'package:hive/hive.dart';

import 'counter.dart';

/// Hive-backed data model for a knitting/crochet project.
///
/// Every field is final. Mutations create a new instance via [copyWith].
/// The adapter must be registered in [HiveInit.initialise] before use.
class Project extends HiveObject {
  Project({
    required this.id,
    required this.name,
    this.craftType = CraftType.knit,
    this.status = ProjectStatus.active,
    required this.startDate,
    this.endDate,
    this.notes = '',
    this.yarnIds = const <String>[],
    this.needleSize,
    this.gaugeStitches,
    this.gaugeRows,
    this.counters = const <Counter>[],
    this.totalTimeSeconds = 0,
    this.photoUris = const <String>[],
    this.tags = const <String>[],
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CraftType craftType;

  @HiveField(3)
  final ProjectStatus status;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime? endDate;

  @HiveField(6)
  final String notes;

  @HiveField(7)
  final List<String> yarnIds;

  @HiveField(8)
  final String? needleSize;

  @HiveField(9)
  final double? gaugeStitches;

  @HiveField(10)
  final double? gaugeRows;

  @HiveField(11)
  final List<Counter> counters;

  @HiveField(12)
  final int totalTimeSeconds;

  @HiveField(13)
  final List<String> photoUris;

  @HiveField(14)
  final List<String> tags;

  /// Creates a copy with optionally updated fields.
  Project copyWith({
    String? id,
    String? name,
    CraftType? craftType,
    ProjectStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    List<String>? yarnIds,
    String? needleSize,
    double? gaugeStitches,
    double? gaugeRows,
    List<Counter>? counters,
    int? totalTimeSeconds,
    List<String>? photoUris,
    List<String>? tags,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      craftType: craftType ?? this.craftType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate == _sentinelDate ? null : (endDate ?? this.endDate),
      notes: notes ?? this.notes,
      yarnIds: yarnIds ?? this.yarnIds,
      needleSize: needleSize == _sentinelString
          ? null
          : (needleSize ?? this.needleSize),
      gaugeStitches: gaugeStitches == _sentinelDouble
          ? null
          : (gaugeStitches ?? this.gaugeStitches),
      gaugeRows:
          gaugeRows == _sentinelDouble ? null : (gaugeRows ?? this.gaugeRows),
      counters: counters ?? this.counters,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      photoUris: photoUris ?? this.photoUris,
      tags: tags ?? this.tags,
    );
  }

  static final DateTime _sentinelDate = DateTime(1900);
  static const String _sentinelString = '\x00\x00SENTINEL\x00\x00';
  static const double _sentinelDouble = -999999.0;

  Project clearEndDate() => copyWith(endDate: _sentinelDate);
  Project clearNeedleSize() => copyWith(needleSize: _sentinelString);
  Project clearGaugeStitches() => copyWith(gaugeStitches: _sentinelDouble);
  Project clearGaugeRows() => copyWith(gaugeRows: _sentinelDouble);

  /// Get the primary counter for this project (creates one if none exists).
  Counter getPrimaryCounter() {
    if (counters.isEmpty) {
      return Counter(id: '${id}_counter_0', label: 'Rows');
    }
    return counters.first;
  }

  /// Update a specific counter in the list.
  Project updateCounter(Counter updatedCounter) {
    final updatedCounters = counters.map((c) {
      return c.id == updatedCounter.id ? updatedCounter : c;
    }).toList();

    // If counter not found, add it.
    if (!updatedCounters.any((c) => c.id == updatedCounter.id)) {
      updatedCounters.add(updatedCounter);
    }

    return copyWith(counters: updatedCounters);
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, status: $status, counters: ${counters.length})';
  }
}

/// Craft type enum for projects.
enum CraftType {
  knit,
  crochet,
  both,
}

/// Project status enum.
enum ProjectStatus {
  active,
  paused,
  completed,
  frogged,
}
