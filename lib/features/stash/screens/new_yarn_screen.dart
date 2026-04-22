import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/yarn.dart';
import '../stash_provider.dart';

/// Screen for adding a new yarn entry.
///
/// Fields: brand, colour name, weight, fibre, yardage, metreage, grams,
/// skein count, hex colour (picker), notes, purchase location.
class NewYarnScreen extends ConsumerStatefulWidget {
  const NewYarnScreen({super.key});

  @override
  ConsumerState<NewYarnScreen> createState() => _NewYarnScreenState();
}

class _NewYarnScreenState extends ConsumerState<NewYarnScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _colourNameController = TextEditingController();
  final _fibreController = TextEditingController();
  final _yardageController = TextEditingController();
  final _metreageController = TextEditingController();
  final _gramsController = TextEditingController();
  final _skeinCountController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _purchaseLocationController = TextEditingController();

  String _selectedWeight = YarnWeight.worsted;
  String _hexColour = '#7B3F6E';

  @override
  void dispose() {
    _brandController.dispose();
    _colourNameController.dispose();
    _fibreController.dispose();
    _yardageController.dispose();
    _metreageController.dispose();
    _gramsController.dispose();
    _skeinCountController.dispose();
    _notesController.dispose();
    _purchaseLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addYarn),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          children: <Widget>[
            // Colour swatch and picker.
            _ColourPicker(
              hexColour: _hexColour,
              onColourChanged: (colour) => setState(() => _hexColour = colour),
            ),
            const SizedBox(height: AppDimensions.spacingLG),

            // Brand.
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnBrand,
                hintText: AppStrings.yarnBrandHint,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Colour name.
            TextFormField(
              controller: _colourNameController,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnColourName,
                hintText: AppStrings.yarnColourNameHint,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Weight dropdown.
            DropdownButtonFormField<String>(
              value: _selectedWeight,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnWeight,
              ),
              items: YarnWeight.all.map((weight) {
                return DropdownMenuItem(
                  value: weight,
                  child: Text(YarnWeight.label(weight)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedWeight = value);
                }
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Fibre.
            TextFormField(
              controller: _fibreController,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnFibre,
                hintText: AppStrings.yarnFibreHint,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.requiredField;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Yardage / Metreage row.
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _yardageController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.yarnYardage,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                Expanded(
                  child: TextFormField(
                    controller: _metreageController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.yarnMetreage,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Grams / Skein count row.
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _gramsController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.yarnGrams,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMD),
                Expanded(
                  child: TextFormField(
                    controller: _skeinCountController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.yarnSkeinCount,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.requiredField;
                      }
                      final count = int.tryParse(value);
                      if (count == null || count < 1) {
                        return 'Min 1';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Purchase location.
            TextFormField(
              controller: _purchaseLocationController,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnPurchaseLocation,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Notes.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: AppStrings.yarnNotes,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Save button.
            FilledButton(
              onPressed: _saveYarn,
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  void _saveYarn() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(yarnStashProvider.notifier).createYarn(
          brand: _brandController.text.trim(),
          colourName: _colourNameController.text.trim(),
          weight: _selectedWeight,
          fibre: _fibreController.text.trim(),
          yardagePerSkein: int.parse(_yardageController.text.trim()),
          metreagePerSkein: int.parse(_metreageController.text.trim()),
          gramsPerSkein: int.parse(_gramsController.text.trim()),
          skeinCount: int.parse(_skeinCountController.text.trim()),
          hexColour: _hexColour,
          notes: _notesController.text.trim(),
          purchaseLocation: _purchaseLocationController.text.trim().isEmpty
              ? null
              : _purchaseLocationController.text.trim(),
        );

    context.pop();
  }
}

/// Colour picker with preset colours and hex input.
class _ColourPicker extends StatelessWidget {
  const _ColourPicker({
    required this.hexColour,
    required this.onColourChanged,
  });

  final String hexColour;
  final ValueChanged<String> onColourChanged;

  static const List<String> _presetColours = <String>[
    '#7B3F6E',
    '#C2185B',
    '#E91E63',
    '#F48FB1',
    '#9C27B0',
    '#673AB7',
    '#3F51B5',
    '#2196F3',
    '#03A9F4',
    '#00BCD4',
    '#009688',
    '#4CAF50',
    '#8BC34A',
    '#CDDC39',
    '#FFEB3B',
    '#FFC107',
    '#FF9800',
    '#FF5722',
    '#795548',
    '#9E9E9E',
    '#607D8B',
    '#000000',
    '#FFFFFF',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Colour',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        Wrap(
          spacing: AppDimensions.spacingSM,
          runSpacing: AppDimensions.spacingSM,
          children: _presetColours.map((colour) {
            final isSelected = hexColour.toUpperCase() == colour.toUpperCase();
            return InkWell(
              onTap: () => onColourChanged(colour),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _parseHex(colour),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                    width: isSelected ? 3 : 1,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        // Current colour display.
        Row(
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _parseHex(hexColour),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                border: Border.all(color: colorScheme.outline),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSM),
            Text(
              hexColour.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ],
        ),
      ],
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
