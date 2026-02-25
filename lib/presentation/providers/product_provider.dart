import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/datasources/product_datasource.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductDataSource _productDataSource = ProductDataSource();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Stream de productos disponibles
  Stream<List<ProductModel>> get productsStream {
    return _productDataSource.getProductsStream();
  }

  // Stream de todos los productos (para admin)
  Stream<List<ProductModel>> get allProductsStream {
    return _productDataSource.getAllProductsStream();
  }

  // Stream de productos por categoría
  Stream<List<ProductModel>> getProductsByCategoryStream(String categoryId) {
    return _productDataSource.getProductsByCategoryStream(categoryId);
  }

  // Stream de productos destacados
  Stream<List<ProductModel>> get featuredProductsStream {
    return _productDataSource.getFeaturedProductsStream();
  }

  // Stream de producto por ID
  Stream<ProductModel?> getProductByIdStream(String id) {
    return _productDataSource.getProductByIdStream(id);
  }

  // Crear producto
  Future<bool> createProduct({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    List<File>? imageFiles,
    int stock = 0,
    bool isAvailable = true,
    bool isFeatured = false,
    String? preparationTime,
    List<String>? ingredients,
    Map<String, dynamic>? nutritionalInfo,
    double? discount,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Crear producto temporal
      String tempId = DateTime.now().millisecondsSinceEpoch.toString();
      List<String> imageUrls = [];

      // Subir imágenes si existen
      if (imageFiles != null && imageFiles.isNotEmpty) {
        imageUrls = await _productDataSource.uploadImages(imageFiles, tempId);
      }

      // Crear producto
      final product = ProductModel(
        id: '',
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageUrls: imageUrls,
        isAvailable: isAvailable,
        isFeatured: isFeatured,
        stock: stock,
        preparationTime: preparationTime,
        ingredients: ingredients,
        nutritionalInfo: nutritionalInfo,
        discount: discount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _productDataSource.createProduct(product);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al crear producto: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Actualizar producto
  Future<bool> updateProduct({
    required ProductModel product,
    List<File>? newImageFiles,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      List<String> imageUrls = List.from(product.imageUrls);

      // Si hay nuevas imágenes
      if (newImageFiles != null && newImageFiles.isNotEmpty) {
        // Subir nuevas imágenes
        final newUrls = await _productDataSource.uploadImages(
          newImageFiles,
          product.id,
        );
        imageUrls.addAll(newUrls);
      }

      // Actualizar producto
      final updatedProduct = product.copyWith(
        imageUrls: imageUrls,
        updatedAt: DateTime.now(),
      );

      await _productDataSource.updateProduct(updatedProduct);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar producto: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Eliminar imagen del producto
  Future<bool> deleteProductImage({
    required ProductModel product,
    required String imageUrl,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Eliminar imagen del storage
      await _productDataSource.deleteImage(imageUrl);

      // Actualizar lista de imágenes
      final imageUrls = List<String>.from(product.imageUrls);
      imageUrls.remove(imageUrl);

      final updatedProduct = product.copyWith(
        imageUrls: imageUrls,
        updatedAt: DateTime.now(),
      );

      await _productDataSource.updateProduct(updatedProduct);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al eliminar imagen: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Eliminar producto
  Future<bool> deleteProduct(ProductModel product) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Eliminar imágenes si existen
      for (String imageUrl in product.imageUrls) {
        try {
          await _productDataSource.deleteImage(imageUrl);
        } catch (e) {
          // Ignorar error si la imagen no existe
        }
      }

      // Eliminar producto
      await _productDataSource.deleteProduct(product.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al eliminar producto: ${e.toString()}';
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
