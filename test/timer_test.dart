import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_mate/data/models/timer_session.dart';
import 'package:stitch_mate/features/timer/timer_provider.dart';

void main() {
  group('TimerSession', () {
    test('creates with required fields', () {
      final session = TimerSession(
        id: 'session_1',
        projectId: 'project_1',
        startTime: DateTime(2024, 1, 1, 10, 0),
      );

      expect(session.id, 'session_1');
      expect(session.projectId, 'project_1');
      expect(session.durationSeconds, 0);
      expect(session.isCompleted, false);
    });

    test('copyWith updates fields', () {
      final session = TimerSession(
        id: 'session_1',
        projectId: 'project_1',
        startTime: DateTime(2024, 1, 1, 10, 0),
      );

      final updated = session.copyWith(
        durationSeconds: 3600,
        endTime: DateTime(2024, 1, 1, 11, 0),
      );

      expect(updated.durationSeconds, 3600);
      expect(updated.isCompleted, true);
      expect(updated.id, 'session_1'); // unchanged
    });

    test('formattedDuration formats correctly', () {
      final session = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime.now(),
        durationSeconds: 3661,
      );

      expect(session.formattedDuration, '01:01:01');
    });

    test('formattedDuration pads zeros', () {
      final session = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime.now(),
        durationSeconds: 5,
      );

      expect(session.formattedDuration, '00:00:05');
    });

    test('formattedDate returns DD/MM/YYYY', () {
      final session = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime(2024, 3, 15, 10, 30),
      );

      expect(session.formattedDate, '15/03/2024');
    });
  });

  group('TimerState', () {
    test('default state is idle', () {
      const state = TimerState();

      expect(state.status, TimerStatus.idle);
      expect(state.elapsedSeconds, 0);
      expect(state.sessions, isEmpty);
      expect(state.activeSession, isNull);
    });

    test('copyWith updates fields', () {
      const state = TimerState();
      final session = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime.now(),
      );

      final updated = state.copyWith(
        status: TimerStatus.running,
        elapsedSeconds: 60,
        activeSession: session,
      );

      expect(updated.status, TimerStatus.running);
      expect(updated.elapsedSeconds, 60);
      expect(updated.activeSession, isNotNull);
    });

    test('clearActiveSession sets activeSession to null', () {
      final session = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime.now(),
      );
      final state = const TimerState().copyWith(activeSession: session);

      final cleared = state.clearActiveSession();

      expect(cleared.activeSession, isNull);
    });

    test('sessionsForProject filters and sorts', () {
      final session1 = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 2),
        endTime: DateTime(2024, 1, 2, 1),
        durationSeconds: 3600,
      );
      final session2 = TimerSession(
        id: 's2',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 1),
        endTime: DateTime(2024, 1, 1, 1),
        durationSeconds: 3600,
      );
      final session3 = TimerSession(
        id: 's3',
        projectId: 'p2',
        startTime: DateTime(2024, 1, 1),
        endTime: DateTime(2024, 1, 1, 1),
        durationSeconds: 3600,
      );

      final state = TimerState(sessions: [session2, session3, session1]);
      final projectSessions = state.sessionsForProject('p1');

      expect(projectSessions.length, 2);
      expect(projectSessions.first.id, 's1'); // newest first
      expect(projectSessions.last.id, 's2');
    });

    test('sessionsForProject excludes incomplete sessions', () {
      final completed = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 1),
        endTime: DateTime(2024, 1, 1, 1),
        durationSeconds: 3600,
      );
      final incomplete = TimerSession(
        id: 's2',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 2),
      );

      final state = TimerState(sessions: [completed, incomplete]);
      final projectSessions = state.sessionsForProject('p1');

      expect(projectSessions.length, 1);
      expect(projectSessions.first.id, 's1');
    });

    test('totalElapsedForProject sums completed sessions', () {
      final session1 = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 1),
        endTime: DateTime(2024, 1, 1, 1),
        durationSeconds: 3600,
      );
      final session2 = TimerSession(
        id: 's2',
        projectId: 'p1',
        startTime: DateTime(2024, 1, 2),
        endTime: DateTime(2024, 1, 2, 2),
        durationSeconds: 7200,
      );

      final state = TimerState(sessions: [session1, session2]);

      expect(state.totalElapsedForProject('p1'), 10800);
    });

    test('totalElapsedForProject includes active session elapsed', () {
      final activeSession = TimerSession(
        id: 's1',
        projectId: 'p1',
        startTime: DateTime.now(),
      );

      final state = TimerState(
        activeSession: activeSession,
        status: TimerStatus.running,
        elapsedSeconds: 300,
      );

      expect(state.totalElapsedForProject('p1'), 300);
    });

    test('totalElapsedForProject ignores active session for other project', () {
      final activeSession = TimerSession(
        id: 's1',
        projectId: 'p2',
        startTime: DateTime.now(),
      );

      final state = TimerState(
        activeSession: activeSession,
        status: TimerStatus.running,
        elapsedSeconds: 300,
      );

      expect(state.totalElapsedForProject('p1'), 0);
    });

    test('formatDuration formats correctly', () {
      expect(TimerState.formatDuration(0), '00:00:00');
      expect(TimerState.formatDuration(5), '00:00:05');
      expect(TimerState.formatDuration(65), '00:01:05');
      expect(TimerState.formatDuration(3661), '01:01:01');
      expect(TimerState.formatDuration(36000), '10:00:00');
    });
  });

  group('TimerNotifier', () {
    late TimerNotifier notifier;

    setUp(() {
      notifier = TimerNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('initial state is idle', () {
      expect(notifier.state.status, TimerStatus.idle);
      expect(notifier.state.sessions, isEmpty);
    });

    test('startTimer creates active session', () {
      notifier.startTimer('project_1');

      expect(notifier.state.status, TimerStatus.running);
      expect(notifier.state.activeSession, isNotNull);
      expect(notifier.state.activeSession!.projectId, 'project_1');
      expect(notifier.state.elapsedSeconds, 0);
    });

    test('startTimer does nothing if already running', () {
      notifier.startTimer('project_1');
      final firstSession = notifier.state.activeSession;

      notifier.startTimer('project_2');

      expect(notifier.state.activeSession!.id, firstSession!.id);
    });

    test('pauseTimer pauses running timer', () {
      notifier.startTimer('project_1');
      notifier.pauseTimer();

      expect(notifier.state.status, TimerStatus.paused);
      expect(notifier.state.activeSession, isNotNull);
    });

    test('pauseTimer does nothing if not running', () {
      notifier.pauseTimer();
      expect(notifier.state.status, TimerStatus.idle);
    });

    test('resumeTimer resumes paused timer', () {
      notifier.startTimer('project_1');
      notifier.pauseTimer();
      notifier.resumeTimer();

      expect(notifier.state.status, TimerStatus.running);
    });

    test('resumeTimer does nothing if not paused', () {
      notifier.resumeTimer();
      expect(notifier.state.status, TimerStatus.idle);
    });

    test('stopTimer completes session and saves to sessions list', () {
      notifier.startTimer('project_1');
      notifier.stopTimer();

      expect(notifier.state.status, TimerStatus.idle);
      expect(notifier.state.activeSession, isNull);
      expect(notifier.state.sessions.length, 1);
      expect(notifier.state.sessions.first.isCompleted, true);
    });

    test('stopTimer does nothing if no active session', () {
      notifier.stopTimer();
      expect(notifier.state.status, TimerStatus.idle);
      expect(notifier.state.sessions, isEmpty);
    });

    test('resetTimer clears without saving session', () {
      notifier.startTimer('project_1');
      notifier.resetTimer();

      expect(notifier.state.status, TimerStatus.idle);
      expect(notifier.state.activeSession, isNull);
      expect(notifier.state.sessions, isEmpty);
    });

    test('deleteSession removes from sessions list', () {
      notifier.startTimer('project_1');
      notifier.stopTimer();

      final sessionId = notifier.state.sessions.first.id;
      notifier.deleteSession(sessionId);

      expect(notifier.state.sessions, isEmpty);
    });

    test('elapsedSeconds increments while running', () async {
      notifier.startTimer('project_1');

      await Future<void>.delayed(const Duration(seconds: 2));

      expect(notifier.state.elapsedSeconds, greaterThanOrEqualTo(1));
      notifier.stopTimer();
    });

    test('elapsedSeconds does not increment while paused', () async {
      notifier.startTimer('project_1');
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      final elapsedAtPause = notifier.state.elapsedSeconds;

      notifier.pauseTimer();
      await Future<void>.delayed(const Duration(milliseconds: 1100));

      expect(notifier.state.elapsedSeconds, elapsedAtPause);
      notifier.stopTimer();
    });

    test('multiple projects have separate session tracking', () {
      notifier.startTimer('project_1');
      notifier.stopTimer();

      notifier.startTimer('project_2');
      notifier.stopTimer();

      expect(notifier.state.sessions.length, 2);
      expect(
        notifier.state.sessionsForProject('project_1').length,
        1,
      );
      expect(
        notifier.state.sessionsForProject('project_2').length,
        1,
      );
    });
  });
}
