import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/providers.dart';
import '../../../core/strings.dart';
import '../../../data/models/project.dart';
import '../settings_provider.dart';

/// Settings screen with all configurable app options.
///
/// Sections: Appearance, Craft Defaults, Counter, About.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingMD,
        ),
        children: <Widget>[
          // ── Appearance ──
          const _SectionHeader(title: AppStrings.themeMode),
          _ThemeModeSelector(
            currentMode: settings.themeMode,
            onChanged: notifier.setThemeMode,
          ),
          const Divider(),

          // ── Accent Colour (Pro-gated) ──
          const _SectionHeader(title: AppStrings.accentColour),
          _AccentColourPicker(
            currentColour: settings.accentColour,
            onChanged: notifier.setAccentColour,
          ),
          const Divider(),

          // ── Craft Defaults ──
          const _SectionHeader(title: AppStrings.defaultCraftType),
          _CraftTypeSelector(
            currentType: settings.defaultCraftType,
            onChanged: notifier.setDefaultCraftType,
          ),
          const Divider(),

          // ── Units ──
          const _SectionHeader(title: AppStrings.units),
          _UnitSystemSelector(
            currentSystem: settings.unitSystem,
            onChanged: notifier.setUnitSystem,
          ),
          const Divider(),

          // ── Counter Settings ──
          const _SectionHeader(title: AppStrings.counterTitle),
          _SwitchTile(
            title: AppStrings.counterHaptics,
            value: settings.counterHaptics,
            onChanged: notifier.setCounterHaptics,
          ),
          _CounterSoundSelector(
            currentSound: settings.counterSound,
            onChanged: notifier.setCounterSound,
          ),
          _SwitchTile(
            title: AppStrings.keepScreenAwake,
            value: settings.keepScreenAwake,
            onChanged: notifier.setKeepScreenAwake,
          ),
          const Divider(),

          // ── Data ──
          const _SectionHeader(title: 'Data'),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text(AppStrings.dataExport),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/tools/settings/export'),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text(AppStrings.dataImport),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/tools/settings/export'),
          ),
          const Divider(),

          // ── About ──
          const _SectionHeader(title: AppStrings.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(AppStrings.version),
            trailing: Text(
              '1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text(AppStrings.acknowledgements),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAcknowledgements(context),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/tools/settings/privacy'),
          ),
        ],
      ),
    );
  }

  void _showAcknowledgements(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.acknowledgements),
        content: const SingleChildScrollView(
          child: Text(
            'StitchMate is built with love for knitters and crocheters.\n\n'
            'Open source packages used:\n'
            '• Flutter & Dart (Google)\n'
            '• Riverpod (Remi Rousselet)\n'
            '• Hive (Simon Leier)\n'
            '• go_router (Flutter team)\n'
            '• Google Fonts (Google)\n'
            '• audioplayers (Blue Fire)\n'
            '• intl (Dart team)\n\n'
            'Stitch dictionary data verified against established '
            'knitting and crochet conventions.',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.close),
          ),
        ],
      ),
    );
  }
}

/// Section header.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.spacingSM,
        AppDimensions.screenPadding,
        AppDimensions.spacingXS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Theme mode selector.
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({
    required this.currentMode,
    required this.onChanged,
  });

  final ThemeModeOption currentMode;
  final ValueChanged<ThemeModeOption> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: SegmentedButton<ThemeModeOption>(
        segments: const <ButtonSegment<ThemeModeOption>>[
          ButtonSegment<ThemeModeOption>(
            value: ThemeModeOption.light,
            label: Text(AppStrings.themeLight),
            icon: Icon(Icons.light_mode),
          ),
          ButtonSegment<ThemeModeOption>(
            value: ThemeModeOption.dark,
            label: Text(AppStrings.themeDark),
            icon: Icon(Icons.dark_mode),
          ),
          ButtonSegment<ThemeModeOption>(
            value: ThemeModeOption.system,
            label: Text(AppStrings.themeSystem),
            icon: Icon(Icons.settings_suggest),
          ),
        ],
        selected: <ThemeModeOption>{currentMode},
        onSelectionChanged: (Set<ThemeModeOption> selected) {
          onChanged(selected.first);
        },
      ),
    );
  }
}

