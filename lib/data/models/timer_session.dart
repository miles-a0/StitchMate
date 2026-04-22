import 'package:hive/hive.dart';

/// Hive-backed data model for a single timer session.
///
/// A session represents one contiguous period of work on a project,
/// from start to stop. Multiple sessions can exist per project.
///
/// Every field is final. The adapter must be registered in
/// [HiveInit.initialise] before use.
class TimerSession extends HiveObject {
  TimerSession({
    required this.id,
    required this.projectId,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 0,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String projectId;

  @HiveField(2)
  final DateTime startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final int durationSeconds;

  /// Creates a copy with optionally updated fields.
  TimerSession copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
  }) {
    return TimerSession(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: startTime ?? this.startTime,
      endTime: endTime == _sentinelDate ? null : (endTime ?? this.endTime),
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  static final DateTime _sentinelDate = DateTime(1900);

  TimerSession clearEndTime() => copyWith(endTime: _sentinelDate);

  /// Whether this session has been completed (stopped).
  bool get isCompleted => endTime != null;

  /// Format duration as HH:MM:SS.
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  /// Format start time as a readable date string.
  String get formattedDate {
    final day = startTime.day.toString().padLeft(2, '0');
    final month = startTime.month.toString().padLeft(2, '0');
    final year = startTime.year;
    return '$day/$month/$year';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  String toString() {
    return 'TimerSession(id: $id, projectId: $projectId, duration: $formattedDuration)';
  }
}
