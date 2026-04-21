import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/stitch_entry.dart';
import '../dictionary_provider.dart';
import '../favourites_provider.dart';

/// Detail screen showing full information for a single stitch entry.
///
/// Features:
/// - Full name, abbreviation, craft, category, difficulty
/// - Description and step-by-step instructions
/// - Also known as aliases
/// - US/UK region indicators
/// - Favourite toggle (Pro-gated)
class StitchDetailScreen extends ConsumerWidget {
  const StitchDetailScreen({
    required this.stitchId,
    super.key,
  });

  final String stitchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(
      stitchDictionaryProvider.select(
        (state) => state.allEntries.firstWhere(
          (e) => e.id == stitchId,
          orElse: () => throw Exception('Stitch not found: $stitchId'),
        ),
      ),
    );

    final isFavourite = ref.watch(
      stitchFavouritesProvider.select((state) => state.isFavourite(stitchId)),
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.abbreviation),
        actions: <Widget>[
          _FavouriteButton(
            stitchId: stitchId,
            isFavourite: isFavourite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header card.
            _HeaderCard(entry: entry),

            const SizedBox(height: AppDimensions.spacingLG),

            // Description.
            const _SectionTitle(title: AppStrings.dictionaryTitle),
            Text(
              entry.description,
              style: theme.textTheme.bodyLarge,
            ),

            const SizedBox(height: AppDimensions.spacingLG),

            // Steps.
            if (entry.steps.isNotEmpty) ...<Widget>[
              const _SectionTitle(title: AppStrings.steps),
              _StepsList(steps: entry.steps),
              const SizedBox(height: AppDimensions.spacingLG),
            ],

            // Also known as.
            if (entry.alsoKnownAs.isNotEmpty) ...<Widget>[
              const _SectionTitle(title: AppStrings.alsoKnownAs),
              Wrap(
                spacing: AppDimensions.spacingSM,
                children: entry.alsoKnownAs.map((aka) {
                  return Chip(
                    label: Text(aka),
                    backgroundColor: colorScheme.secondaryContainer,
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spacingLG),
            ],

            // Region indicators.
            _RegionIndicators(
              usRegion: entry.usRegion,
              ukRegion: entry.ukRegion,
            ),
          ],
        ),
      ),
    );
  }
}

/// Favourite toggle button in AppBar.
class _FavouriteButton extends ConsumerWidget {
  const _FavouriteButton({
    required this.stitchId,
    required this.isFavourite,
  });

  final String stitchId;
  final bool isFavourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      icon: Icon(
        isFavourite ? Icons.star : Icons.star_border,
        color: isFavourite ? colorScheme.primary : null,
      ),
      tooltip: isFavourite ? 'Remove from favourites' : 'Add to favourites',
      onPressed: () {
        final success = ref
            .read(stitchFavouritesProvider.notifier)
            .toggleFavourite(stitchId);

        if (!success) {
          _showProDialog(context);
        }
      },
    );
  }

  void _showProDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.proFeatureLocked),
        content: const Text(AppStrings.proFeatureLockedMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
        ],
      ),
    );
  }
}

/// Header card with key metadata.
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.entry});

  final StitchEntry entry;

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
              entry.fullName,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.spacingSM),
            Wrap(
              spacing: AppDimensions.spacingSM,
              runSpacing: AppDimensions.spacingSM,
              children: <Widget>[
                _MetaChip(
                  label: _craftLabel(entry.craft),
                  icon: _craftIcon(entry.craft),
                ),
                _MetaChip(
                  label: _categoryLabel(entry.category),
                  backgroundColor: _categoryColor(entry.category, colorScheme),
                ),
                _MetaChip(
                  label: _difficultyLabel(entry.difficulty),
                  icon: Icons.signal_cellular_alt,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _craftLabel(String craft) {
    switch (craft) {
      case StitchCraft.knitting:
        return AppStrings.craftKnitting;
      case StitchCraft.crochet:
        return AppStrings.craftCrochet;
      default:
        return craft;
    }
  }

  IconData _craftIcon(String craft) {
    switch (craft) {
      case StitchCraft.knitting:
        return Icons.auto_fix_high;
      case StitchCraft.crochet:
        return Icons.emoji_objects;
      default:
        return Icons.help;
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case StitchCategory.basic:
        return AppStrings.categoryBasic;
      case StitchCategory.increase:
        return AppStrings.categoryIncrease;
      case StitchCategory.decrease:
        return AppStrings.categoryDecrease;
      case StitchCategory.cable:
        return AppStrings.categoryCable;
      case StitchCategory.lace:
        return AppStrings.categoryLace;
      case StitchCategory.special:
        return AppStrings.categorySpecial;
      default:
        return category;
    }
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

  String _difficultyLabel(String difficulty) {
    switch (difficulty) {
      case StitchDifficulty.beginner:
        return AppStrings.difficultyBeginner;
      case StitchDifficulty.intermediate:
        return AppStrings.difficultyIntermediate;
      case StitchDifficulty.advanced:
        return AppStrings.difficultyAdvanced;
      default:
        return difficulty;
    }
  }
}

/// Section title text.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Numbered list of steps.
class _StepsList extends StatelessWidget {
  const _StepsList({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingSM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSM),
              Expanded(
                child: Text(
                  steps[index],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

/// US/UK region indicator chips.
class _RegionIndicators extends StatelessWidget {
  const _RegionIndicators({
    required this.usRegion,
    required this.ukRegion,
  });

  final bool usRegion;
  final bool ukRegion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        if (usRegion)
          Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingSM),
            child: Chip(
              avatar: const Icon(Icons.flag, size: 16),
              label: const Text('US'),
              backgroundColor: colorScheme.tertiaryContainer,
            ),
          ),
        if (ukRegion)
          Chip(
            avatar: const Icon(Icons.flag, size: 16),
            label: const Text('UK'),
            backgroundColor: colorScheme.tertiaryContainer,
          ),
      ],
    );
  }
}

/// Small metadata chip for header card.
class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
    this.icon,
    this.backgroundColor,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? colorScheme.secondaryContainer;
    final fg = backgroundColor != null
        ? colorScheme.onPrimary
        : colorScheme.onSecondaryContainer;

    return Chip(
      avatar: icon != null
          ? Icon(icon, size: 16, color: fg)
          : null,
      label: Text(label),
      backgroundColor: bg,
      labelStyle: TextStyle(color: fg, fontSize: 12),
      padding: EdgeInsets.zero,
    );
  }
}
