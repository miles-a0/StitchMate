import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';

/// A large, full-width increment button for the counter screen.
///
/// Must occupy at least 40% of screen height (Harness 1.3 UX Invariants).
/// Supports tap to increment and vertical drag to decrement.
class CounterIncrementButton extends StatefulWidget {
  const CounterIncrementButton({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.isLocked,
    super.key,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLocked;

  @override
  State<CounterIncrementButton> createState() => _CounterIncrementButtonState();
}

class _CounterIncrementButtonState extends State<CounterIncrementButton> {
  double _dragStartY = 0;
  bool _hasDragged = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight =
            constraints.maxHeight * AppDimensions.counterButtonMinScreenRatio;
        final height = minHeight.clamp(
          AppDimensions.counterButtonMinHeight.toDouble(),
          constraints.maxHeight * 0.7,
        );

        return GestureDetector(
          onTap: widget.isLocked ? null : widget.onIncrement,
          onVerticalDragStart: widget.isLocked
              ? null
              : (details) {
                  _dragStartY = details.globalPosition.dy;
                  _hasDragged = false;
                },
          onVerticalDragUpdate: widget.isLocked
              ? null
              : (details) {
                  final delta = details.globalPosition.dy - _dragStartY;
                  if (delta > 60 && !_hasDragged) {
                    _hasDragged = true;
                    HapticFeedback.lightImpact();
                    widget.onDecrement();
                  }
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: widget.isLocked
                  ? colorScheme.surfaceVariant.withOpacity(0.5)
                  : colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: widget.isLocked
                    ? colorScheme.outline.withOpacity(0.3)
                    : colorScheme.primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    widget.isLocked ? Icons.lock : Icons.add,
                    size: AppDimensions.iconXL,
                    color: widget.isLocked
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: AppDimensions.spacingSM),
                  Text(
                    widget.isLocked
                        ? AppStrings.counterLockedMessage
                        : AppStrings.counterIncrement,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: widget.isLocked
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
