import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddTrainingScreen extends StatefulWidget {
  const AddTrainingScreen({super.key});

  @override
  State<AddTrainingScreen> createState() => _AddTrainingScreenState();
}

class _AddTrainingScreenState extends State<AddTrainingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController benefitsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  String? selectedLevel;
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    benefitsController.dispose();
    stepsController.dispose();
    videoUrlController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (!requiredField) return null;
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
        decoration: fieldDecoration(label),
      ),
    );
  }

  Future<void> saveTraining() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await firestoreService.addTraining(
        title: titleController.text.trim(),
        category: categoryController.text.trim(),
        level: selectedLevel ?? '',
        duration: durationController.text.trim(),
        description: descriptionController.text.trim(),
        benefits: benefitsController.text.trim(),
        steps: stepsController.text.trim(),
        videoUrl: videoUrlController.text.trim().isEmpty
            ? 'none'
            : videoUrlController.text.trim(),
        imageUrl: imageUrlController.text.trim().isEmpty
            ? 'none'
            : imageUrlController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Training added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add training: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Training'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(controller: titleController, label: 'Title'),
              buildTextField(controller: categoryController, label: 'Category'),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: fieldDecoration('Level'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Beginner',
                      child: Text('Beginner'),
                    ),
                    DropdownMenuItem(
                      value: 'Intermediate',
                      child: Text('Intermediate'),
                    ),
                    DropdownMenuItem(
                      value: 'Advanced',
                      child: Text('Advanced'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedLevel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Level is required';
                    }
                    return null;
                  },
                ),
              ),
              buildTextField(controller: durationController, label: 'Duration'),
              buildTextField(
                controller: descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              buildTextField(
                controller: benefitsController,
                label: 'Benefits',
                maxLines: 3,
              ),
              buildTextField(
                controller: stepsController,
                label: 'Steps',
                maxLines: 4,
              ),
              buildTextField(
                controller: videoUrlController,
                label: 'Video URL (optional)',
                requiredField: false,
              ),
              buildTextField(
                controller: imageUrlController,
                label: 'Image URL (optional)',
                requiredField: false,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveTraining,
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Save Training'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}