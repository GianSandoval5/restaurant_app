class UserModel {
  final String uid;
  final String email;
  final String name;
  final bool isAdmin;
  final DateTime createdAt;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.isAdmin = false,
    required this.createdAt,
    this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'isAdmin': isAdmin,
      'createdAt': createdAt.toIso8601String(),
      'photoUrl': photoUrl,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    bool? isAdmin,
    DateTime? createdAt,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
