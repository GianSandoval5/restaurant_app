import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/datasources/category_datasource.dart';
import 'package:restaurant_app/data/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryDataSource _categoryDataSource = CategoryDataSource();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stream de categorías activas
  Stream<List<CategoryModel>> get categoriesStream {
    return _categoryDataSource.getCategoriesStream();
  }

  // Stream de todas las categorías (para admin)
  Stream<List<CategoryModel>> get allCategoriesStream {
    return _categoryDataSource.getAllCategoriesStream();
  }

  // Stream de categoría por ID
  Stream<CategoryModel?> getCategoryByIdStream(String id) {
    return _categoryDataSource.getCategoryByIdStream(id);
  }

  // Crear categoría
  Future<bool> createCategory({
    required String name,
    required String description,
    File? imageFile,
    int order = 0,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Crear categoría temporal
      String tempId = DateTime.now().millisecondsSinceEpoch.toString();
      String imageUrl = '';

      // Subir imagen si existe
      if (imageFile != null) {
        imageUrl = await _categoryDataSource.uploadImage(imageFile, tempId);
      }

      // Crear categoría
      final category = CategoryModel(
        id: '',
        name: name,
        description: description,
        imageUrl: imageUrl,
        order: order,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _categoryDataSource.createCategory(category);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al crear categoría: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Actualizar categoría
  Future<bool> updateCategory({
    required CategoryModel category,
    File? newImageFile,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      String imageUrl = category.imageUrl;

      // Si hay nueva imagen
      if (newImageFile != null) {
        // Eliminar imagen anterior si existe
        if (category.imageUrl.isNotEmpty) {
          try {
            await _categoryDataSource.deleteImage(category.imageUrl);
          } catch (e) {
            // Ignorar error si la imagen no existe
          }
        }
        // Subir nueva imagen
        imageUrl = await _categoryDataSource.uploadImage(
          newImageFile,
          category.id,
        );
      }

      // Actualizar categoría
      final updatedCategory = category.copyWith(
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      await _categoryDataSource.updateCategory(updatedCategory);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar categoría: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Eliminar categoría
  Future<bool> deleteCategory(CategoryModel category) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Eliminar imagen si existe
      if (category.imageUrl.isNotEmpty) {
        try {
          await _categoryDataSource.deleteImage(category.imageUrl);
        } catch (e) {
          // Ignorar error si la imagen no existe
        }
      }

      // Eliminar categoría
      await _categoryDataSource.deleteCategory(category.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al eliminar categoría: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
