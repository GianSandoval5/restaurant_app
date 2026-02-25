import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/services/storage_service.dart';
import 'package:restaurant_app/data/datasources/auth_datasource.dart';
import 'package:restaurant_app/data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthDataSource _authDataSource = AuthDataSource();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Stream del estado de autenticación
  Stream<User?> get authStateChanges => _authDataSource.authStateChanges;

  // Stream de datos del usuario
  Stream<UserModel?> getUserStream(String uid) {
    return _authDataSource.getUserStream(uid);
  }

  // Inicializar listener del usuario
  void initUserListener() {
    _authDataSource.authStateChanges.listen((User? user) {
      if (user != null) {
        _authDataSource.getUserStream(user.uid).listen((UserModel? userModel) {
          _currentUser = userModel;
          notifyListeners();
        });
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Registro
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authDataSource.registerWithEmail(
        email: email,
        password: password,
        name: name,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authDataSource.loginWithEmail(email: email, password: password);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authDataSource.logout();
      await StorageService.clearUser();
      _currentUser = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al cerrar sesión: ${e.toString()}';
      notifyListeners();
    }
  }

  // Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authDataSource.resetPassword(email);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getAuthErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error inesperado: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Actualizar perfil
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      if (_currentUser == null) return false;

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authDataSource.updateUserProfile(
        uid: _currentUser!.uid,
        data: data,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar perfil: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Mensajes de error en español
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado';
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'user-not-found':
        return 'No existe una cuenta con este correo';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-credential':
        return 'Credenciales inválidas';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
