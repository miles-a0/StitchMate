import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_init.dart';
import '../../data/models/project.dart';
import '../../data/models/counter.dart';

/// Immutable state class for the projects feature.
class ProjectsState {
  const ProjectsState({
    this.projects = const <Project>[],
    this.isLoading = false,
    this.error,
  });

  final List<Project> projects;
  final bool isLoading;
  final String? error;

  ProjectsState copyWith({
    List<Project>? projects,
    bool? isLoading,
    String? error,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error == _clearSentinel ? null : (error ?? this.error),
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  ProjectsState clearError() => copyWith(error: _clearSentinel);

  /// Get only active projects.
  List<Project> get activeProjects =>
      projects.where((p) => p.status == ProjectStatus.active).toList();

  /// Get projects sorted by start date (newest first).
  List<Project> get sortedProjects => List<Project>.from(projects)
    ..sort((a, b) => b.startDate.compareTo(a.startDate));

  @override
  String toString() {
    return 'ProjectsState(projects: ${projects.length}, loading: $isLoading, error: $error)';
  }
}

/// Riverpod StateNotifier for project business logic.
///
/// All mutations persist to Hive immediately.
class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier() : super(const ProjectsState()) {
    _loadFromHive();
  }

  static const String _hiveKeyPrefix = 'project_';

  /// Load all projects from Hive.
  void _loadFromHive() {
    try {
      final box = HiveInit.projectsBox;
      final projects = box.values.whereType<Project>().toList();
      state = state.copyWith(projects: projects);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  /// Create a new project.
  void createProject({
    required String name,
    CraftType craftType = CraftType.knit,
    String notes = '',
    String? needleSize,
  }) {
    final id = '$_hiveKeyPrefix${DateTime.now().millisecondsSinceEpoch}';
    final project = Project(
      id: id,
      name: name,
      craftType: craftType,
      startDate: DateTime.now(),
      notes: notes,
      needleSize: needleSize,
      counters: <Counter>[
        Counter(id: '${id}_counter_0', label: 'Rows'),
      ],
    );

    final updatedProjects = List<Project>.from(state.projects)..add(project);
    state = state.copyWith(projects: updatedProjects);
    _persist(project);
  }

  /// Update an existing project.
  void updateProject(Project updatedProject) {
    final updatedProjects = state.projects.map((project) {
      return project.id == updatedProject.id ? updatedProject : project;
    }).toList();

    state = state.copyWith(projects: updatedProjects);
    _persist(updatedProject);
  }

  /// Delete a project.
  void deleteProject(String projectId) {
    final updatedProjects =
        state.projects.where((p) => p.id != projectId).toList();
    state = state.copyWith(projects: updatedProjects);
    _remove(projectId);
  }

  /// Update project status.
  void updateStatus(String projectId, ProjectStatus newStatus) {
    final project = state.projects.firstWhere((p) => p.id == projectId);
    final updated = project.copyWith(
      status: newStatus,
      endDate: newStatus == ProjectStatus.completed ||
              newStatus == ProjectStatus.frogged
          ? DateTime.now()
          : null,
    );
    updateProject(updated);
  }

  /// Update a counter within a project.
  void updateProjectCounter(String projectId, Counter updatedCounter) {
    final project = state.projects.firstWhere((p) => p.id == projectId);
    final updated = project.updateCounter(updatedCounter);
    updateProject(updated);
  }

  /// Get a project by ID.
  Project? getProjectById(String projectId) {
    try {
      return state.projects.firstWhere((p) => p.id == projectId);
    } catch (_) {
      return null;
    }
  }

  /// Persist project to Hive.
  void _persist(Project project) {
    try {
      HiveInit.projectsBox.put(project.id, project);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }

  /// Remove project from Hive.
  void _remove(String projectId) {
    try {
      HiveInit.projectsBox.delete(projectId);
    } catch (_) {
      // Hive not initialised in test environment.
    }
  }
}

/// Provider for projects state.
final projectsProvider =
    StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  return ProjectsNotifier();
});
