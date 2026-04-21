import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Placeholder screen for the Stash feature.
///
/// Will be replaced with the full yarn stash implementation in Sprint 4.
class StashScreen extends StatelessWidget {
  const StashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stashTitle),
      ),
      body: const Center(
        child: Text('Stash Screen — Sprint 4'),
      ),
    );
  }
}
