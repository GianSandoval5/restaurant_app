import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_app/data/models/cart_item_model.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  static const String _boxName = 'cartBox';

  List<CartItemModel> get items => _items;
  int get itemCount => _items.length;
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  // Inicializar y cargar carrito desde Hive
  Future<void> loadCart() async {
    try {
      final box = await Hive.openBox(_boxName);
      final cartData = box.get('items', defaultValue: []) as List;

      _items.clear();
      for (var itemMap in cartData) {
        if (itemMap is Map<String, dynamic>) {
          _items.add(CartItemModel.fromMap(itemMap));
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  // Guardar carrito en Hive
  Future<void> _saveCart() async {
    try {
      final box = await Hive.openBox(_boxName);
      final cartData = _items.map((item) => item.toMap()).toList();
      await box.put('items', cartData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  // Agregar producto al carrito
  Future<void> addItem(ProductModel product, {int quantity = 1}) async {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Si el producto ya existe, aumentar cantidad
      _items[existingIndex].quantity += quantity;
    } else {
      // Si es nuevo, agregarlo
      _items.add(CartItemModel(product: product, quantity: quantity));
    }

    await _saveCart();
    notifyListeners();
  }

  // Eliminar producto del carrito
  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    await _saveCart();
    notifyListeners();
  }

  // Actualizar cantidad de un producto
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      await _saveCart();
      notifyListeners();
    }
  }

  // Incrementar cantidad
  Future<void> incrementQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      await _saveCart();
      notifyListeners();
    }
  }

  // Decrementar cantidad
  Future<void> decrementQuantity(String productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        await _saveCart();
        notifyListeners();
      } else {
        await removeItem(productId);
      }
    }
  }

  // Limpiar carrito
  Future<void> clearCart() async {
    _items.clear();
    await _saveCart();
    notifyListeners();
  }

  // Verificar si un producto está en el carrito
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Obtener cantidad de un producto en el carrito
  int getProductQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItemModel(
        product: ProductModel(
          id: '',
          name: '',
          description: '',
          price: 0,
          imageUrls: [],
          categoryId: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        quantity: 0,
      ),
    );
    return item.quantity;
  }
}
