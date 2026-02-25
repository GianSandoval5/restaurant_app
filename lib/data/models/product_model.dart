class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> imageUrls;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int stock;
  final String? preparationTime; // e.g., "15-20 min"
  final List<String>? ingredients;
  final Map<String, dynamic>? nutritionalInfo; // calories, protein, etc.
  final double? discount; // percentage

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrls,
    this.isAvailable = true,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.stock = 0,
    this.preparationTime,
    this.ingredients,
    this.nutritionalInfo,
    this.discount,
  });

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price - (price * discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      categoryId: map['categoryId'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      isAvailable: map['isAvailable'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      stock: map['stock'] ?? 0,
      preparationTime: map['preparationTime'],
      ingredients: map['ingredients'] != null
          ? List<String>.from(map['ingredients'])
          : null,
      nutritionalInfo: map['nutritionalInfo'],
      discount: map['discount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'stock': stock,
      'preparationTime': preparationTime,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo,
      'discount': discount,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    List<String>? imageUrls,
    bool? isAvailable,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? stock,
    String? preparationTime,
    List<String>? ingredients,
    Map<String, dynamic>? nutritionalInfo,
    double? discount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stock: stock ?? this.stock,
      preparationTime: preparationTime ?? this.preparationTime,
      ingredients: ingredients ?? this.ingredients,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      discount: discount ?? this.discount,
    );
  }
}
