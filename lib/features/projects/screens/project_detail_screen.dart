import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/project.dart';
import '../projects_provider.dart';
import 'project_counter_tab.dart';

/// Project detail screen with tabs for Counter, Timer, Notes, Photos.
///
/// For Sprint 2 MVP: Counter tab is fully implemented.
/// Timer, Notes (read-only), Photos are placeholder tabs for future sprints.
class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({
    required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  ConsumerState<ProjectDetailScreen> createState() =>
      _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(
      projectsProvider.select((state) => state.projects.firstWhere(
            (p) => p.id == widget.projectId,
            orElse: () => throw Exception('Project not found'),
          )),
    );

    final tabs = <String>[
      AppStrings.counterTitle,
      AppStrings.timerTitle,
      AppStrings.projectNotes,
      AppStrings.projectPhotos,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: <Widget>[
          // Edit button.
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: AppStrings.editProject,
            onPressed: () => context.push('/projects/edit', extra: project.id),
          ),
          // Status dropdown.
          _StatusDropdown(
            currentStatus: project.status,
            onChanged: (status) {
              if (status != null) {
                ref
                    .read(projectsProvider.notifier)
                    .updateStatus(project.id, status);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Tab selector.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.spacingSM,
            ),
            child: Row(
              children: List.generate(tabs.length, (index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(right: AppDimensions.spacingSM),
                  child: ChoiceChip(
                    label: Text(tabs[index]),
                    selected: _selectedTab == index,
                    onSelected: (_) => setState(() => _selectedTab = index),
                  ),
                );
              }),
            ),
          ),

          // Tab content.
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: <Widget>[
                ProjectCounterTab(project: project),
                const _PlaceholderTab(label: AppStrings.timerTitle),
                _NotesTab(project: project),
                const _PlaceholderTab(label: AppStrings.projectPhotos),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Notes tab showing project notes.
class _NotesTab extends StatelessWidget {
  const _NotesTab({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (project.notes.isEmpty) {
      return Center(
        child: Text(
          AppStrings.empty,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Text(
        project.notes,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}

/// Placeholder tab for unimplemented features.
class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label — ${AppStrings.loading}'),
    );
  }
}

/// Status dropdown for AppBar.
class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.currentStatus,
    required this.onChanged,
  });

  final ProjectStatus currentStatus;
  final ValueChanged<ProjectStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<ProjectStatus>(
        value: currentStatus,
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        onChanged: onChanged,
        items: ProjectStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(_statusLabel(status)),
          );
        }).toList(),
      ),
    );
  }

  String _statusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.active:
        return AppStrings.statusActive;
      case ProjectStatus.paused:
        return AppStrings.statusPaused;
      case ProjectStatus.completed:
        return AppStrings.statusCompleted;
      case ProjectStatus.frogged:
        return AppStrings.statusFrogged;
    }
  }
}
