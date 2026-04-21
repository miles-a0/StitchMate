import 'package:flutter_test/flutter_test.dart';

import 'package:stitch_mate/data/models/counter.dart';
import 'package:stitch_mate/features/counter/counter_provider.dart';

void main() {
  group('Counter Model', () {
    test('Counter copyWith updates fields', () {
      final counter = Counter(id: 'test', label: 'Rows', currentValue: 5);
      final updated = counter.copyWith(currentValue: 10, isLocked: true);

      expect(updated.currentValue, 10);
      expect(updated.isLocked, true);
      expect(updated.label, 'Rows'); // unchanged
      expect(updated.id, 'test'); // unchanged
    });

    test('Counter copyWith preserves nullables when omitted', () {
      final counter = Counter(
        id: 'test',
        label: 'Rows',
        targetValue: 100,
        reminderEvery: 10,
        reminderNote: 'Increase',
      );
      final updated = counter.copyWith(currentValue: 5);

      expect(updated.targetValue, 100);
      expect(updated.reminderEvery, 10);
      expect(updated.reminderNote, 'Increase');
    });

    test('Counter clear methods remove nullable fields', () {
      final counter = Counter(
        id: 'test',
        label: 'Rows',
        targetValue: 100,
        reminderEvery: 10,
        reminderNote: 'Increase',
      );
      final cleared =
          counter.clearTargetValue().clearReminderEvery().clearReminderNote();

      expect(cleared.targetValue, null);
      expect(cleared.reminderEvery, null);
      expect(cleared.reminderNote, null);
    });
  });

  group('CounterState', () {
    test('CounterState copyWith updates fields', () {
      final counter = Counter(id: 'test', label: 'Rows');
      final state = CounterState(counter: counter);
      final updated =
          state.copyWith(showReminder: true, reminderMessage: 'Test');

      expect(updated.showReminder, true);
      expect(updated.reminderMessage, 'Test');
      expect(updated.counter.id, 'test'); // unchanged
    });

    test('CounterState clearError removes error', () {
      final counter = Counter(id: 'test', label: 'Rows');
      final state = CounterState(counter: counter, error: 'Something wrong');
      final cleared = state.clearError();

      expect(cleared.error, null);
    });

    test('CounterState clearReminder removes reminder', () {
      final counter = Counter(id: 'test', label: 'Rows');
      final state = CounterState(
        counter: counter,
        showReminder: true,
        reminderMessage: 'Reminder',
      );
      final cleared = state.clearReminder();

      expect(cleared.showReminder, false);
      expect(cleared.reminderMessage, null);
    });
  });

  group('CounterNotifier Logic', () {
    test('increment increases value by 1', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 5),
      );

      notifier.increment();

      expect(notifier.state.counter.currentValue, 6);
    });

    test('increment does nothing when locked', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 5,
          isLocked: true,
        ),
      );

      notifier.increment();

      expect(notifier.state.counter.currentValue, 5);
    });

    test('decrement decreases value by 1', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 5),
      );

      notifier.decrement();

      expect(notifier.state.counter.currentValue, 4);
    });

    test('decrement does not go below 0', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 0),
      );

      notifier.decrement();

      expect(notifier.state.counter.currentValue, 0);
    });

    test('decrement does nothing when locked', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 5,
          isLocked: true,
        ),
      );

      notifier.decrement();

      expect(notifier.state.counter.currentValue, 5);
    });

    test('setValue sets specific value', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 5),
      );

      notifier.setValue(42);

      expect(notifier.state.counter.currentValue, 42);
    });

    test('setValue does nothing when locked', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 5,
          isLocked: true,
        ),
      );

      notifier.setValue(42);

      expect(notifier.state.counter.currentValue, 5);
    });

    test('setValue does not allow negative values', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 5),
      );

      notifier.setValue(-1);

      expect(notifier.state.counter.currentValue, 5);
    });

    test('toggleLock switches lock state', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', isLocked: false),
      );

      notifier.toggleLock();

      expect(notifier.state.counter.isLocked, true);

      notifier.toggleLock();

      expect(notifier.state.counter.isLocked, false);
    });

    test('reset sets value to 0', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows', currentValue: 100),
      );

      notifier.reset();

      expect(notifier.state.counter.currentValue, 0);
    });

    test('updateLabel changes label', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(id: 'test', label: 'Rows'),
      );

      notifier.updateLabel('Repeats');

      expect(notifier.state.counter.label, 'Repeats');
    });

    test('reminder triggers at correct interval', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 0,
          reminderEvery: 5,
          reminderNote: 'Increase 1 stitch',
        ),
      );

      // Increment to 5 — should trigger reminder.
      notifier.increment(); // 1
      notifier.increment(); // 2
      notifier.increment(); // 3
      notifier.increment(); // 4
      notifier.increment(); // 5

      expect(notifier.state.showReminder, true);
      expect(notifier.state.reminderMessage, 'Increase 1 stitch');
    });

    test('reminder does not trigger at non-interval values', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 0,
          reminderEvery: 5,
        ),
      );

      notifier.increment(); // 1

      expect(notifier.state.showReminder, false);
    });

    test('dismissReminder clears reminder state', () {
      final notifier = CounterNotifier(
        initialCounter: Counter(
          id: 'test',
          label: 'Rows',
          currentValue: 4,
          reminderEvery: 5,
        ),
      );

      notifier.increment(); // 5, triggers reminder
      expect(notifier.state.showReminder, true);

      notifier.dismissReminder();
      expect(notifier.state.showReminder, false);
      expect(notifier.state.reminderMessage, null);
    });
  });
}
