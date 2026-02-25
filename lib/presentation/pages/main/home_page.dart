import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/presentation/providers/auth_provider.dart';
import 'package:restaurant_app/presentation/providers/category_provider.dart';
import 'package:restaurant_app/presentation/providers/product_provider.dart';
import 'package:restaurant_app/presentation/providers/favorite_provider.dart';
import 'package:restaurant_app/presentation/widgets/category_card.dart';
import 'package:restaurant_app/presentation/widgets/product_card.dart';
import 'package:restaurant_app/presentation/widgets/common_widgets.dart';
import 'package:restaurant_app/data/models/category_model.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          if (authProvider.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.adminPanel);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      child: Text(
                        '¡Hola, ${authProvider.currentUser?.name ?? "Usuario"}!',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInDown(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        '¿Qué te gustaría comer hoy?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Categorías',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: StreamBuilder<List<CategoryModel>>(
                  stream: context.read<CategoryProvider>().categoriesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final categories = snapshot.data ?? [];
                    if (categories.isEmpty) {
                      return const Center(
                        child: Text('No hay categorías disponibles'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.categoryProducts,
                              arguments: category,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // Featured Products Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Productos Destacados',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            // Products Grid
            StreamBuilder<List<ProductModel>>(
              stream: context.read<ProductProvider>().featuredProductsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: LoadingWidget(message: 'Cargando productos...'),
                  );
                }
                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: ErrorWidgets(message: 'Error: ${snapshot.error}'),
                  );
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const SliverFillRemaining(
                    child: EmptyWidget(
                      message: 'No hay productos destacados',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: StreamBuilder<List<String>>(
                    stream: context
                        .read<FavoriteProvider>()
                        .favoriteProductIdsStream,
                    builder: (context, favSnapshot) {
                      final favoriteIds = favSnapshot.data ?? [];
                      return SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = products[index];
                          final isFavorite = favoriteIds.contains(product.id);
                          return ProductCard(
                            product: product,
                            isFavorite: isFavorite,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetail,
                                arguments: product,
                              );
                            },
                            onFavoriteToggle: () {
                              context.read<FavoriteProvider>().toggleFavorite(
                                product.id,
                              );
                            },
                          );
                        }, childCount: products.length),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
