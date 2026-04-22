import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';

/// Tools landing screen showing a grid of available tools.
///
/// Replaces the placeholder CalculatorScreen as the root of the Tools tab.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final tools = <_ToolItem>[
      const _ToolItem(
        icon: Icons.straighten,
        label: AppStrings.gaugeCalculator,
        route: '/tools/gauge',
        colourIndex: 0,
      ),
      const _ToolItem(
        icon: Icons.linear_scale,
        label: AppStrings.wpiCalculator,
        route: '/tools/wpi',
        colourIndex: 1,
      ),
      const _ToolItem(
        icon: Icons.table_chart,
        label: AppStrings.needleChart,
        route: '/tools/needles',
        colourIndex: 2,
      ),
      const _ToolItem(
        icon: Icons.category,
        label: AppStrings.yarnWeightGuide,
        route: '/tools/weights',
        colourIndex: 3,
      ),
      const _ToolItem(
        icon: Icons.settings_outlined,
        label: AppStrings.settingsTitle,
        route: '/tools/settings',
        colourIndex: 4,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.toolsTitle),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 600;
          final crossAxisCount = isTablet ? 2 : 1;

          return GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 2.8,
              crossAxisSpacing: AppDimensions.spacingMD,
              mainAxisSpacing: AppDimensions.spacingMD,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              return _ToolCard(
                item: tools[index],
                colorScheme: colorScheme,
              );
            },
          );
        },
      ),
    );
  }
}

/// Data for a single tool card.
class _ToolItem {
  const _ToolItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.colourIndex,
  });

  final IconData icon;
  final String label;
  final String route;
  final int colourIndex;
}

/// Individual tool card.
class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.item,
    required this.colorScheme,
  });

  final _ToolItem item;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final colours = <Color>[
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primary.withOpacity(0.8),
      colorScheme.outline,
    ];

    final bgColours = <Color>[
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
      colorScheme.primaryContainer.withOpacity(0.6),
      colorScheme.surfaceVariant,
    ];

    final colour = colours[item.colourIndex % colours.length];
    final bgColour = bgColours[item.colourIndex % bgColours.length];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: bgColour,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Icon(item.icon, color: colour),
              ),
              const SizedBox(width: AppDimensions.spacingMD),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
