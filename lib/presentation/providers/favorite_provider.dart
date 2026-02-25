import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/services/storage_service.dart';
import 'package:restaurant_app/data/datasources/favorite_datasource.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDataSource _favoriteDataSource = FavoriteDataSource();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Obtener el userId desde Hive
  String? get _currentUserId => StorageService.getUserId();

  // Stream de IDs de productos favoritos
  Stream<List<String>> get favoriteProductIdsStream {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }
    return _favoriteDataSource.getFavoriteProductIdsStream(userId);
  }

  // Stream de productos favoritos completos
  Stream<List<ProductModel>> get favoriteProductsStream {
    final userId = _currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }
    return _favoriteDataSource.getFavoriteProductsStream(userId);
  }

  // Verificar si un producto es favorito
  Future<bool> isFavorite(String productId) async {
    final userId = _currentUserId;
    if (userId == null) return false;
    try {
      return await _favoriteDataSource.isFavorite(userId, productId);
    } catch (e) {
      return false;
    }
  }

  // Toggle favorito
  Future<bool> toggleFavorite(String productId) async {
    final userId = _currentUserId;
    if (userId == null) {
      _errorMessage = 'Debes iniciar sesión para agregar favoritos';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _favoriteDataSource.toggleFavorite(userId, productId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar favoritos: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Agregar a favoritos
  Future<bool> addToFavorites(String productId) async {
    final userId = _currentUserId;
    if (userId == null) {
      _errorMessage = 'Debes iniciar sesión para agregar favoritos';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _favoriteDataSource.addToFavorites(userId, productId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al agregar a favoritos: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Eliminar de favoritos
  Future<bool> removeFromFavorites(String productId) async {
    final userId = _currentUserId;
    if (userId == null) return false;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _favoriteDataSource.removeFromFavorites(userId, productId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al eliminar de favoritos: ${e.toString()}';
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
