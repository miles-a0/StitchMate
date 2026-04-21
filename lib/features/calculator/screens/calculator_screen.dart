import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Placeholder screen for the Calculator / Tools feature.
///
/// Will be replaced with the full tools implementation in Sprint 5.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.toolsTitle),
      ),
      body: const Center(
        child: Text('Tools Screen — Sprint 5'),
      ),
    );
  }
}
