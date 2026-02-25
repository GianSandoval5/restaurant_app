class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes
  static const String main = '/main';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Product Routes
  static const String productDetail = '/product-detail';
  static const String categoryProducts = '/category-products';

  // Admin Routes
  static const String adminPanel = '/admin-panel';
  static const String adminCategories = '/admin-categories';
  static const String adminProducts = '/admin-products';
  static const String adminAddCategory = '/admin-add-category';
  static const String adminEditCategory = '/admin-edit-category';
  static const String adminAddProduct = '/admin-add-product';
  static const String adminEditProduct = '/admin-edit-product';
}
