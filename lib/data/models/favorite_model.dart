class FavoriteModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map, String id) {
    return FavoriteModel(
      id: id,
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
