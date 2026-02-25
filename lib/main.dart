import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/core/theme/app_theme.dart';
import 'package:restaurant_app/core/services/storage_service.dart';
import 'package:restaurant_app/firebase_options.dart';
import 'package:restaurant_app/presentation/providers/auth_provider.dart';
import 'package:restaurant_app/presentation/providers/category_provider.dart';
import 'package:restaurant_app/presentation/providers/product_provider.dart';
import 'package:restaurant_app/presentation/providers/favorite_provider.dart';
import 'package:restaurant_app/presentation/providers/cart_provider.dart';
import 'package:restaurant_app/presentation/pages/splash/splash_page.dart';
import 'package:restaurant_app/presentation/pages/auth/login_page.dart';
import 'package:restaurant_app/presentation/pages/auth/register_page.dart';
import 'package:restaurant_app/presentation/pages/main/main_page.dart';
import 'package:restaurant_app/presentation/pages/product/product_detail_page.dart';
import 'package:restaurant_app/presentation/pages/product/category_products_page.dart';
import 'package:restaurant_app/presentation/pages/admin/admin_panel_page.dart';
import 'package:restaurant_app/presentation/pages/admin/category/admin_categories_page.dart';
import 'package:restaurant_app/presentation/pages/admin/product/admin_products_page.dart';
import 'package:restaurant_app/data/models/product_model.dart';
import 'package:restaurant_app/data/models/category_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // App Check: solo activar en modo producción (release)
  // En desarrollo (debug) está desactivado para evitar problemas
  if (kReleaseMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.deviceCheck,
    );
    debugPrint('✅ App Check activado en modo producción');
  } else {
    debugPrint('ℹ️ App Check desactivado en modo desarrollo');
    debugPrint('   Para activarlo, registra el SHA-256 en Firebase Console');
    debugPrint('   y configura un debug token en App Check');
  }

  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initUserListener(),
        ),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.splash:
              return MaterialPageRoute(builder: (_) => const SplashPage());
            case AppRoutes.login:
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case AppRoutes.register:
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case AppRoutes.main:
              return MaterialPageRoute(builder: (_) => const MainPage());
            case AppRoutes.productDetail:
              final product = settings.arguments as ProductModel;
              return MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              );
            case AppRoutes.categoryProducts:
              final category = settings.arguments as CategoryModel;
              return MaterialPageRoute(
                builder: (_) => CategoryProductsPage(category: category),
              );
            case AppRoutes.adminPanel:
              return MaterialPageRoute(builder: (_) => const AdminPanelPage());
            case AppRoutes.adminCategories:
              return MaterialPageRoute(
                builder: (_) => const AdminCategoriesPage(),
              );
            case AppRoutes.adminProducts:
              return MaterialPageRoute(
                builder: (_) => const AdminProductsPage(),
              );
            default:
              return MaterialPageRoute(builder: (_) => const SplashPage());
          }
        },
      ),
    );
  }
}
