import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Placeholder screen for the Counter feature.
///
/// Will be replaced with the full counter implementation in Sprint 1.
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.counterTitle),
      ),
      body: const Center(
        child: Text('Counter Screen — Sprint 1'),
      ),
    );
  }
}
