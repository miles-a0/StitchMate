import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Dialog to manually set the counter value.
///
/// Triggered by long-press on the counter display.
class SetValueDialog extends StatefulWidget {
  const SetValueDialog({
    required this.currentValue,
    super.key,
  });

  final int currentValue;

  @override
  State<SetValueDialog> createState() => _SetValueDialogState();
}

class _SetValueDialogState extends State<SetValueDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text(AppStrings.counterSetValue),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: AppStrings.counterEnterValue,
        ),
        style: theme.textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: () {
            final text = _controller.text.trim();
            final value = int.tryParse(text);
            if (value != null && value >= 0) {
              Navigator.of(context).pop(value);
            }
          },
          child: const Text(AppStrings.save),
        ),
      ],
    );
  }
}
