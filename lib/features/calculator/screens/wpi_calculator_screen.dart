import 'package:flutter/material.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../data/yarn_weight_data.dart';

/// WPI (Wraps Per Inch) calculator screen.
///
/// User enters WPI value and app identifies yarn weight category.
class WpiCalculatorScreen extends StatefulWidget {
  const WpiCalculatorScreen({super.key});

  @override
  State<WpiCalculatorScreen> createState() => _WpiCalculatorScreenState();
}

class _WpiCalculatorScreenState extends State<WpiCalculatorScreen> {
  final _controller = TextEditingController();
  YarnWeightEntry? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wpiCalculator),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ── Explanation ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.info_outline, color: colorScheme.primary),
                        const SizedBox(width: AppDimensions.spacingSM),
                        Text(
                          'How to measure WPI',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingSM),
                    Text(
                      'Wrap your yarn snugly around a ruler or WPI tool. '
                      'Count how many wraps fit in one inch (2.5 cm). '
                      'Do not stretch the yarn.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Input ──
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.wpiInput,
                hintText: 'e.g., 12',
                border: OutlineInputBorder(),
                suffixText: 'wraps/inch',
              ),
              onSubmitted: (_) => _calculate(),
            ),

            const SizedBox(height: AppDimensions.spacingMD),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.search),
                label: const Text(AppStrings.wpiResult),
              ),
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Result ──
            if (_result != null) _YarnWeightResultCard(entry: _result!),

            if (_result == null && _controller.text.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacingMD),
              Center(
                child: Text(
                  'No matching yarn weight found.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppDimensions.spacingLG),

            // ── Reference Table ──
            Text(
              'WPI Reference',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            _WpiReferenceTable(),

            const SizedBox(height: AppDimensions.spacingXL),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    final wpi = int.tryParse(_controller.text);
    if (wpi == null || wpi <= 0) {
      setState(() => _result = null);
      return;
    }

    setState(() {
      _result = YarnWeightData.identifyByWpi(wpi);
    });
  }
}

/// Result card showing identified yarn weight.
class _YarnWeightResultCard extends StatelessWidget {
  const _YarnWeightResultCard({required this.entry});

  final YarnWeightEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              entry.label,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              entry.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            _InfoRow(
              icon: Icons.straighten,
              label: 'WPI Range',
              value: entry.wpiRange,
            ),
            _InfoRow(
              icon: Icons.auto_fix_high,
              label: 'Needles',
              value: '${entry.needleRangeMetric} (${entry.needleRangeUs})',
            ),
            _InfoRow(
              icon: Icons.emoji_objects,
              label: 'Hook',
              value: '${entry.hookRangeMetric} (${entry.hookRangeUs})',
            ),
            _InfoRow(
              icon: Icons.grid_on,
              label: 'Gauge',
              value: '${entry.gaugeStitches10cm} sts / 10 cm',
            ),
          ],
        ),
      ),
    );
  }
}

/// Info row for result card.
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXS),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: AppDimensions.spacingSM),
          Text(
            '$label: ',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// WPI reference table.
class _WpiReferenceTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSM),
        child: Column(
          children: YarnWeightData.allWeights.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingXS,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.wpiRange,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.needleRangeMetric,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
