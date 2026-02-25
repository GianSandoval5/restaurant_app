import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/presentation/providers/category_provider.dart';
import 'package:restaurant_app/presentation/widgets/custom_text_field.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:restaurant_app/data/models/category_model.dart';

class AdminCategoryFormPage extends StatefulWidget {
  final CategoryModel? category; // null = create, not null = edit

  const AdminCategoryFormPage({super.key, this.category});

  @override
  State<AdminCategoryFormPage> createState() => _AdminCategoryFormPageState();
}

class _AdminCategoryFormPageState extends State<AdminCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description;
      _orderController.text = widget.category!.order.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryProvider = context.read<CategoryProvider>();
    bool success = false;

    if (widget.category == null) {
      // Create
      success = await categoryProvider.createCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageFile: _selectedImage,
        order: int.tryParse(_orderController.text) ?? 0,
      );
    } else {
      // Update
      final updatedCategory = widget.category!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        order: int.tryParse(_orderController.text) ?? 0,
      );
      success = await categoryProvider.updateCategory(
        category: updatedCategory,
        newImageFile: _selectedImage,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.category == null
                ? 'Categoría creada exitosamente'
                : 'Categoría actualizada exitosamente',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (categoryProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(categoryProvider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? 'Nueva Categoría' : 'Editar Categoría',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : widget.category?.imageUrl != null &&
                              widget.category!.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.category!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Seleccionar imagen',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre',
                  hint: 'Ej: Pizzas',
                  validator: (value) => Validators.required(value, 'El nombre'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Descripción',
                  hint: 'Describe la categoría',
                  maxLines: 3,
                  validator: (value) =>
                      Validators.required(value, 'La descripción'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _orderController,
                  label: 'Orden',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  validator: Validators.number,
                ),
                const SizedBox(height: 32),
                Consumer<CategoryProvider>(
                  builder: (context, provider, _) {
                    return CustomButton(
                      text: widget.category == null ? 'Crear' : 'Actualizar',
                      onPressed: _save,
                      isLoading: provider.isLoading,
                      width: double.infinity,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
