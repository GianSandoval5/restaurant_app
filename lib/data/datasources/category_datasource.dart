import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_app/data/models/category_model.dart';

class CategoryDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Stream de todas las categorías
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Stream de todas las categorías (incluyendo inactivas, para admin)
  Stream<List<CategoryModel>> getAllCategoriesStream() {
    return _firestore.collection('categories').orderBy('order').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  // Obtener categoría por ID stream
  Stream<CategoryModel?> getCategoryByIdStream(String id) {
    return _firestore.collection('categories').doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return CategoryModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  // Crear categoría
  Future<String> createCategory(CategoryModel category) async {
    try {
      final docRef = await _firestore
          .collection('categories')
          .add(category.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar categoría
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar categoría
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Subir imagen
  Future<String> uploadImage(File imageFile, String categoryId) async {
    try {
      final ref = _storage.ref().child(
        'categories/$categoryId/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
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
