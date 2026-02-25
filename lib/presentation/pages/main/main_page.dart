import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/presentation/pages/main/home_page.dart';
import 'package:restaurant_app/presentation/pages/main/favorites_page.dart';
import 'package:restaurant_app/presentation/pages/main/cart_page.dart';
import 'package:restaurant_app/presentation/pages/main/profile_page.dart';
import 'package:restaurant_app/presentation/providers/cart_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FavoritesPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, _) => BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: cart.itemCount > 0 ? Text('${cart.itemCount}') : null,
                isLabelVisible: cart.itemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                label: cart.itemCount > 0 ? Text('${cart.itemCount}') : null,
                isLabelVisible: cart.itemCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Carrito',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
