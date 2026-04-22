import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dimensions.dart';
import '../../../core/providers.dart';
import '../../../core/strings.dart';

/// Gauge calculator screen.
///
/// Input: stitches and rows in a 10cm/4in swatch.
/// Calculate: stitches/rows needed for target measurements.
/// Reverse: given stitch count, what finished measurement?
class GaugeCalculatorScreen extends ConsumerStatefulWidget {
  const GaugeCalculatorScreen({super.key});

  @override
  ConsumerState<GaugeCalculatorScreen> createState() =>
      _GaugeCalculatorScreenState();
}

class _GaugeCalculatorScreenState extends ConsumerState<GaugeCalculatorScreen> {
  final _stitchesController = TextEditingController();
  final _rowsController = TextEditingController();
  final _targetWidthController = TextEditingController();
  final _targetHeightController = TextEditingController();
  final _reverseStitchesController = TextEditingController();
  final _reverseRowsController = TextEditingController();

  String? _stitchesResult;
  String? _rowsResult;
  String? _reverseWidthResult;
  String? _reverseHeightResult;

  @override
  void dispose() {
    _stitchesController.dispose();
    _rowsController.dispose();
    _targetWidthController.dispose();
    _targetHeightController.dispose();
    _reverseStitchesController.dispose();
    _reverseRowsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final unitSystem = ref.watch(unitSystemProvider);
    final isMetric = unitSystem == UnitSystem.metric;

    final swatchLabel = isMetric ? '10 cm' : '4 in';
    final targetUnit = isMetric ? 'cm' : 'in';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.gaugeCalculator),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Unit Toggle ──
            _UnitToggle(
              isMetric: isMetric,
              onChanged: (value) {
                ref.read(unitSystemProvider.notifier).state =
                    value ? UnitSystem.metric : UnitSystem.imperial;
              },
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Gauge Input ──
            Text(
              'Gauge (per $swatchLabel)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Row(
              children: <Widget>[
                Expanded(
                  child: _NumberField(
                    controller: _stitchesController,
                    label: AppStrings.gaugeStitches,
                    hint: 'e.g., 20',
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                Expanded(
                  child: _NumberField(
                    controller: _rowsController,
                    label: AppStrings.gaugeRows,
                    hint: 'e.g., 28',
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Forward Calculation ──
            Text(
              'Calculate Needed',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Row(
              children: <Widget>[
                Expanded(
                  child: _NumberField(
                    controller: _targetWidthController,
                    label: '${AppStrings.gaugeTargetWidth} ($targetUnit)',
                    hint: 'e.g., 50',
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                Expanded(
                  child: _NumberField(
                    controller: _targetHeightController,
                    label: '${AppStrings.gaugeTargetHeight} ($targetUnit)',
                    hint: 'e.g., 60',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _calculateForward,
                icon: const Icon(Icons.calculate),
                label: const Text(AppStrings.gaugeResult),
              ),
            ),
            if (_stitchesResult != null) ...[
              const SizedBox(height: AppDimensions.spacingMD),
              _ResultCard(
                children: <Widget>[
                  _ResultRow(
                    label: 'Stitches needed:',
                    value: _stitchesResult!,
                    colorScheme: colorScheme,
                  ),
                  _ResultRow(
                    label: 'Rows needed:',
                    value: _rowsResult!,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Reverse Calculation ──
            Text(
              'Calculate Finished Size',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Row(
              children: <Widget>[
                Expanded(
                  child: _NumberField(
                    controller: _reverseStitchesController,
                    label: 'Total Stitches',
                    hint: 'e.g., 100',
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                Expanded(
                  child: _NumberField(
                    controller: _reverseRowsController,
                    label: 'Total Rows',
                    hint: 'e.g., 120',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _calculateReverse,
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Calculate Size'),
              ),
            ),
            if (_reverseWidthResult != null) ...[
              const SizedBox(height: AppDimensions.spacingMD),
              _ResultCard(
                children: <Widget>[
                  _ResultRow(
                    label: 'Finished width:',
                    value: _reverseWidthResult!,
                    colorScheme: colorScheme,
                  ),
                  _ResultRow(
                    label: 'Finished height:',
                    value: _reverseHeightResult!,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  void _calculateForward() {
    final stitches = double.tryParse(_stitchesController.text);
    final rows = double.tryParse(_rowsController.text);
    final targetWidth = double.tryParse(_targetWidthController.text);
    final targetHeight = double.tryParse(_targetHeightController.text);

    if (stitches == null ||
        rows == null ||
        targetWidth == null ||
        targetHeight == null) {
      return;
    }

    final unitSystem = ref.read(unitSystemProvider);
    final isMetric = unitSystem == UnitSystem.metric;
    final swatchSize = isMetric ? 10.0 : 4.0;

    final stitchesPerUnit = stitches / swatchSize;
    final rowsPerUnit = rows / swatchSize;

    final neededStitches = (targetWidth * stitchesPerUnit).round();
    final neededRows = (targetHeight * rowsPerUnit).round();

    setState(() {
      _stitchesResult = neededStitches.toString();
      _rowsResult = neededRows.toString();
    });
  }

  void _calculateReverse() {
    final stitches = double.tryParse(_stitchesController.text);
    final rows = double.tryParse(_rowsController.text);
    final totalStitches = double.tryParse(_reverseStitchesController.text);
    final totalRows = double.tryParse(_reverseRowsController.text);

    if (stitches == null ||
        rows == null ||
        totalStitches == null ||
        totalRows == null) {
      return;
    }

    final unitSystem = ref.read(unitSystemProvider);
    final isMetric = unitSystem == UnitSystem.metric;
    final swatchSize = isMetric ? 10.0 : 4.0;

    final stitchesPerUnit = stitches / swatchSize;
    final rowsPerUnit = rows / swatchSize;

    final width = totalStitches / stitchesPerUnit;
    final height = totalRows / rowsPerUnit;

    final unit = isMetric ? 'cm' : 'in';

    setState(() {
      _reverseWidthResult = '${width.toStringAsFixed(1)} $unit';
      _reverseHeightResult = '${height.toStringAsFixed(1)} $unit';
    });
  }
}

/// Unit toggle switch.
class _UnitToggle extends StatelessWidget {
  const _UnitToggle({
    required this.isMetric,
    required this.onChanged,
  });

  final bool isMetric;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const <ButtonSegment<bool>>[
        ButtonSegment<bool>(
          value: true,
          label: Text(AppStrings.unitMetric),
        ),
        ButtonSegment<bool>(
          value: false,
          label: Text(AppStrings.unitImperial),
        ),
      ],
      selected: <bool>{isMetric},
      onSelectionChanged: (Set<bool> selected) {
        onChanged(selected.first);
      },
    );
  }
}

/// Styled number input field.
class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// Result display card.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingMD),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Individual result row.
class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXS),
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSM),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
