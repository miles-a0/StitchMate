import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch_mate/core/strings.dart';
import 'package:stitch_mate/data/models/project.dart';
import 'package:stitch_mate/features/projects/projects_provider.dart';
import 'package:stitch_mate/features/projects/screens/project_detail_screen.dart';
import 'package:stitch_mate/data/models/timer_session.dart';
import 'package:stitch_mate/features/timer/timer_provider.dart';

/// Create a test project.
Project _testProject() {
  return Project(
    id: 'project_test',
    name: 'Test Scarf',
    craftType: CraftType.knit,
    status: ProjectStatus.active,
    startDate: DateTime(2024, 1, 1),
  );
}

/// Build a testable ProjectDetailScreen wrapped in ProviderScope + GoRouter.
Widget _buildTestableDetailScreen({
  required Project project,
  TimerState? timerState,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => ProjectDetailScreen(projectId: project.id),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      projectsProvider.overrideWith(
        (ref) => ProjectsNotifier()..state = ProjectsState(projects: [project]),
      ),
      if (timerState != null)
        timerProvider.overrideWith(
          (ref) => TimerNotifier()..state = timerState,
        ),
    ],
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  group('ProjectTimerTab Widget Tests', () {
    testWidgets('shows timer title and total time label when idle',
        (tester) async {
      final project = _testProject();
      await tester.pumpWidget(
        _buildTestableDetailScreen(project: project),
      );
      await tester.pump();

      // Navigate to Timer tab.
      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      expect(find.text('00:00:00'), findsOneWidget);
      expect(find.text(AppStrings.timerTotalTime), findsOneWidget);
    });

    testWidgets('shows start button when idle', (tester) async {
      final project = _testProject();
      await tester.pumpWidget(
        _buildTestableDetailScreen(project: project),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.timerStart), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('tapping start changes to pause button', (tester) async {
      final project = _testProject();
      await tester.pumpWidget(
        _buildTestableDetailScreen(project: project),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.timerStart));
      await tester.pump();

      expect(find.text(AppStrings.timerPause), findsOneWidget);
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });

    testWidgets('stop button is shown when idle', (tester) async {
      final project = _testProject();
      await tester.pumpWidget(
        _buildTestableDetailScreen(project: project),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      // Verify stop button text and icon are present.
      expect(find.text(AppStrings.timerStop), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('shows no sessions message when empty', (tester) async {
      final project = _testProject();
      await tester.pumpWidget(
        _buildTestableDetailScreen(project: project),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.timerNoSessions), findsOneWidget);
    });

    testWidgets('shows session history when sessions exist', (tester) async {
      final project = _testProject();
      final session = TimerSession(
        id: 'session_1',
        projectId: project.id,
        startTime: DateTime(2024, 1, 15, 10, 0),
        endTime: DateTime(2024, 1, 15, 11, 0),
        durationSeconds: 3600,
      );
      final timerState = TimerState(sessions: [session]);

      await tester.pumpWidget(
        _buildTestableDetailScreen(
          project: project,
          timerState: timerState,
        ),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      expect(find.text('15/01/2024'), findsOneWidget);
      expect(find.text('01:00:00'), findsWidgets);
    });

    testWidgets('shows elapsed time from active session', (tester) async {
      final project = _testProject();
      final activeSession = TimerSession(
        id: 'session_active',
        projectId: project.id,
        startTime: DateTime.now(),
      );
      final timerState = TimerState(
        activeSession: activeSession,
        status: TimerStatus.running,
        elapsedSeconds: 125,
      );

      await tester.pumpWidget(
        _buildTestableDetailScreen(
          project: project,
          timerState: timerState,
        ),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.timerTitle));
      await tester.pumpAndSettle();

      expect(find.text('00:02:05'), findsOneWidget);
      expect(find.text(AppStrings.timerStart), findsOneWidget);
    });
  });
}
