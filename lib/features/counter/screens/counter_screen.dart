import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../core/providers.dart';
import '../../../features/settings/settings_provider.dart';
import '../counter_provider.dart';
import '../widgets/counter_increment_button.dart';
import '../widgets/set_value_dialog.dart';

/// The main counter screen.
///
/// Features:
/// - Large increment button (>= 40% screen height)
/// - Large-font display optimised for reading at arm's length
/// - Swipe down to decrement
/// - Long-press display to set value
/// - Lock mode toggle
/// - Reset with two-step confirmation
/// - Haptic and sound feedback (if enabled)
class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(quickCounterProvider);
    final counter = counterState.counter;
    final notifier = ref.read(quickCounterProvider.notifier);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(counter.label),
        actions: <Widget>[
          // Lock toggle.
          IconButton(
            icon: Icon(
              counter.isLocked ? Icons.lock : Icons.lock_open,
              color: counter.isLocked ? colorScheme.error : null,
            ),
            tooltip: counter.isLocked
                ? AppStrings.counterUnlock
                : AppStrings.counterLock,
            onPressed: notifier.toggleLock,
          ),
          // Reset button.
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppStrings.counterReset,
            onPressed: () => _showResetConfirmation(context, notifier),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            children: <Widget>[
              // Reminder banner.
              if (counterState.showReminder &&
                  counterState.reminderMessage != null)
                _ReminderBanner(
                  message: counterState.reminderMessage!,
                  onDismiss: notifier.dismissReminder,
                ),

              // Counter display (long-press to set value).
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onLongPress: counter.isLocked
                      ? null
                      : () => _showSetValueDialog(
                            context,
                            counter.currentValue,
                            notifier,
                          ),
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

              // Target progress (if set).
              if (counter.targetValue != null && counter.targetValue! > 0)
                _TargetProgress(
                  current: counter.currentValue,
                  target: counter.targetValue!,
                ),

              const SizedBox(height: AppDimensions.spacingMD),

              // Large increment button.
              Expanded(
                flex: 3,
                child: CounterIncrementButton(
                  value: counter.currentValue,
                  onIncrement: () => _handleIncrement(ref),
                  onDecrement: notifier.decrement,
                  isLocked: counter.isLocked,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingMD),

              // Decrement hint.
              Text(
                AppStrings.counterDecrement,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle increment with haptic and sound feedback.
  void _handleIncrement(WidgetRef ref) {
    final notifier = ref.read(quickCounterProvider.notifier);
    final hapticsEnabled = ref.read(counterHapticsProvider);
    final soundEnabled = ref.read(counterSoundProvider);

    if (hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }

    if (soundEnabled != CounterSound.off) {
      // Lightweight click sound using system assets.
      final player = AudioPlayer();
      player.play(AssetSource('sounds/click.mp3'));
    }

    notifier.increment();
  }

  /// Show two-step reset confirmation dialog.
  Future<void> _showResetConfirmation(
    BuildContext context,
    CounterNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.counterReset),
        content: const Text(
          'Are you sure you want to reset the counter to 0?',
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
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      notifier.reset();
    }
  }

  /// Show dialog to set a specific counter value.
  Future<void> _showSetValueDialog(
    BuildContext context,
    int currentValue,
    CounterNotifier notifier,
  ) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => SetValueDialog(currentValue: currentValue),
    );

    if (result != null) {
      notifier.setValue(result);
    }
  }
}

/// Reminder banner shown when a stitch marker interval is reached.
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

    return MaterialBanner(
      content: Text(
        message,
        style: TextStyle(color: colorScheme.onSecondaryContainer),
      ),
      backgroundColor: colorScheme.secondaryContainer,
      leading: Icon(
        Icons.notifications_active,
        color: colorScheme.onSecondaryContainer,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onDismiss,
          child: Text(
            AppStrings.gotIt,
            style: TextStyle(color: colorScheme.onSecondaryContainer),
          ),
        ),
      ],
    );
  }
}

/// Progress indicator shown when a target value is set.
class _TargetProgress extends StatelessWidget {
  const _TargetProgress({
    required this.current,
    required this.target,
  });

  final int current;
  final int target;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: progress,
          backgroundColor: colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          minHeight: 8,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(
          '$current / $target',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
