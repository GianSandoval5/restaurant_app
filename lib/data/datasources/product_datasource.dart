import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class ProductDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream de todos los productos
  Stream<List<ProductModel>> getProductsStream() {
    return _firestore
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Stream de todos los productos (incluyendo no disponibles, para admin)
  Stream<List<ProductModel>> getAllProductsStream() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Stream de productos por categoría
  Stream<List<ProductModel>> getProductsByCategoryStream(String categoryId) {
    return _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Stream de productos destacados
  Stream<List<ProductModel>> getFeaturedProductsStream() {
    return _firestore
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Stream de producto por ID
  Stream<ProductModel?> getProductByIdStream(String id) {
    return _firestore.collection('products').doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return ProductModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  // Crear producto
  Future<String> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore
          .collection('products')
          .add(product.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar producto
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar producto
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Subir imágenes
  Future<List<String>> uploadImages(
    List<File> imageFiles,
    String productId,
  ) async {
    try {
      List<String> imageUrls = [];
      for (int i = 0; i < imageFiles.length; i++) {
        final ref = _storage.ref().child(
          'products/$productId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
        );
        final uploadTask = await ref.putFile(imageFiles[i]);
        final url = await uploadTask.ref.getDownloadURL();
        imageUrls.add(url);
      }
      return imageUrls;
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar imagen
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
