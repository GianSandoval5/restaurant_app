import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/presentation/providers/product_provider.dart';
import 'package:restaurant_app/presentation/providers/category_provider.dart';
import 'package:restaurant_app/presentation/widgets/custom_text_field.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:restaurant_app/data/models/product_model.dart';
import 'package:restaurant_app/data/models/category_model.dart';

class AdminProductFormPage extends StatefulWidget {
  final ProductModel? product;

  const AdminProductFormPage({super.key, this.product});

  @override
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _preparationTimeController = TextEditingController();
  final _discountController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = [];
  String? _selectedCategoryId;
  bool _isAvailable = true;
  bool _isFeatured = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _preparationTimeController.text = widget.product!.preparationTime ?? '';
      _discountController.text = widget.product!.discount?.toString() ?? '';
      _selectedCategoryId = widget.product!.categoryId;
      _isAvailable = widget.product!.isAvailable;
      _isFeatured = widget.product!.isFeatured;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _preparationTimeController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona una categoría'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final productProvider = context.read<ProductProvider>();
    bool success = false;

    if (widget.product == null) {
      success = await productProvider.createProduct(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId!,
        imageFiles: _selectedImages.isEmpty ? null : _selectedImages,
        stock: int.tryParse(_stockController.text) ?? 0,
        isAvailable: _isAvailable,
        isFeatured: _isFeatured,
        preparationTime: _preparationTimeController.text.trim().isEmpty
            ? null
            : _preparationTimeController.text.trim(),
        discount: _discountController.text.trim().isEmpty
            ? null
            : double.tryParse(_discountController.text),
      );
    } else {
      final updatedProduct = widget.product!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        categoryId: _selectedCategoryId,
        stock: int.tryParse(_stockController.text) ?? 0,
        isAvailable: _isAvailable,
        isFeatured: _isFeatured,
        preparationTime: _preparationTimeController.text.trim().isEmpty
            ? null
            : _preparationTimeController.text.trim(),
        discount: _discountController.text.trim().isEmpty
            ? null
            : double.tryParse(_discountController.text),
      );
      success = await productProvider.updateProduct(
        product: updatedProduct,
        newImageFiles: _selectedImages.isEmpty ? null : _selectedImages,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null
                ? 'Producto creado exitosamente'
                : 'Producto actualizado exitosamente',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } else if (productProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productProvider.errorMessage!),
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
          widget.product == null ? 'Nuevo Producto' : 'Editar Producto',
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
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _selectedImages.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImages[index],
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Seleccionar imágenes',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _nameController,
                  label: 'Nombre',
                  hint: 'Ej: Pizza Margherita',
                  validator: (v) => Validators.required(v, 'El nombre'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Descripción',
                  hint: 'Describe el producto',
                  maxLines: 3,
                  validator: (v) => Validators.required(v, 'La descripción'),
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<CategoryModel>>(
                  stream: context.read<CategoryProvider>().categoriesStream,
                  builder: (context, snapshot) {
                    final categories = snapshot.data ?? [];
                    return DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (v) =>
                          v == null ? 'Selecciona una categoría' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _priceController,
                        label: 'Precio',
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                        validator: Validators.positiveNumber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: _stockController,
                        label: 'Stock',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        validator: Validators.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _preparationTimeController,
                  label: 'Tiempo de preparación (opcional)',
                  hint: 'Ej: 15-20 min',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _discountController,
                  label: 'Descuento % (opcional)',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Disponible'),
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                ),
                SwitchListTile(
                  title: const Text('Destacado'),
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
                const SizedBox(height: 24),
                Consumer<ProductProvider>(
                  builder: (context, provider, _) {
                    return CustomButton(
                      text: widget.product == null ? 'Crear' : 'Actualizar',
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
