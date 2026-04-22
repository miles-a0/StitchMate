import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/yarn.dart';
import '../stash_provider.dart';

/// Screen for editing an existing yarn entry.
class EditYarnScreen extends ConsumerStatefulWidget {
  const EditYarnScreen({
    required this.yarnId,
    super.key,
  });

  final String yarnId;

  @override
  ConsumerState<EditYarnScreen> createState() => _EditYarnScreenState();
}

class _EditYarnScreenState extends ConsumerState<EditYarnScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandController;
  late final TextEditingController _colourNameController;
  late final TextEditingController _fibreController;
  late final TextEditingController _yardageController;
  late final TextEditingController _metreageController;
  late final TextEditingController _gramsController;
  late final TextEditingController _skeinCountController;
  late final TextEditingController _notesController;
  late final TextEditingController _purchaseLocationController;

  late String _selectedWeight;
  late String _hexColour;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController();
    _colourNameController = TextEditingController();
    _fibreController = TextEditingController();
    _yardageController = TextEditingController();
    _metreageController = TextEditingController();
    _gramsController = TextEditingController();
    _skeinCountController = TextEditingController();
    _notesController = TextEditingController();
    _purchaseLocationController = TextEditingController();
    _loadYarn();
  }

  void _loadYarn() {
    final yarn = ref.read(yarnStashProvider.notifier).getYarnById(widget.yarnId);
    if (yarn != null) {
      _brandController.text = yarn.brand;
      _colourNameController.text = yarn.colourName;
      _fibreController.text = yarn.fibre;
      _yardageController.text = yarn.yardagePerSkein.toString();
      _metreageController.text = yarn.metreagePerSkein.toString();
      _gramsController.text = yarn.gramsPerSkein.toString();
      _skeinCountController.text = yarn.skeinCount.toString();
      _notesController.text = yarn.notes;
      _purchaseLocationController.text = yarn.purchaseLocation ?? '';
      _selectedWeight = yarn.weight;
      _hexColour = yarn.hexColour;
      setState(() => _isLoading = false);
    }
  }

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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editYarn),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          children: <Widget>[
            // Colour picker.
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

            // Weight.
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

            // Yardage / Metreage.
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

            // Grams / Skein count.
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

    final yarn = ref.read(yarnStashProvider.notifier).getYarnById(widget.yarnId);
    if (yarn == null) return;

    final updated = yarn.copyWith(
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

    ref.read(yarnStashProvider.notifier).updateYarn(updated);
    context.pop();
  }
}

/// Colour picker with preset colours.
class _ColourPicker extends StatelessWidget {
  const _ColourPicker({
    required this.hexColour,
    required this.onColourChanged,
  });

  final String hexColour;
  final ValueChanged<String> onColourChanged;

  static const List<String> _presetColours = <String>[
    '#7B3F6E', '#C2185B', '#E91E63', '#F48FB1',
    '#9C27B0', '#673AB7', '#3F51B5', '#2196F3',
    '#03A9F4', '#00BCD4', '#009688', '#4CAF50',
    '#8BC34A', '#CDDC39', '#FFEB3B', '#FFC107',
    '#FF9800', '#FF5722', '#795548', '#9E9E9E',
    '#607D8B', '#000000', '#FFFFFF',
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
              style: Theme.of(context).textTheme.bodyMedium,
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
