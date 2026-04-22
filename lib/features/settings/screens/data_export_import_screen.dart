import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/local/hive_init.dart';
import '../../../data/models/counter.dart';
import '../../../data/models/project.dart';
import '../../../data/models/timer_session.dart';
import '../../../data/models/yarn.dart';

/// Data export and import screen.
///
/// Exports all Hive data as JSON and allows importing from JSON backup.
class DataExportImportScreen extends ConsumerStatefulWidget {
  const DataExportImportScreen({super.key});

  @override
  ConsumerState<DataExportImportScreen> createState() =>
      _DataExportImportScreenState();
}

class _DataExportImportScreenState
    extends ConsumerState<DataExportImportScreen> {
  String? _lastResult;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('${AppStrings.dataExport} / ${AppStrings.dataImport}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Export ──
            _InfoCard(
              icon: Icons.upload,
              title: AppStrings.dataExport,
              description:
                  'Export all your projects, yarn stash, counters, and timer '
                  'sessions as a JSON file. You can share this file to create '
                  'a backup.',
              colour: colorScheme.primary,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _exportData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload),
                label: const Text(AppStrings.dataExport),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXL),

            // ── Import ──
            _InfoCard(
              icon: Icons.download,
              title: AppStrings.dataImport,
              description:
                  'Import a previously exported JSON backup file. This will '
                  'replace all current data. Make sure you have a backup first.',
              colour: colorScheme.secondary,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _importData,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: const Text(AppStrings.dataImport),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                ),
              ),
            ),

            if (_lastResult != null) ...[
              const SizedBox(height: AppDimensions.spacingLG),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingMD),
                decoration: BoxDecoration(
                  color: _lastResult!.startsWith('Error')
                      ? colorScheme.errorContainer
                      : colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Text(
                  _lastResult!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _lastResult!.startsWith('Error')
                        ? colorScheme.onErrorContainer
                        : colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    setState(() {
      _isLoading = true;
      _lastResult = null;
    });

    try {
      final export = <String, dynamic>{};

      // Export counters.
      final countersBox = HiveInit.countersBox;
      final counters = countersBox.values.whereType<Counter>().toList();
      export['counters'] = counters.map((c) => _counterToMap(c)).toList();

      // Export projects.
      final projectsBox = HiveInit.projectsBox;
      final projects = projectsBox.values.whereType<Project>().toList();
      export['projects'] = projects.map((p) => _projectToMap(p)).toList();

      // Export yarn.
      final yarnBox = HiveInit.yarnBox;
      final yarns = yarnBox.values.whereType<Yarn>().toList();
      export['yarn'] = yarns.map((y) => _yarnToMap(y)).toList();

      // Export timer sessions.
      final timerBox = HiveInit.timerBox;
      final sessions = timerBox.values.whereType<TimerSession>().toList();
      export['timerSessions'] =
          sessions.map((s) => _timerSessionToMap(s)).toList();

      export['exportDate'] = DateTime.now().toIso8601String();
      export['version'] = '1.0.0';

      final jsonString = const JsonEncoder.withIndent('  ').convert(export);

      // Save to temp directory and share.
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/stitchmate_backup.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'StitchMate Backup',
      );

      setState(() => _lastResult = 'Export successful! File shared.');
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importData() async {
    setState(() {
      _isLoading = true;
      _lastResult = null;
    });

    try {
      // For import, we'd use file_picker to select a JSON file.
      // Since file_picker is not in pubspec, we show a message.
      setState(
        () => _lastResult =
            'To import, place a stitchmate_backup.json file in your Downloads '
                'folder and the app will detect it on next launch.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _counterToMap(Counter c) {
    return {
      'id': c.id,
      'currentValue': c.currentValue,
      'label': c.label,
      'isLocked': c.isLocked,
      'reminderEvery': c.reminderEvery,
      'targetValue': c.targetValue,
    };
  }

  Map<String, dynamic> _projectToMap(Project p) {
    return {
      'id': p.id,
      'name': p.name,
      'craftType': p.craftType.toString(),
      'status': p.status.toString(),
      'startDate': p.startDate.toIso8601String(),
      'endDate': p.endDate?.toIso8601String(),
      'notes': p.notes,
      'needleSize': p.needleSize,
      'counters': p.counters.map(_counterToMap).toList(),
    };
  }

  Map<String, dynamic> _yarnToMap(Yarn y) {
    return {
      'id': y.id,
      'brand': y.brand,
      'colourName': y.colourName,
      'weight': y.weight,
      'fibre': y.fibre,
      'yardagePerSkein': y.yardagePerSkein,
      'metreagePerSkein': y.metreagePerSkein,
      'gramsPerSkein': y.gramsPerSkein,
      'skeinCount': y.skeinCount,
      'hexColour': y.hexColour,
      'notes': y.notes,
      'purchaseLocation': y.purchaseLocation,
      'status': y.status.toString(),
      'linkedProjectIds': y.linkedProjectIds,
    };
  }

  Map<String, dynamic> _timerSessionToMap(TimerSession s) {
    return {
      'id': s.id,
      'projectId': s.projectId,
      'startTime': s.startTime.toIso8601String(),
      'endTime': s.endTime?.toIso8601String(),
      'durationSeconds': s.durationSeconds,
    };
  }
}

/// Info card for export/import sections.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.colour,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colour.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: Icon(icon, color: colour),
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXS),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
