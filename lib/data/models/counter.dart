import 'package:hive/hive.dart';

/// Hive-backed data model for a row counter.
///
/// Every field is final. Mutations create a new instance via [copyWith].
/// The adapter must be registered in [HiveInit.initialise] before use.
@HiveType(typeId: 1)
class Counter extends HiveObject {
  Counter({
    required this.id,
    required this.label,
    this.currentValue = 0,
    this.targetValue,
    this.reminderEvery,
    this.reminderNote,
    this.isLocked = false,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final int currentValue;

  @HiveField(3)
  final int? targetValue;

  @HiveField(4)
  final int? reminderEvery;

  @HiveField(5)
  final String? reminderNote;

  @HiveField(6)
  final bool isLocked;

  /// Creates a copy with optionally updated fields.
  Counter copyWith({
    String? id,
    String? label,
    int? currentValue,
    int? targetValue,
    int? reminderEvery,
    String? reminderNote,
    bool? isLocked,
  }) {
    return Counter(
      id: id ?? this.id,
      label: label ?? this.label,
      currentValue: currentValue ?? this.currentValue,
      targetValue:
          targetValue == _sentinel ? null : (targetValue ?? this.targetValue),
      reminderEvery: reminderEvery == _sentinel
          ? null
          : (reminderEvery ?? this.reminderEvery),
      reminderNote: reminderNote == _sentinelString
          ? null
          : (reminderNote ?? this.reminderNote),
      isLocked: isLocked ?? this.isLocked,
    );
  }

  /// Sentinel value used to clear nullable int fields in [copyWith].
  static const int _sentinel = -999999;

  /// Sentinel value used to clear nullable String fields in [copyWith].
  static const String _sentinelString = '\x00\x00SENTINEL\x00\x00';

  /// Convenience method to clear [targetValue].
  Counter clearTargetValue() => copyWith(targetValue: _sentinel);

  /// Convenience method to clear [reminderEvery].
  Counter clearReminderEvery() => copyWith(reminderEvery: _sentinel);

  /// Convenience method to clear [reminderNote].
  Counter clearReminderNote() => copyWith(reminderNote: _sentinelString);

  @override
  String toString() {
    return 'Counter(id: $id, label: $label, value: $currentValue, locked: $isLocked)';
  }
}
