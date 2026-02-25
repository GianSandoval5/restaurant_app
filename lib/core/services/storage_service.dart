import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _userBoxName = 'userBox';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';
  static const String _isAdminKey = 'isAdmin';

  // Inicializar Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_userBoxName);
  }

  // Guardar datos del usuario
  static Future<void> saveUser({
    required String userId,
    required String email,
    required String name,
    bool isAdmin = false,
  }) async {
    final box = Hive.box(_userBoxName);
    await box.put(_userIdKey, userId);
    await box.put(_userEmailKey, email);
    await box.put(_userNameKey, name);
    await box.put(_isAdminKey, isAdmin);
  }

  // Obtener ID del usuario
  static String? getUserId() {
    final box = Hive.box(_userBoxName);
    return box.get(_userIdKey);
  }

  // Obtener email del usuario
  static String? getUserEmail() {
    final box = Hive.box(_userBoxName);
    return box.get(_userEmailKey);
  }

  // Obtener nombre del usuario
  static String? getUserName() {
    final box = Hive.box(_userBoxName);
    return box.get(_userNameKey);
  }

  // Verificar si es admin
  static bool isAdmin() {
    final box = Hive.box(_userBoxName);
    return box.get(_isAdminKey, defaultValue: false);
  }

  // Limpiar datos del usuario (logout)
  static Future<void> clearUser() async {
    final box = Hive.box(_userBoxName);
    await box.clear();
  }

  // Verificar si hay usuario guardado
  static bool hasUser() {
    final box = Hive.box(_userBoxName);
    return box.get(_userIdKey) != null;
  }
}
