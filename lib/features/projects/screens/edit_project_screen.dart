import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/dimensions.dart';
import '../../../core/strings.dart';
import '../../../data/models/project.dart';
import '../projects_provider.dart';

/// Screen for editing an existing project.
///
/// Fields:
/// - Name (required)
/// - Craft type (dropdown)
/// - Start date (date picker)
/// - Notes (multiline)
/// - Needle/hook size (optional)
class EditProjectScreen extends ConsumerStatefulWidget {
  const EditProjectScreen({
    required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late final TextEditingController _needleSizeController;

  late CraftType _craftType;
  late DateTime _startDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _notesController = TextEditingController();
    _needleSizeController = TextEditingController();
    _loadProject();
  }

  void _loadProject() {
    final project =
        ref.read(projectsProvider.notifier).getProjectById(widget.projectId);
    if (project != null) {
      _nameController.text = project.name;
      _notesController.text = project.notes;
      _needleSizeController.text = project.needleSize ?? '';
      _craftType = project.craftType;
      _startDate = project.startDate;
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _needleSizeController.dispose();
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
        title: const Text(AppStrings.editProject),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          children: <Widget>[
            // Project name.
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AppStrings.projectName,
                hintText: AppStrings.projectNameHint,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.requiredField;
                }
                if (value.trim().length > 50) {
                  return AppStrings.nameTooLong;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Craft type.
            DropdownButtonFormField<CraftType>(
              value: _craftType,
              decoration: const InputDecoration(
                labelText: AppStrings.craftType,
              ),
              items: CraftType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_craftTypeLabel(type)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _craftType = value);
                }
              },
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Start date.
            InkWell(
              onTap: _pickStartDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: AppStrings.startDate,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat.yMMMd().format(_startDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Needle/hook size.
            TextFormField(
              controller: _needleSizeController,
              decoration: const InputDecoration(
                labelText: AppStrings.needleSize,
                hintText: AppStrings.needleSizeHint,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMD),

            // Notes.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: AppStrings.projectNotes,
                hintText: AppStrings.projectNotesHint,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value != null && value.length > 1000) {
                  return AppStrings.notesTooLong;
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimensions.spacingXL),

            // Save button.
            FilledButton(
              onPressed: _saveProject,
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  String _craftTypeLabel(CraftType type) {
    switch (type) {
      case CraftType.knit:
        return AppStrings.craftKnitting;
      case CraftType.crochet:
        return AppStrings.craftCrochet;
      case CraftType.both:
        return AppStrings.craftBoth;
    }
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  void _saveProject() {
    if (!_formKey.currentState!.validate()) return;

    final project =
        ref.read(projectsProvider.notifier).getProjectById(widget.projectId);
    if (project == null) return;

    final updated = project.copyWith(
      name: _nameController.text.trim(),
      craftType: _craftType,
      startDate: _startDate,
      notes: _notesController.text.trim(),
      needleSize: _needleSizeController.text.trim().isEmpty
          ? null
          : _needleSizeController.text.trim(),
    );

    ref.read(projectsProvider.notifier).updateProject(updated);
    context.pop();
  }
}
