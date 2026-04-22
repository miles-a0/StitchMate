import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/project.dart';
import '../projects_provider.dart';
import '../../counter/widgets/counter_increment_button.dart';
import '../../counter/widgets/set_value_dialog.dart';

/// Counter tab with project-specific counter.
///
/// Features:
/// - Large display with long-press set-value dialog
/// - Increment button (tap) / decrement (swipe down)
/// - Lock toggle
/// - Two-step reset confirmation
/// - Reminder banner when stitch marker interval reached
/// - Target progress bar (if targetValue set)
class ProjectCounterTab extends ConsumerWidget {
  const ProjectCounterTab({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = project.getPrimaryCounter();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Check reminder.
    final bool showReminder = counter.reminderEvery != null &&
        counter.reminderEvery! > 0 &&
        counter.currentValue > 0 &&
        counter.currentValue % counter.reminderEvery! == 0;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        children: <Widget>[
          // Reminder banner.
          if (showReminder)
            _ReminderBanner(
              message: counter.reminderNote ??
                  '${AppStrings.counterReminderEvery} ${counter.reminderEvery} ${AppStrings.counterRows}',
              onDismiss: () => _dismissReminder(ref),
            ),

          // Target progress bar.
          if (counter.targetValue != null && counter.targetValue! > 0)
            _TargetProgressBar(
              current: counter.currentValue,
              target: counter.targetValue!,
            ),

          const SizedBox(height: AppDimensions.spacingSM),

          // Counter display.
          Expanded(
            flex: 2,
            child: GestureDetector(
              onLongPress: counter.isLocked
                  ? null
                  : () => _showSetValueDialog(context, ref),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    counter.currentValue.toString(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: AppDimensions.counterFontSize,
                      fontWeight: FontWeight.bold,
                      color: counter.isLocked
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Lock toggle and reset row.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FilterChip(
                label: Text(
                  counter.isLocked
                      ? AppStrings.counterLock
                      : AppStrings.counterUnlock,
                ),
                selected: counter.isLocked,
                onSelected: (_) => _toggleLock(ref),
                avatar: Icon(
                  counter.isLocked ? Icons.lock : Icons.lock_open,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMD),
              FilterChip(
                label: const Text(AppStrings.counterReset),
                onSelected: (_) => _showResetConfirmation(context, ref),
                avatar: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingMD),

          // Increment button.
          Expanded(
            flex: 3,
            child: CounterIncrementButton(
              value: counter.currentValue,
              onIncrement: () => _increment(ref),
              onDecrement: () => _decrement(ref),
              isLocked: counter.isLocked,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingSM),

          // Decrement hint.
          Text(
            '${AppStrings.counterDecrement} — ${AppStrings.counterSwipeHint}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _increment(WidgetRef ref) {
    final counter = project.getPrimaryCounter();
    if (counter.isLocked) return;

    final newValue = counter.currentValue + 1;
    final updated = counter.copyWith(currentValue: newValue);
    ref
        .read(projectsProvider.notifier)
        .updateProjectCounter(project.id, updated);

    HapticFeedback.mediumImpact();
  }

  void _decrement(WidgetRef ref) {
    final counter = project.getPrimaryCounter();
    if (counter.isLocked) return;
    if (counter.currentValue <= 0) return;

    final updated = counter.copyWith(currentValue: counter.currentValue - 1);
    ref
        .read(projectsProvider.notifier)
        .updateProjectCounter(project.id, updated);
  }

  void _toggleLock(WidgetRef ref) {
    final counter = project.getPrimaryCounter();
    final updated = counter.copyWith(isLocked: !counter.isLocked);
    ref
        .read(projectsProvider.notifier)
        .updateProjectCounter(project.id, updated);
  }

  Future<void> _showSetValueDialog(BuildContext context, WidgetRef ref) async {
    final counter = project.getPrimaryCounter();
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SetValueDialog(currentValue: counter.currentValue),
    );

    if (result != null) {
      final updated = counter.copyWith(currentValue: result);
      ref
          .read(projectsProvider.notifier)
          .updateProjectCounter(project.id, updated);
    }
  }

  Future<void> _showResetConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final counter = project.getPrimaryCounter();
    if (counter.isLocked) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.counterReset),
        content: Text(
          '${AppStrings.counterResetConfirm}\n\n${AppStrings.counterCurrentValue}: ${counter.currentValue}',
        ),
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
            child: const Text(AppStrings.counterReset),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final updated = counter.copyWith(currentValue: 0);
      ref
          .read(projectsProvider.notifier)
          .updateProjectCounter(project.id, updated);
    }
  }

  void _dismissReminder(WidgetRef ref) {
    // Reminder is computed from counter state, so it auto-dismisses
    // on next increment. No state change needed.
  }
}

/// Reminder banner displayed when stitch marker interval is reached.
class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMD,
          vertical: AppDimensions.spacingSM,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.notifications_active,
              color: colorScheme.onSecondaryContainer,
              size: AppDimensions.iconMD,
            ),
            const SizedBox(width: AppDimensions.spacingSM),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: colorScheme.onSecondaryContainer,
              onPressed: onDismiss,
              tooltip: AppStrings.close,
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress bar showing progress toward a target value.
class _TargetProgressBar extends StatelessWidget {
  const _TargetProgressBar({
    required this.current,
    required this.target,
  });

  final int current;
  final int target;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$current / $target',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
