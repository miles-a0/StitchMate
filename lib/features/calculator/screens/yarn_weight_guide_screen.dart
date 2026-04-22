import 'package:flutter/material.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/yarn.dart';
import '../data/yarn_weight_data.dart';

/// Yarn weight reference guide screen.
///
/// Shows detailed cards for each yarn weight category with
/// descriptions, WPI ranges, and recommended needle/hook sizes.
class YarnWeightGuideScreen extends StatelessWidget {
  const YarnWeightGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.yarnWeightGuide),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        itemCount: YarnWeightData.allWeights.length,
        itemBuilder: (context, index) {
          final entry = YarnWeightData.allWeights[index];
          return _YarnWeightCard(entry: entry);
        },
      ),
    );
  }
}

/// Card showing details for a single yarn weight.
class _YarnWeightCard extends StatelessWidget {
  const _YarnWeightCard({required this.entry});

  final YarnWeightEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMD),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title row.
            Row(
              children: <Widget>[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _weightColour(entry.weight, colorScheme),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSM),
                Text(
                  entry.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingSM),

            // Description.
            Text(
              entry.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingMD),

            // Info grid.
            _InfoGrid(entry: entry),
          ],
        ),
      ),
    );
  }

  Color _weightColour(String weight, ColorScheme colorScheme) {
    switch (weight) {
      case YarnWeight.lace:
        return colorScheme.primary.withOpacity(0.3);
      case YarnWeight.fingering:
        return colorScheme.primary.withOpacity(0.4);
      case YarnWeight.sport:
        return colorScheme.primary.withOpacity(0.5);
      case YarnWeight.dk:
        return colorScheme.primary.withOpacity(0.6);
      case YarnWeight.worsted:
        return colorScheme.primary.withOpacity(0.7);
      case YarnWeight.aran:
        return colorScheme.primary.withOpacity(0.8);
      case YarnWeight.bulky:
        return colorScheme.primary.withOpacity(0.9);
      case YarnWeight.superBulky:
        return colorScheme.primary;
      default:
        return colorScheme.primary;
    }
  }
}

/// Info grid showing needle, hook, WPI, and gauge for a weight.
class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.entry});

  final YarnWeightEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = <_GridItem>[
      _GridItem(
        icon: Icons.linear_scale,
        label: 'WPI',
        value: entry.wpiRange,
      ),
      _GridItem(
        icon: Icons.auto_fix_high,
        label: 'Needles',
        value: entry.needleRangeMetric,
      ),
      _GridItem(
        icon: Icons.emoji_objects,
        label: 'Hook',
        value: entry.hookRangeMetric,
      ),
      _GridItem(
        icon: Icons.grid_on,
        label: 'Gauge',
        value: '${entry.gaugeStitches10cm} sts/10cm',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 400 ? 2 : 1;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3.5,
            crossAxisSpacing: AppDimensions.spacingSM,
            mainAxisSpacing: AppDimensions.spacingSM,
            children: items.map((item) {
              return Row(
                children: <Widget>[
                  Icon(item.icon, size: 18, color: colorScheme.primary),
                  const SizedBox(width: AppDimensions.spacingSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          item.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          item.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Data for a single grid item.
class _GridItem {
  const _GridItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}
