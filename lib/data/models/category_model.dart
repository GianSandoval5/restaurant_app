class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.order = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      order: map['order'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
