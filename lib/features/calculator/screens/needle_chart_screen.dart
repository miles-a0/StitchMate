import 'package:flutter/material.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../data/needle_size_data.dart';

/// Needle and hook size reference chart.
///
/// Shows conversion tables for knitting needles (US / metric / UK)
/// and crochet hooks (US letter / metric).
class NeedleChartScreen extends StatelessWidget {
  const NeedleChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.needleChart),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Knitting Needles'),
              Tab(text: 'Crochet Hooks'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _KnittingNeedleTable(),
            _CrochetHookTable(),
          ],
        ),
      ),
    );
  }
}

/// Knitting needle conversion table.
class _KnittingNeedleTable extends StatelessWidget {
  const _KnittingNeedleTable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row.
          _TableHeader(
            columns: const ['US Size', 'Metric (mm)', 'UK / Canada'],
            colorScheme: colorScheme,
          ),
          const Divider(),
          // Data rows.
          ...NeedleSizeData.knittingNeedles.map((entry) {
            return _TableRow(
              cells: [
                _cell(entry.usSize),
                _cell('${entry.metricMm} mm', isHighlight: true),
                _cell(entry.ukSize),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// Crochet hook conversion table.
class _CrochetHookTable extends StatelessWidget {
  const _CrochetHookTable();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row.
          _TableHeader(
            columns: const ['US Letter', 'Metric (mm)'],
            colorScheme: colorScheme,
          ),
          const Divider(),
          // Data rows.
          ...NeedleSizeData.crochetHooks.map((entry) {
            return _TableRow(
              cells: [
                _cell(entry.usLetter),
                _cell('${entry.metricMm} mm', isHighlight: true),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// Table header widget.
class _TableHeader extends StatelessWidget {
  const _TableHeader({
    required this.columns,
    required this.colorScheme,
  });

  final List<String> columns;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingSM,
        horizontal: AppDimensions.spacingMD,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      child: Row(
        children: columns.map((col) {
          return Expanded(
            child: Text(
              col,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Table data row widget.
class _TableRow extends StatelessWidget {
  const _TableRow({required this.cells});

  final List<Widget> cells;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingSM,
        horizontal: AppDimensions.spacingMD,
      ),
      child: Row(children: cells),
    );
  }
}

/// Helper to create a table cell.
Widget _cell(String text, {bool isHighlight = false}) {
  return Builder(
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
            color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      );
    },
  );
}
