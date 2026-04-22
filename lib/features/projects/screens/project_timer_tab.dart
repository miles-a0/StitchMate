import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/project.dart';
import '../../timer/timer_provider.dart';

/// Timer tab for the project detail screen.
///
/// Displays a large elapsed time counter, start/pause/stop controls,
/// and a scrollable session history list.
class ProjectTimerTab extends ConsumerWidget {
  const ProjectTimerTab({
    required this.project,
    super.key,
  });

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isThisProjectActive =
        timerState.activeSession?.projectId == project.id;
    final elapsedSeconds = isThisProjectActive
        ? timerState.elapsedSeconds
        : timerState.totalElapsedForProject(project.id);
    final formattedTime = TimerState.formatDuration(elapsedSeconds);

    final sessions = timerState.sessionsForProject(project.id);

    return Column(
      children: <Widget>[
        // ── Timer Display ──
        Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: AppDimensions.spacingXL),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  formattedTime,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontSize: 64,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSM),
                Text(
                  isThisProjectActive &&
                          timerState.status == TimerStatus.running
                      ? AppStrings.timerStart
                      : isThisProjectActive &&
                              timerState.status == TimerStatus.paused
                          ? AppStrings.timerPause
                          : AppStrings.timerTotalTime,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Controls ──
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
          child: Row(
            children: <Widget>[
              // Start / Resume / Pause button.
              Expanded(
                child: _TimerButton(
                  label: _primaryButtonLabel(timerState, isThisProjectActive),
                  icon: _primaryButtonIcon(timerState, isThisProjectActive),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  onPressed: () => _handlePrimaryAction(
                    timerState,
                    isThisProjectActive,
                    timerNotifier,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMD),
              // Stop button (only when running or paused for this project).
              Expanded(
                child: _TimerButton(
                  label: AppStrings.timerStop,
                  icon: Icons.stop,
                  backgroundColor: isThisProjectActive &&
                          timerState.status != TimerStatus.idle
                      ? colorScheme.error
                      : colorScheme.surfaceVariant,
                  foregroundColor: isThisProjectActive &&
                          timerState.status != TimerStatus.idle
                      ? colorScheme.onError
                      : colorScheme.onSurfaceVariant,
                  onPressed: isThisProjectActive &&
                          timerState.status != TimerStatus.idle
                      ? timerNotifier.stopTimer
                      : null,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingMD),

        // ── Session History ──
        Expanded(
          child: sessions.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.timerNoSessions,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSM,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.timer,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(session.formattedDate),
                        subtitle: Text(
                          TimerState.formatDuration(session.durationSeconds),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: AppStrings.delete,
                          onPressed: () => _confirmDeleteSession(
                            context,
                            ref,
                            session.id,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _primaryButtonLabel(TimerState state, bool isThisProject) {
    if (!isThisProject || state.status == TimerStatus.idle) {
      return AppStrings.timerStart;
    }
    if (state.status == TimerStatus.running) {
      return AppStrings.timerPause;
    }
    return AppStrings.timerStart;
  }

  IconData _primaryButtonIcon(TimerState state, bool isThisProject) {
    if (!isThisProject || state.status == TimerStatus.idle) {
      return Icons.play_arrow;
    }
    if (state.status == TimerStatus.running) {
      return Icons.pause;
    }
    return Icons.play_arrow;
  }

  void _handlePrimaryAction(
    TimerState state,
    bool isThisProject,
    TimerNotifier notifier,
  ) {
    if (!isThisProject || state.status == TimerStatus.idle) {
      notifier.startTimer(project.id);
      return;
    }
    if (state.status == TimerStatus.running) {
      notifier.pauseTimer();
      return;
    }
    if (state.status == TimerStatus.paused) {
      notifier.resumeTimer();
      return;
    }
  }

  void _confirmDeleteSession(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: const Text(AppStrings.deleteYarnConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(timerProvider.notifier).deleteSession(sessionId);
              Navigator.of(context).pop();
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Styled timer control button.
class _TimerButton extends StatelessWidget {
  const _TimerButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size(0, 56),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
