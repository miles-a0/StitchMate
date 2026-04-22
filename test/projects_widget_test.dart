import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stitch_mate/features/projects/screens/projects_screen.dart';
import 'package:stitch_mate/features/projects/screens/project_detail_screen.dart';
import 'package:stitch_mate/features/projects/projects_provider.dart';
import 'package:stitch_mate/features/counter/widgets/counter_increment_button.dart';
import 'package:stitch_mate/data/models/project.dart';

void main() {
  group('ProjectsScreen Widget Tests', () {
    testWidgets('ProjectsScreen shows empty state when no projects',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No active projects'), findsOneWidget);
      expect(find.text('Create your first project to get started'),
          findsOneWidget);
    });

    testWidgets('ProjectsScreen shows project list when projects exist',
        (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf', craftType: CraftType.knit);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Scarf'), findsOneWidget);
    });

    testWidgets('ProjectsScreen shows craft type and status', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf', craftType: CraftType.knit);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Knitting'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('ProjectsScreen shows counter value on card', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      // Increment counter via provider.
      final project = notifier.state.projects.first;
      final counter = project.counters.first;
      final updatedCounter = counter.copyWith(currentValue: 5);
      notifier.updateProjectCounter(project.id, updatedCounter);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Delete project shows confirmation dialog', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap delete button.
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Confirmation dialog should appear.
      expect(find.text('Delete Project'), findsOneWidget);
      expect(
        find.text(
            'Are you sure you want to delete this project? This cannot be undone.'),
        findsOneWidget,
      );

      // Cancel.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Project should still exist.
      expect(find.text('Test Scarf'), findsOneWidget);
    });

    testWidgets('Delete project confirms and removes', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap delete button.
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      // Confirm delete.
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Project should be removed.
      expect(find.text('Test Scarf'), findsNothing);
    });

    testWidgets('FAB navigates to new project screen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProjectsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('ProjectDetailScreen Widget Tests', () {
    testWidgets('ProjectDetailScreen displays project name', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf', craftType: CraftType.knit);
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test Scarf'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen shows counter tab by default',
        (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Counter tab should be selected and show counter value (0).
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen increment increases counter',
        (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap increment button.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Counter should show 1.
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen lock toggle works', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap lock toggle (in the FilterChip row, not the increment button).
      final lockChip = find.widgetWithText(FilterChip, 'Unlock');
      await tester.tap(lockChip);
      await tester.pumpAndSettle();

      // Should now show locked state.
      expect(find.widgetWithText(FilterChip, 'Lock'), findsOneWidget);

      // Increment should not work when locked — tap the large button area.
      final incrementButton = find.byType(CounterIncrementButton);
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // Counter should still be 0.
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen reset shows confirmation', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      // Set counter to 5.
      final project = notifier.state.projects.first;
      final counter = project.counters.first;
      notifier.updateProjectCounter(
        project.id,
        counter.copyWith(currentValue: 5),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Counter should show 5.
      expect(find.text('5'), findsOneWidget);

      // Tap reset chip (not any other reset text).
      final resetChip = find.widgetWithText(FilterChip, 'Reset');
      await tester.tap(resetChip);
      await tester.pumpAndSettle();

      // Confirmation dialog should appear with title.
      expect(find.text('Reset'), findsWidgets);

      // Cancel in dialog.
      final cancelButton = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Cancel'),
      );
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Counter should still be 5.
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen status dropdown changes status',
        (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open status dropdown.
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      // Select 'Completed'.
      await tester.tap(find.text('Completed').last);
      await tester.pumpAndSettle();

      // Status should be updated.
      expect(notifier.state.projects.first.status, ProjectStatus.completed);
    });

    testWidgets('ProjectDetailScreen notes tab shows notes', (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(
        name: 'Test Scarf',
        notes: 'Using Malabrigo yarn',
      );
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Notes tab.
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();

      // Notes should be visible.
      expect(find.text('Using Malabrigo yarn'), findsOneWidget);
    });

    testWidgets('ProjectDetailScreen notes tab shows empty state',
        (tester) async {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');
      final projectId = notifier.state.projects.first.id;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsProvider.overrideWith((ref) => notifier),
          ],
          child: MaterialApp(
            home: ProjectDetailScreen(projectId: projectId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Notes tab.
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();

      // Empty state should be visible.
      expect(find.text('Nothing here yet'), findsOneWidget);
    });
  });
}
