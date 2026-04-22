import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/yarn.dart';
import '../stash_provider.dart';

/// Screen showing full yarn details with calculator and project links.
class YarnDetailScreen extends ConsumerStatefulWidget {
  const YarnDetailScreen({
    required this.yarnId,
    super.key,
  });

  final String yarnId;

  @override
  ConsumerState<YarnDetailScreen> createState() => _YarnDetailScreenState();
}

class _YarnDetailScreenState extends ConsumerState<YarnDetailScreen> {
  final _neededController = TextEditingController();
  String? _calculatorResult;

  @override
  void dispose() {
    _neededController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final yarn = ref.watch(
      yarnStashProvider.select(
        (state) => state.yarns.firstWhere(
          (y) => y.id == widget.yarnId,
          orElse: () => throw Exception('Yarn not found'),
        ),
      ),
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(yarn.brand),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: AppStrings.editYarn,
            onPressed: () => context.push('/stash/edit', extra: yarn.id),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: AppStrings.deleteYarn,
            onPressed: () => _showDeleteConfirmation(context, yarn),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header with colour swatch.
            _HeaderCard(yarn: yarn),

            const SizedBox(height: AppDimensions.spacingLG),

            // Stats grid.
            _StatsGrid(yarn: yarn),

            const SizedBox(height: AppDimensions.spacingLG),

            // Status section.
            _StatusSection(yarn: yarn),

            const SizedBox(height: AppDimensions.spacingLG),

            // "Do I have enough?" calculator.
            _EnoughYarnCalculator(
              yarn: yarn,
              neededController: _neededController,
              result: _calculatorResult,
              onCalculate: _calculate,
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // Notes.
            if (yarn.notes.isNotEmpty) ...<Widget>[
              Text(
                AppStrings.yarnNotes,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSM),
              Text(yarn.notes, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppDimensions.spacingLG),
            ],

            // Purchase location.
            if (yarn.purchaseLocation != null) ...<Widget>[
              Text(
                AppStrings.yarnPurchaseLocation,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSM),
              Text(yarn.purchaseLocation!, style: theme.textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }

  void _calculate(Yarn yarn) {
    final neededText = _neededController.text.trim();
    if (neededText.isEmpty) return;

    final needed = int.tryParse(neededText);
    if (needed == null || needed <= 0) return;

    final notifier = ref.read(yarnStashProvider.notifier);
    final hasEnough = notifier.hasEnoughYarn(yarn.id, needed);
    final skeinsNeeded = notifier.calculateSkeinsNeeded(yarn.id, needed);

    setState(() {
      _calculatorResult = hasEnough
          ? '${AppStrings.enoughYarnYes}\nYou have ${yarn.totalYardage} yds. Need $needed yds (~$skeinsNeeded skein${skeinsNeeded == 1 ? '' : 's'}).'
          : '${AppStrings.enoughYarnNo}\nYou have ${yarn.totalYardage} yds. Need $needed yds (~$skeinsNeeded skein${skeinsNeeded == 1 ? '' : 's'} required).';
    });
  }

  Future<void> _showDeleteConfirmation(BuildContext context, Yarn yarn) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteYarn),
        content: const Text(AppStrings.deleteYarnConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(yarnStashProvider.notifier).deleteYarn(yarn.id);
      if (context.mounted) context.pop();
    }
  }
}

/// Header card with colour swatch and basic info.
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.yarn});

  final Yarn yarn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Row(
          children: <Widget>[
            // Colour swatch.
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _parseHex(yarn.hexColour),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMD),
            // Info.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    yarn.colourName,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.spacingXS),
                  Text(
                    '${YarnWeight.label(yarn.weight)} · ${yarn.fibre}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingXS),
                  Text(
                    '${yarn.skeinCount} skein${yarn.skeinCount == 1 ? '' : 's'}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseHex(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}

/// Stats grid showing yardage, metreage, grams.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.yarn});

  final Yarn yarn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: _StatCard(
            label: 'Total Yards',
            value: '${yarn.totalYardage}',
            icon: Icons.straighten,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSM),
        Expanded(
          child: _StatCard(
            label: 'Total Metres',
            value: '${yarn.totalMetreage}',
            icon: Icons.straighten,
            color: colorScheme.secondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingSM),
        Expanded(
          child: _StatCard(
            label: 'Total Grams',
            value: '${yarn.totalGrams}',
            icon: Icons.scale,
            color: colorScheme.tertiary,
          ),
        ),
      ],
    );
  }
}

/// Individual stat card.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSM),
        child: Column(
          children: <Widget>[
            Icon(icon, color: color, size: AppDimensions.iconMD),
            const SizedBox(height: AppDimensions.spacingXS),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Status section with dropdown.
class _StatusSection extends ConsumerWidget {
  const _StatusSection({required this.yarn});

  final Yarn yarn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.yarnStatus,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            DropdownButtonFormField<String>(
              value: yarn.status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: YarnStatus.all.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_statusLabel(status)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(yarnStashProvider.notifier)
                      .updateStatus(yarn.id, value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case YarnStatus.available:
        return AppStrings.yarnStatusAvailable;
      case YarnStatus.inUse:
        return AppStrings.yarnStatusInUse;
      case YarnStatus.usedUp:
        return AppStrings.yarnStatusUsedUp;
      default:
        return status;
    }
  }
}

/// "Do I have enough?" calculator widget.
class _EnoughYarnCalculator extends StatelessWidget {
  const _EnoughYarnCalculator({
    required this.yarn,
    required this.neededController,
    required this.result,
    required this.onCalculate,
  });

  final Yarn yarn;
  final TextEditingController neededController;
  final String? result;
  final void Function(Yarn) onCalculate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.enoughYarnTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: neededController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.enoughYarnNeeded,
                      hintText: 'e.g. 400',
                      suffixText: 'yds',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                FilledButton(
                  onPressed: () => onCalculate(yarn),
                  child: const Text('Calculate'),
                ),
              ],
            ),
            if (result != null) ...<Widget>[
              const SizedBox(height: AppDimensions.spacingMD),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spacingMD),
                decoration: BoxDecoration(
                  color: result!.startsWith(AppStrings.enoughYarnYes)
                      ? const Color(0xFFE8F5E9)
                      : colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Text(
                  result!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: result!.startsWith(AppStrings.enoughYarnYes)
                        ? const Color(0xFF2E7D32)
                        : colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
