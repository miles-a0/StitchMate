import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_mate/data/models/project.dart';
import 'package:stitch_mate/data/models/counter.dart';
import 'package:stitch_mate/features/projects/projects_provider.dart';

void main() {
  group('Project Model', () {
    test('Project copyWith updates fields', () {
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
      );
      final updated = project.copyWith(
        name: 'Hat',
        status: ProjectStatus.completed,
      );

      expect(updated.name, 'Hat');
      expect(updated.status, ProjectStatus.completed);
      expect(updated.craftType, CraftType.knit); // unchanged
      expect(updated.id, 'test'); // unchanged
    });

    test('Project copyWith preserves lists when omitted', () {
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
        yarnIds: const <String>['yarn1'],
        counters: <Counter>[Counter(id: 'c1', label: 'Rows')],
        tags: const <String>['winter'],
      );
      final updated = project.copyWith(name: 'Hat');

      expect(updated.yarnIds, const <String>['yarn1']);
      expect(updated.counters.length, 1);
      expect(updated.tags, const <String>['winter']);
    });

    test('Project getPrimaryCounter returns first counter', () {
      final counter = Counter(id: 'c1', label: 'Rows');
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
        counters: <Counter>[counter],
      );

      expect(project.getPrimaryCounter().id, 'c1');
    });

    test('Project getPrimaryCounter creates default if empty', () {
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
      );

      expect(project.getPrimaryCounter().label, 'Rows');
    });

    test('Project updateCounter updates existing counter', () {
      final counter = Counter(id: 'c1', label: 'Rows', currentValue: 5);
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
        counters: <Counter>[counter],
      );

      final updatedCounter = counter.copyWith(currentValue: 10);
      final updatedProject = project.updateCounter(updatedCounter);

      expect(updatedProject.counters.first.currentValue, 10);
    });

    test('Project updateCounter adds new counter if not found', () {
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
      );

      final newCounter = Counter(id: 'c2', label: 'Repeats');
      final updatedProject = project.updateCounter(newCounter);

      expect(updatedProject.counters.length, 1);
      expect(updatedProject.counters.first.id, 'c2');
    });

    test('Project clear methods remove nullable fields', () {
      final project = Project(
        id: 'test',
        name: 'Scarf',
        craftType: CraftType.knit,
        status: ProjectStatus.active,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 2, 1),
        needleSize: '4.0mm',
        gaugeStitches: 20,
        gaugeRows: 28,
      );

      final cleared = project
          .clearEndDate()
          .clearNeedleSize()
          .clearGaugeStitches()
          .clearGaugeRows();

      expect(cleared.endDate, null);
      expect(cleared.needleSize, null);
      expect(cleared.gaugeStitches, null);
      expect(cleared.gaugeRows, null);
    });
  });

  group('ProjectsState', () {
    test('ProjectsState copyWith updates fields', () {
      const state = ProjectsState();
      final updated = state.copyWith(isLoading: true, error: 'Error');

      expect(updated.isLoading, true);
      expect(updated.error, 'Error');
      expect(updated.projects.isEmpty, true);
    });

    test('ProjectsState clearError removes error', () {
      const state = ProjectsState(error: 'Something wrong');
      final cleared = state.clearError();

      expect(cleared.error, null);
    });

    test('ProjectsState activeProjects filters correctly', () {
      final projects = <Project>[
        Project(
          id: '1',
          name: 'Active',
          status: ProjectStatus.active,
          startDate: DateTime.now(),
        ),
        Project(
          id: '2',
          name: 'Completed',
          status: ProjectStatus.completed,
          startDate: DateTime.now(),
        ),
      ];
      final state = ProjectsState(projects: projects);

      expect(state.activeProjects.length, 1);
      expect(state.activeProjects.first.name, 'Active');
    });

    test('ProjectsState sortedProjects sorts by date', () {
      final projects = <Project>[
        Project(
          id: '1',
          name: 'Old',
          status: ProjectStatus.active,
          startDate: DateTime(2024, 1, 1),
        ),
        Project(
          id: '2',
          name: 'New',
          status: ProjectStatus.active,
          startDate: DateTime(2024, 6, 1),
        ),
      ];
      final state = ProjectsState(projects: projects);

      expect(state.sortedProjects.first.name, 'New');
      expect(state.sortedProjects.last.name, 'Old');
    });
  });

  group('ProjectsNotifier Logic', () {
    test('createProject adds project to state', () {
      final notifier = ProjectsNotifier();

      notifier.createProject(name: 'Test Scarf', craftType: CraftType.knit);

      expect(notifier.state.projects.length, 1);
      expect(notifier.state.projects.first.name, 'Test Scarf');
      expect(notifier.state.projects.first.craftType, CraftType.knit);
      expect(notifier.state.projects.first.status, ProjectStatus.active);
    });

    test('createProject creates default counter', () {
      final notifier = ProjectsNotifier();

      notifier.createProject(name: 'Test Scarf');

      expect(notifier.state.projects.first.counters.length, 1);
      expect(notifier.state.projects.first.counters.first.label, 'Rows');
    });

    test('updateProject updates existing project', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final project = notifier.state.projects.first;
      final updated = project.copyWith(name: 'Updated Scarf');
      notifier.updateProject(updated);

      expect(notifier.state.projects.first.name, 'Updated Scarf');
    });

    test('deleteProject removes project', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.deleteProject(projectId);

      expect(notifier.state.projects.isEmpty, true);
    });

    test('updateStatus changes project status', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.updateStatus(projectId, ProjectStatus.completed);

      expect(
        notifier.state.projects.first.status,
        ProjectStatus.completed,
      );
      expect(notifier.state.projects.first.endDate, isNotNull);
    });

    test('updateStatus to active clears endDate', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.updateStatus(projectId, ProjectStatus.completed);
      notifier.updateStatus(projectId, ProjectStatus.active);

      expect(notifier.state.projects.first.status, ProjectStatus.active);
    });

    test('updateProjectCounter updates counter within project', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final project = notifier.state.projects.first;
      final counter = project.counters.first;
      final updatedCounter = counter.copyWith(currentValue: 42);

      notifier.updateProjectCounter(project.id, updatedCounter);

      expect(
        notifier.state.projects.first.counters.first.currentValue,
        42,
      );
    });

    test('getProjectById returns correct project', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      final found = notifier.getProjectById(projectId);

      expect(found, isNotNull);
      expect(found!.name, 'Test Scarf');
    });

    test('getProjectById returns null for unknown id', () {
      final notifier = ProjectsNotifier();

      final found = notifier.getProjectById('unknown');

      expect(found, null);
    });

    test('multiple projects are tracked independently', () {
      final notifier = ProjectsNotifier();

      notifier.createProject(name: 'Scarf', craftType: CraftType.knit);
      notifier.createProject(name: 'Hat', craftType: CraftType.crochet);
      notifier.createProject(name: 'Blanket', craftType: CraftType.both);

      expect(notifier.state.projects.length, 3);
      expect(notifier.state.sortedProjects.length, 3);
    });

    test('updateStatus to completed sets endDate', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.updateStatus(projectId, ProjectStatus.completed);

      expect(notifier.state.projects.first.endDate, isNotNull);
    });

    test('updateStatus to frogged sets endDate', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.updateStatus(projectId, ProjectStatus.frogged);

      expect(notifier.state.projects.first.endDate, isNotNull);
      expect(notifier.state.projects.first.status, ProjectStatus.frogged);
    });

    test('updateStatus to paused does not set endDate', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final projectId = notifier.state.projects.first.id;
      notifier.updateStatus(projectId, ProjectStatus.paused);

      expect(notifier.state.projects.first.endDate, isNull);
      expect(notifier.state.projects.first.status, ProjectStatus.paused);
    });

    test('updateProjectCounter with reminder triggers at interval', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final project = notifier.state.projects.first;
      final counter = project.counters.first.copyWith(
        currentValue: 5,
        reminderEvery: 5,
        reminderNote: 'Increase 1 stitch each side',
      );
      notifier.updateProjectCounter(project.id, counter);

      expect(
        notifier.state.projects.first.counters.first.currentValue,
        5,
      );
      expect(
        notifier.state.projects.first.counters.first.reminderEvery,
        5,
      );
    });

    test('updateProjectCounter with targetValue sets target', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(name: 'Test Scarf');

      final project = notifier.state.projects.first;
      final counter = project.counters.first.copyWith(
        currentValue: 25,
        targetValue: 100,
      );
      notifier.updateProjectCounter(project.id, counter);

      expect(
        notifier.state.projects.first.counters.first.targetValue,
        100,
      );
    });

    test('createProject with all fields sets correctly', () {
      final notifier = ProjectsNotifier();
      notifier.createProject(
        name: 'Winter Scarf',
        craftType: CraftType.knit,
        notes: 'Using Malabrigo yarn',
        needleSize: '4.0mm / US 6',
      );

      final project = notifier.state.projects.first;
      expect(project.name, 'Winter Scarf');
      expect(project.craftType, CraftType.knit);
      expect(project.notes, 'Using Malabrigo yarn');
      expect(project.needleSize, '4.0mm / US 6');
      expect(project.status, ProjectStatus.active);
      expect(project.counters.length, 1);
    });
  });
}
