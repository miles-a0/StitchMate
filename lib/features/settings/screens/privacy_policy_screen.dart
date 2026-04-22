import 'package:flutter/material.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';

/// Privacy policy screen.
///
/// Simple markdown-style display of the app's privacy policy.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('${AppStrings.about} — Privacy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              'Last updated: 22 April 2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLG),
            const _Section(
              title: '1. Data Collection',
              body:
                  'StitchMate does not collect any personal data. All information '
                  'you enter (projects, yarn stash, counter values, settings) is '
                  'stored locally on your device only. We do not use analytics, '
                  'tracking, or advertising services.',
            ),
            const _Section(
              title: '2. Data Storage',
              body:
                  'Your data is stored using Hive (a local NoSQL database) and '
                  'SharedPreferences (for app settings). All data remains on your '
                  'device and is never transmitted to our servers or any third party.',
            ),
            const _Section(
              title: '3. Data Export',
              body:
                  'You may export your data as a JSON file at any time via the '
                  'Export feature in Settings. This file is saved to your device’s '
                  'storage and can be shared through your device’s standard sharing '
                  'mechanisms. You are responsible for the security of exported files.',
            ),
            const _Section(
              title: '4. Permissions',
              body: 'StitchMate may request the following permissions:\n'
                  '• Storage access: for exporting and importing backup files\n'
                  '• Haptics: for tactile feedback on the counter\n'
                  '• Keep screen awake: to prevent the screen from turning off while counting',
            ),
            const _Section(
              title: '5. Third-Party Services',
              body: 'StitchMate uses the following open-source packages:\n'
                  '• Flutter and Dart (Google)\n'
                  '• Riverpod (Remi Rousselet)\n'
                  '• Hive (Simon Leier)\n'
                  '• go_router (Flutter team)\n'
                  '• Google Fonts (Google)\n'
                  '• audioplayers (Blue Fire)\n'
                  '• share_plus (Flutter Community)\n'
                  '• path_provider (Flutter team)\n\n'
                  'None of these packages collect personal data.',
            ),
            const _Section(
              title: '6. Contact',
              body:
                  'If you have any questions about this privacy policy, please '
                  'contact us through the app store listing or GitHub repository.',
            ),
            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }
}

/// A single policy section.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSM),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
