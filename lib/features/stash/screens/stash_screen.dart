import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/yarn.dart';
import '../stash_provider.dart';

/// Yarn stash list screen with colour swatches, filters, and FAB.
class StashScreen extends ConsumerWidget {
  const StashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stashState = ref.watch(yarnStashProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stashTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.spacingSM,
            ),
            child: TextField(
              onChanged: (value) {
                ref.read(yarnStashProvider.notifier).search(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search brand, colour, fibre...',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Filter chips.
          _FilterChips(
            selectedWeight: stashState.selectedWeight,
            selectedStatus: stashState.selectedStatus,
            onWeightChanged: (weight) {
              ref.read(yarnStashProvider.notifier).setWeightFilter(weight);
            },
            onStatusChanged: (status) {
              ref.read(yarnStashProvider.notifier).setStatusFilter(status);
            },
          ),
          const Divider(height: 1),
          // Yarn list.
          Expanded(
            child: _YarnList(
              isLoading: stashState.isLoading,
              error: stashState.error,
              yarns: stashState.filteredYarns,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/stash/new'),
        tooltip: AppStrings.addYarn,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Filter chips for weight and status.
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.selectedWeight,
    required this.selectedStatus,
    required this.onWeightChanged,
    required this.onStatusChanged,
  });

  final String? selectedWeight;
  final String? selectedStatus;
  final ValueChanged<String?> onWeightChanged;
  final ValueChanged<String?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingSM,
      ),
      child: Row(
        children: <Widget>[
          // Weight filters.
          ...YarnWeight.all.map((weight) {
            final isSelected = selectedWeight == weight;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacingSM),
              child: FilterChip(
                label: Text(YarnWeight.label(weight)),
                selected: isSelected,
                onSelected: (_) => onWeightChanged(isSelected ? null : weight),
              ),
            );
          }),
          const VerticalDivider(width: 8),
          // Status filters.
          ...YarnStatus.all.map((status) {
            final isSelected = selectedStatus == status;
            final label = _statusLabel(status);
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.spacingSM),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => onStatusChanged(isSelected ? null : status),
              ),
            );
          }),
        ],
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

/// List of yarn entries or loading/error/empty states.
class _YarnList extends StatelessWidget {
  const _YarnList({
    required this.isLoading,
    required this.error,
    required this.yarns,
  });

  final bool isLoading;
  final String? error;
  final List<Yarn> yarns;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconXL,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            Text(error!),
          ],
        ),
      );
    }

    if (yarns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.yard_outlined,
              size: AppDimensions.iconXL,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            Text(
              'No yarn in stash',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Text(
              'Tap + to add your first yarn',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSM),
      itemCount: yarns.length,
      itemBuilder: (context, index) {
        final yarn = yarns[index];
        return _YarnListTile(yarn: yarn);
      },
    );
  }
}

/// Individual yarn list tile with colour swatch.
class _YarnListTile extends StatelessWidget {
  const _YarnListTile({required this.yarn});

  final Yarn yarn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      leading: _ColourSwatch(hexColour: yarn.hexColour),
      title: Text(
        '${yarn.brand} — ${yarn.colourName}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${YarnWeight.label(yarn.weight)} · ${yarn.fibre}'),
          Text('${yarn.skeinCount} skein${yarn.skeinCount == 1 ? '' : 's'} · ${yarn.totalYardage} yds'),
        ],
      ),
      trailing: _StatusChip(status: yarn.status),
      onTap: () => context.push('/stash/detail', extra: yarn.id),
    );
  }
}

/// Colour swatch widget.
class _ColourSwatch extends StatelessWidget {
  const _ColourSwatch({required this.hexColour});

  final String hexColour;

  @override
  Widget build(BuildContext context) {
    final color = _parseHex(hexColour);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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

/// Status indicator chip.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    switch (status) {
      case YarnStatus.available:
        color = const Color(0xFF4CAF50);
        label = AppStrings.yarnStatusAvailable;
        break;
      case YarnStatus.inUse:
        color = const Color(0xFFFF9800);
        label = AppStrings.yarnStatusInUse;
        break;
      case YarnStatus.usedUp:
        color = Theme.of(context).colorScheme.error;
        label = AppStrings.yarnStatusUsedUp;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingSM,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
