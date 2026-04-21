import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../core/theme.dart';
import '../../../data/models/project.dart';
import '../projects_provider.dart';

/// Screen showing all projects in a grid/list.
///
/// Features:
/// - Grid of project cards with status indicator
/// - FAB to create new project
/// - Tap to open project detail
/// - Delete with two-step confirmation
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsState = ref.watch(projectsProvider);
    final projects = projectsState.sortedProjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.projectsTitle),
      ),
      body: projects.isEmpty
          ? const _EmptyState()
          : _ProjectGrid(projects: projects),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/projects/new'),
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.newProject),
      ),
    );
  }
}

/// Empty state when no projects exist.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.folder_open_outlined,
            size: AppDimensions.iconXL * 2,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppDimensions.spacingMD),
          Text(
            AppStrings.noActiveProjects,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          Text(
            AppStrings.createProjectPrompt,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid of project cards.
class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({required this.projects});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 600 ? 2 : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.5,
            crossAxisSpacing: AppDimensions.spacingMD,
            mainAxisSpacing: AppDimensions.spacingMD,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return _ProjectCard(project: projects[index]);
          },
        );
      },
    );
  }
}

/// Individual project card.
class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/projects/detail', extra: project.id),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Row(
            children: <Widget>[
              // Status indicator.
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: _statusColor(project.status, colorScheme),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMD),

              // Project info.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      project.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXS),
                    Row(
                      children: <Widget>[
                        _CraftTypeChip(craftType: project.craftType),
                        const SizedBox(width: AppDimensions.spacingSM),
                        _StatusChip(status: project.status),
                      ],
                    ),
                  ],
                ),
              ),

              // Counter value (if has counters).
              if (project.counters.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMD,
                    vertical: AppDimensions.spacingSM,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Text(
                    '${project.counters.first.currentValue}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Delete button.
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: AppStrings.deleteProject,
                onPressed: () => _showDeleteConfirmation(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(ProjectStatus status, ColorScheme colorScheme) {
    switch (status) {
      case ProjectStatus.active:
        return colorScheme.primary;
      case ProjectStatus.paused:
        return colorScheme.outline;
      case ProjectStatus.completed:
        return AppTheme.successColor;
      case ProjectStatus.frogged:
        return colorScheme.error;
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteProject),
        content: const Text(AppStrings.deleteProjectConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(projectsProvider.notifier).deleteProject(project.id);
    }
  }
}

/// Small chip showing craft type.
class _CraftTypeChip extends StatelessWidget {
  const _CraftTypeChip({required this.craftType});

  final CraftType craftType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String label;
    IconData icon;
    switch (craftType) {
      case CraftType.knit:
        label = AppStrings.craftKnitting;
        icon = Icons.auto_fix_high;
      case CraftType.crochet:
        label = AppStrings.craftCrochet;
        icon = Icons.emoji_objects;
      case CraftType.both:
        label = AppStrings.craftBoth;
        icon = Icons.all_inclusive;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Small chip showing project status.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String label;
    switch (status) {
      case ProjectStatus.active:
        label = AppStrings.statusActive;
      case ProjectStatus.paused:
        label = AppStrings.statusPaused;
      case ProjectStatus.completed:
        label = AppStrings.statusCompleted;
      case ProjectStatus.frogged:
        label = AppStrings.statusFrogged;
    }

    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
