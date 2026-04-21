import 'package:flutter/material.dart';

import '../../../core/strings.dart';

/// Placeholder screen for the Projects feature.
///
/// Will be replaced with the full project management implementation in Sprint 2.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.projectsTitle),
      ),
      body: const Center(
        child: Text('Projects Screen — Sprint 2'),
      ),
    );
  }
}
