import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/stitch_entry.dart';
import '../dictionary_provider.dart';
import '../favourites_provider.dart';

/// Main dictionary screen with search, craft tabs, category chips, and entry list.
class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dictState = ref.watch(stitchDictionaryProvider);
    final favouritesState = ref.watch(stitchFavouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.dictionaryTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPadding,
              vertical: AppDimensions.spacingSM,
            ),
            child: _SearchField(
              onChanged: (value) {
                ref.read(stitchDictionaryProvider.notifier).search(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Craft filter tabs.
          _CraftFilterTabs(
            selected: dictState.selectedCraft,
            onChanged: (filter) {
              ref
                  .read(stitchDictionaryProvider.notifier)
                  .setCraftFilter(filter);
            },
          ),

          // Category filter chips.
          _CategoryFilterChips(
            selectedCategory: dictState.selectedCategory,
            onChanged: (category) {
              ref
                  .read(stitchDictionaryProvider.notifier)
                  .setCategoryFilter(category);
            },
          ),

          const Divider(height: 1),

          // Entry list.
          Expanded(
            child: _EntryList(
              isLoading: dictState.isLoading,
              error: dictState.error,
              entries: dictState.filteredEntries,
              favouriteIds: favouritesState.favouriteIds,
            ),
          ),
        ],
      ),
    );
  }
}

/// Search text field.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: AppStrings.dictionarySearchHint,
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

/// Craft filter tabs (All / Knitting / Crochet).
class _CraftFilterTabs extends StatelessWidget {
  const _CraftFilterTabs({
    required this.selected,
    required this.onChanged,
  });

  final CraftFilter selected;
  final ValueChanged<CraftFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingSM,
      ),
      child: SegmentedButton<CraftFilter>(
        segments: const <ButtonSegment<CraftFilter>>[
          ButtonSegment<CraftFilter>(
            value: CraftFilter.all,
            label: Text(AppStrings.dictionaryBoth),
          ),
          ButtonSegment<CraftFilter>(
            value: CraftFilter.knitting,
            label: Text(AppStrings.dictionaryKnitting),
          ),
          ButtonSegment<CraftFilter>(
            value: CraftFilter.crochet,
            label: Text(AppStrings.dictionaryCrochet),
          ),
        ],
        selected: <CraftFilter>{selected},
        onSelectionChanged: (Set<CraftFilter> newSelection) {
          if (newSelection.isNotEmpty) {
            onChanged(newSelection.first);
          }
        },
        selectedIcon: const Icon(Icons.check),
      ),
    );
  }
}

/// Horizontal scrollable category filter chips.
class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.selectedCategory,
    required this.onChanged,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final categories = <Map<String, String>>[
      {'key': StitchCategory.basic, 'label': AppStrings.categoryBasic},
      {'key': StitchCategory.increase, 'label': AppStrings.categoryIncrease},
      {'key': StitchCategory.decrease, 'label': AppStrings.categoryDecrease},
      {'key': StitchCategory.cable, 'label': AppStrings.categoryCable},
      {'key': StitchCategory.lace, 'label': AppStrings.categoryLace},
      {'key': StitchCategory.special, 'label': AppStrings.categorySpecial},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: AppDimensions.spacingSM,
      ),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat['key'];
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingSM),
            child: FilterChip(
              label: Text(cat['label']!),
              selected: isSelected,
              onSelected: (_) => onChanged(isSelected ? null : cat['key']),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// List of stitch entries or loading/error/empty states.
class _EntryList extends StatelessWidget {
  const _EntryList({
    required this.isLoading,
    required this.error,
    required this.entries,
    required this.favouriteIds,
  });

  final bool isLoading;
  final String? error;
  final List<StitchEntry> entries;
  final List<String> favouriteIds;

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

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search_off,
              size: AppDimensions.iconXL,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppDimensions.spacingMD),
            Text(
              AppStrings.noResults,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingSM,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isFavourite = favouriteIds.contains(entry.id);
        return _StitchListTile(
          entry: entry,
          isFavourite: isFavourite,
        );
      },
    );
  }
}

/// Individual stitch entry list tile.
class _StitchListTile extends StatelessWidget {
  const _StitchListTile({
    required this.entry,
    required this.isFavourite,
  });

  final StitchEntry entry;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      leading: CircleAvatar(
        backgroundColor: _categoryColor(entry.category, colorScheme),
        child: Text(
          _abbreviationShort(entry.abbreviation),
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        entry.abbreviation,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        entry.fullName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isFavourite)
            Icon(
              Icons.star,
              color: colorScheme.primary,
              size: AppDimensions.iconMD,
            ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => context.push('/dictionary/detail', extra: entry.id),
    );
  }

  String _abbreviationShort(String abbreviation) {
    if (abbreviation.length <= 3) return abbreviation;
    return abbreviation.substring(0, 3);
  }

  Color _categoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case StitchCategory.basic:
        return colorScheme.primary;
      case StitchCategory.increase:
        return const Color(0xFF4CAF50);
      case StitchCategory.decrease:
        return colorScheme.error;
      case StitchCategory.cable:
        return const Color(0xFFFF9800);
      case StitchCategory.lace:
        return const Color(0xFF2196F3);
      case StitchCategory.special:
        return const Color(0xFF9C27B0);
      default:
        return colorScheme.primary;
    }
  }
}