/// Accent colour picker.
class _AccentColourPicker extends StatelessWidget {
  const _AccentColourPicker({
    required this.currentColour,
    required this.onChanged,
  });

  final AccentColour currentColour;
  final ValueChanged<AccentColour> onChanged;

  @override
  Widget build(BuildContext context) {
    final colours = <AccentColour, Color>{
      AccentColour.mauve: const Color(0xFF7B3F6E),
      AccentColour.teal: const Color(0xFF006D5B),
      AccentColour.coral: const Color(0xFFE07A5F),
      AccentColour.sage: const Color(0xFF81B29A),
      AccentColour.indigo: const Color(0xFF3D5A80),
      AccentColour.rust: const Color(0xFFB85C38),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: Wrap(
        spacing: AppDimensions.spacingMD,
        runSpacing: AppDimensions.spacingSM,
        children: colours.entries.map((entry) {
          final isSelected = entry.key == currentColour;
          return InkWell(
            onTap: () => onChanged(entry.key),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: entry.value,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 3,
                      )
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Craft type selector.
class _CraftTypeSelector extends StatelessWidget {
  const _CraftTypeSelector({
    required this.currentType,
    required this.onChanged,
  });

  final CraftType currentType;
  final ValueChanged<CraftType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: SegmentedButton<CraftType>(
        segments: const <ButtonSegment<CraftType>>[
          ButtonSegment<CraftType>(
            value: CraftType.knit,
            label: Text(AppStrings.craftKnitting),
          ),
          ButtonSegment<CraftType>(
            value: CraftType.crochet,
            label: Text(AppStrings.craftCrochet),
          ),
          ButtonSegment<CraftType>(
            value: CraftType.both,
            label: Text(AppStrings.craftBoth),
          ),
        ],
        selected: <CraftType>{currentType},
        onSelectionChanged: (Set<CraftType> selected) {
          onChanged(selected.first);
        },
      ),
    );
  }
}

/// Unit system selector.
class _UnitSystemSelector extends StatelessWidget {
  const _UnitSystemSelector({
    required this.currentSystem,
    required this.onChanged,
  });

  final UnitSystem currentSystem;
  final ValueChanged<UnitSystem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: SegmentedButton<UnitSystem>(
        segments: const <ButtonSegment<UnitSystem>>[
          ButtonSegment<UnitSystem>(
            value: UnitSystem.metric,
            label: Text(AppStrings.unitMetric),
          ),
          ButtonSegment<UnitSystem>(
            value: UnitSystem.imperial,
            label: Text(AppStrings.unitImperial),
          ),
        ],
        selected: <UnitSystem>{currentSystem},
        onSelectionChanged: (Set<UnitSystem> selected) {
          onChanged(selected.first);
        },
      ),
    );
  }
}

/// Counter sound selector.
class _CounterSoundSelector extends StatelessWidget {
  const _CounterSoundSelector({
    required this.currentSound,
    required this.onChanged,
  });

  final CounterSound currentSound;
  final ValueChanged<CounterSound> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppStrings.counterSound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DropdownButton<CounterSound>(
            value: currentSound,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
            items: CounterSound.values.map((sound) {
              return DropdownMenuItem<CounterSound>(
                value: sound,
                child: Text(_soundLabel(sound)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _soundLabel(CounterSound sound) {
    switch (sound) {
      case CounterSound.off:
        return 'Off';
      case CounterSound.soft:
        return 'Soft click';
      case CounterSound.loud:
        return 'Loud click';
    }
  }
}

/// Simple switch tile.
class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
