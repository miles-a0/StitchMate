import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Placeholder screen for the Dictionary feature.
///
/// Will be replaced with the full stitch dictionary implementation in Sprint 3.
class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dictionaryTitle),
      ),
      body: const Center(
        child: Text('Dictionary Screen — Sprint 3'),
      ),
    );
  }
}
