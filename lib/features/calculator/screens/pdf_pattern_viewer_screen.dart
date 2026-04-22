import 'package:flutter/material.dart';

import '../../../core/dimensions.dart';

/// PDF pattern viewer placeholder.
///
/// Shows a message explaining that PDF pattern import is coming soon.
/// The row highlight tracker UI is built and ready — it just needs a
/// PDF rendering engine that supports Flutter 3.16.9.
class PdfPatternViewerScreen extends StatelessWidget {
  const PdfPatternViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pattern Viewer'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              Text(
                'PDF Pattern Viewer',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingMD),
              Text(
                'Import your knitting and crochet patterns as PDFs, then track your current row with a highlight bar.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingLG),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingMD),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.construction, color: colorScheme.secondary),
                      const SizedBox(height: AppDimensions.spacingSM),
                      Text(
                        'Coming in a future update',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(
                        'We are working on adding PDF import and row tracking. This feature will let you:\n\n'
                        '• Import patterns from your device\n'
                        '• Track your current row with a highlight bar\n'
                        '• Jump to any row instantly\n'
                        '• Keep your place even when you close the app',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
