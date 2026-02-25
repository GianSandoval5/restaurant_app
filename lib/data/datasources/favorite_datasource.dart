import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/data/models/favorite_model.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class FavoriteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream de favoritos del usuario
  Stream<List<String>> getFavoriteProductIdsStream(String userId) {
    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final favorite = FavoriteModel.fromMap(doc.data(), doc.id);
            return favorite.productId;
          }).toList();
        });
  }

  // Stream de productos favoritos completos
  Stream<List<ProductModel>> getFavoriteProductsStream(String userId) {
    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ProductModel> products = [];
          for (var doc in snapshot.docs) {
            final favorite = FavoriteModel.fromMap(doc.data(), doc.id);
            final productDoc = await _firestore
                .collection('products')
                .doc(favorite.productId)
                .get();
            if (productDoc.exists) {
              products.add(
                ProductModel.fromMap(productDoc.data()!, productDoc.id),
              );
            }
          }
          return products;
        });
  }

  // Verificar si un producto es favorito
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  // Agregar a favoritos
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      final favorite = FavoriteModel(
        id: '',
        userId: userId,
        productId: productId,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('favorites').add(favorite.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar de favoritos
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      final snapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Toggle favorito
  Future<void> toggleFavorite(String userId, String productId) async {
    try {
      final isFav = await isFavorite(userId, productId);
      if (isFav) {
        await removeFromFavorites(userId, productId);
      } else {
        await addToFavorites(userId, productId);
      }
    } catch (e) {
      rethrow;
    }
  }
}
