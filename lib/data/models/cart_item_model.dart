import 'package:restaurant_app/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name,
      'productPrice': product.price,
      'productImage': product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel(
        id: map['productId'] ?? '',
        name: map['productName'] ?? '',
        description: '',
        price: (map['productPrice'] ?? 0.0).toDouble(),
        imageUrls: [map['productImage'] ?? ''],
        categoryId: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAvailable: true,
        isFeatured: false,
      ),
      quantity: map['quantity'] ?? 1,
    );
  }

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
