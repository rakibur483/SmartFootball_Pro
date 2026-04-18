import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddInjuryScreen extends StatefulWidget {
  const AddInjuryScreen({super.key});

  @override
  State<AddInjuryScreen> createState() => _AddInjuryScreenState();
}

class _AddInjuryScreenState extends State<AddInjuryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController bodyPartController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController causesController = TextEditingController();
  final TextEditingController recoveryTimeController = TextEditingController();
  final TextEditingController preventionTipsController =
      TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    bodyPartController.dispose();
    descriptionController.dispose();
    symptomsController.dispose();
    causesController.dispose();
    recoveryTimeController.dispose();
    preventionTipsController.dispose();
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

  Future<void> saveInjury() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await firestoreService.addInjury(
        title: titleController.text.trim(),
        category: categoryController.text.trim(),
        bodyPart: bodyPartController.text.trim(),
        description: descriptionController.text.trim(),
        symptoms: symptomsController.text.trim(),
        causes: causesController.text.trim(),
        recoveryTime: recoveryTimeController.text.trim(),
        preventionTips: preventionTipsController.text.trim(),
        imageUrl: imageUrlController.text.trim().isEmpty
            ? 'none'
            : imageUrlController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Injury added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add injury: $e')),
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
        title: const Text('Add Injury'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(controller: titleController, label: 'Title'),
              buildTextField(controller: categoryController, label: 'Category'),
              buildTextField(controller: bodyPartController, label: 'Body Part'),
              buildTextField(
                controller: descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              buildTextField(
                controller: symptomsController,
                label: 'Symptoms',
                maxLines: 3,
              ),
              buildTextField(
                controller: causesController,
                label: 'Causes',
                maxLines: 3,
              ),
              buildTextField(
                controller: recoveryTimeController,
                label: 'Recovery Time',
              ),
              buildTextField(
                controller: preventionTipsController,
                label: 'Prevention Tips',
                maxLines: 3,
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
                  onPressed: isLoading ? null : saveInjury,
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Text('Save Injury'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}