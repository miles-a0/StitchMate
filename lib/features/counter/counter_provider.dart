import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_init.dart';
import '../../data/models/counter.dart';

/// Immutable state class for the counter feature.
///
/// Holds the current [Counter] model plus UI-derived flags.
class CounterState {
  const CounterState({
    required this.counter,
    this.isLoading = false,
    this.error,
    this.showReminder = false,
    this.reminderMessage,
  });

  final Counter counter;
  final bool isLoading;
  final String? error;
  final bool showReminder;
  final String? reminderMessage;

  CounterState copyWith({
    Counter? counter,
    bool? isLoading,
    String? error,
    bool? showReminder,
    String? reminderMessage,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
      error: error == _clearSentinel ? null : (error ?? this.error),
      showReminder: showReminder ?? this.showReminder,
      reminderMessage: reminderMessage == _clearSentinel
          ? null
          : (reminderMessage ?? this.reminderMessage),
    );
  }

  static const String _clearSentinel = '\x00CLEAR\x00';

  CounterState clearError() => copyWith(error: _clearSentinel);
  CounterState clearReminder() => copyWith(
        showReminder: false,
        reminderMessage: _clearSentinel,
      );

  @override
  String toString() {
    return 'CounterState(counter: $counter, loading: $isLoading, error: $error, reminder: $showReminder)';
  }
}

/// Riverpod StateNotifier for counter business logic.
///
/// All mutations persist to Hive immediately (fire-and-forget via [unawaited]).
class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier({Counter? initialCounter})
      : super(
          CounterState(
            counter: initialCounter ??
                Counter(
                  id: 'quick_counter',
                  label: 'Rows',
                ),
          ),
        ) {
    _loadFromHive();
  }

  static const String _hiveKey = 'quick_counter';

  /// Load existing counter from Hive if present.
  void _loadFromHive() {
    try {
      final box = HiveInit.countersBox;
      final saved = box.get(_hiveKey);
      if (saved is Counter) {
        state = state.copyWith(counter: saved);
      } else {
        // Save the default counter immediately.
        _persist(state.counter);
      }
    } catch (_) {
      // Hive not initialised in test environment — use default counter.
    }
  }

  /// Increment the counter by 1.
  ///
  /// Does nothing if the counter is locked.
  /// Persists to Hive immediately.
  void increment() {
    if (state.counter.isLocked) return;

    final newValue = state.counter.currentValue + 1;
    final updated = state.counter.copyWith(currentValue: newValue);

    // Check reminder.
    bool showReminder = false;
    String? reminderMessage;
    if (updated.reminderEvery != null &&
        updated.reminderEvery! > 0 &&
        newValue % updated.reminderEvery! == 0) {
      showReminder = true;
      reminderMessage = updated.reminderNote ??
          'Reminder every ${updated.reminderEvery} rows';
    }

    state = state.copyWith(
      counter: updated,
      showReminder: showReminder,
      reminderMessage: reminderMessage,
    );

    _persist(updated);
  }

  /// Decrement the counter by 1 (undo last tap).
  ///
  /// Does nothing if the counter is locked or already at 0.
  /// Persists to Hive immediately.
  void decrement() {
    if (state.counter.isLocked) return;
    if (state.counter.currentValue <= 0) return;

    final newValue = state.counter.currentValue - 1;
    final updated = state.counter.copyWith(currentValue: newValue);
    state = state.copyWith(counter: updated, showReminder: false);
    _persist(updated);
  }

  /// Set the counter to a specific value.
  ///
  /// Does nothing if the counter is locked.
  /// Persists to Hive immediately.
  void setValue(int value) {
    if (state.counter.isLocked) return;
    if (value < 0) return;

    final updated = state.counter.copyWith(currentValue: value);
    state = state.copyWith(counter: updated, showReminder: false);
    _persist(updated);
  }

  /// Toggle lock mode on/off.
  ///
  /// Persists to Hive immediately.
  void toggleLock() {
    final updated = state.counter.copyWith(isLocked: !state.counter.isLocked);
    state = state.copyWith(counter: updated);
    _persist(updated);
  }

  /// Reset the counter to 0.
  ///
  /// Requires explicit confirmation from the UI (two-step).
  /// Persists to Hive immediately.
  void reset() {
    final updated = state.counter.copyWith(currentValue: 0);
    state = state.copyWith(counter: updated, showReminder: false);
    _persist(updated);
  }

  /// Update the counter label.
  void updateLabel(String label) {
    final updated = state.counter.copyWith(label: label);
    state = state.copyWith(counter: updated);
    _persist(updated);
  }

  /// Update reminder settings.
  void updateReminder({int? every, String? note}) {
    final updated = state.counter.copyWith(
      reminderEvery: every,
      reminderNote: note,
    );
    state = state.copyWith(counter: updated);
    _persist(updated);
  }

  /// Clear reminder settings.
  void clearReminder() {
    final updated = state.counter.clearReminderEvery().clearReminderNote();
    state = state.copyWith(counter: updated);
    _persist(updated);
  }

  /// Dismiss the reminder banner.
  void dismissReminder() {
    state = state.clearReminder();
  }

  /// Persist counter to Hive (fire-and-forget).
  void _persist(Counter counter) {
    try {
      HiveInit.countersBox.put(_hiveKey, counter);
    } catch (_) {
      // Hive not initialised in test environment — silently skip.
    }
  }
}

/// Provider for the quick counter (standalone, no project).
final quickCounterProvider =
    StateNotifierProvider<CounterNotifier, CounterState>((ref) {
  return CounterNotifier();
});
