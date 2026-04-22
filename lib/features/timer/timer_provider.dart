import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_init.dart';
import '../../data/models/timer_session.dart';

/// Timer status enum.
enum TimerStatus { idle, running, paused }

/// Immutable state class for the project timer feature.
class TimerState {
  const TimerState({
    this.sessions = const <TimerSession>[],
    this.activeSession,
    this.status = TimerStatus.idle,
    this.elapsedSeconds = 0,
    this.isLoading = false,
    this.error,
  });

  final List<TimerSession> sessions;
  final TimerSession? activeSession;
  final TimerStatus status;
  final int elapsedSeconds;
  final bool isLoading;
  final String? error;

  TimerState copyWith({
    List<TimerSession>? sessions,
    TimerSession? activeSession,
    bool clearActiveSession = false,
    TimerStatus? status,
    int? elapsedSeconds,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return TimerState(
      sessions: sessions ?? this.sessions,
      activeSession:
          clearActiveSession ? null : (activeSession ?? this.activeSession),
      status: status ?? this.status,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  TimerState clearError() => copyWith(clearError: true);
  TimerState clearActiveSession() => copyWith(clearActiveSession: true);

  /// Get sessions for a specific project.
  List<TimerSession> sessionsForProject(String projectId) {
    return sessions
        .where((s) => s.projectId == projectId && s.isCompleted)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Get total elapsed seconds for a project (completed sessions + current).
  int totalElapsedForProject(String projectId) {
    final completed = sessionsForProject(projectId);
    final completedSeconds =
        completed.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final current = activeSession?.projectId == projectId ? elapsedSeconds : 0;
    return completedSeconds + current;
  }

  /// Format seconds as HH:MM:SS.
  static String formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  String toString() {
    return 'TimerState(sessions: ${sessions.length}, status: $status, elapsed: $elapsedSeconds)';
  }
}

/// Riverpod StateNotifier for project timer business logic.
///
/// All mutations persist to Hive immediately.
/// Uses a periodic Timer for elapsed time updates — this runs in the
/// notifier (not the widget) to avoid UI lag.
class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(const TimerState()) {
    _loadFromHive();
  }

  Timer? _tickTimer;

  static const String _hiveKeyPrefix = 'session_';

  /// Load all sessions from Hive.
  void _loadFromHive() {
    try {
      final box = HiveInit.timerBox;
      final sessions = box.values.whereType<TimerSession>().toList();
      state = state.copyWith(sessions: sessions);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  /// Start the timer for a project.
  void startTimer(String projectId) {
    if (state.status == TimerStatus.running) return;

    final session = TimerSession(
      id: '$_hiveKeyPrefix${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      startTime: DateTime.now(),
    );

    state = state.copyWith(
      activeSession: session,
      status: TimerStatus.running,
      elapsedSeconds: 0,
    );

    _persist(session);
    _startTicking();
  }

  /// Pause the currently running timer.
  void pauseTimer() {
    if (state.status != TimerStatus.running || state.activeSession == null) {
      return;
    }

    _tickTimer?.cancel();
    _tickTimer = null;

    state = state.copyWith(status: TimerStatus.paused);
  }

  /// Resume a paused timer.
  void resumeTimer() {
    if (state.status != TimerStatus.paused || state.activeSession == null) {
      return;
    }

    state = state.copyWith(status: TimerStatus.running);
    _startTicking();
  }

  /// Stop the timer and save the session.
  void stopTimer() {
    if (state.activeSession == null) return;

    _tickTimer?.cancel();
    _tickTimer = null;

    final completedSession = state.activeSession!.copyWith(
      endTime: DateTime.now(),
      durationSeconds: state.elapsedSeconds,
    );

    final updatedSessions = List<TimerSession>.from(state.sessions)
      ..add(completedSession);

    state = state
        .copyWith(
          sessions: updatedSessions,
          status: TimerStatus.idle,
          elapsedSeconds: 0,
        )
        .clearActiveSession();

    _persist(completedSession);
  }

  /// Reset the timer without saving a session.
  void resetTimer() {
    _tickTimer?.cancel();
    _tickTimer = null;

    state = state
        .copyWith(
          status: TimerStatus.idle,
          elapsedSeconds: 0,
        )
        .clearActiveSession();
  }

  /// Start the periodic tick timer.
  void _startTicking() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  /// Delete a session.
  void deleteSession(String sessionId) {
    final updatedSessions =
        state.sessions.where((s) => s.id != sessionId).toList();
    state = state.copyWith(sessions: updatedSessions);
    _remove(sessionId);
  }

  /// Persist session to Hive.
  void _persist(TimerSession session) {
    try {
      HiveInit.timerBox.put(session.id, session);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  /// Remove session from Hive.
  void _remove(String sessionId) {
    try {
      HiveInit.timerBox.delete(sessionId);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }
}

/// Provider for timer state.
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});
