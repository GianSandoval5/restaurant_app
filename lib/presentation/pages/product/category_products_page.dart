import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/presentation/providers/product_provider.dart';
import 'package:restaurant_app/presentation/providers/favorite_provider.dart';
import 'package:restaurant_app/presentation/widgets/product_card.dart';
import 'package:restaurant_app/presentation/widgets/common_widgets.dart';
import 'package:restaurant_app/data/models/category_model.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class CategoryProductsPage extends StatelessWidget {
  final CategoryModel category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: StreamBuilder<List<ProductModel>>(
        stream: context.read<ProductProvider>().getProductsByCategoryStream(
          category.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Cargando productos...');
          }
          if (snapshot.hasError) {
            return ErrorWidgets(message: 'Error: ${snapshot.error}');
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const EmptyWidget(
              message: 'No hay productos en esta categoría',
              icon: Icons.shopping_bag_outlined,
            );
          }
          return StreamBuilder<List<String>>(
            stream: context.read<FavoriteProvider>().favoriteProductIdsStream,
            builder: (context, favSnapshot) {
              final favoriteIds = favSnapshot.data ?? [];
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
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
                },
              );
            },
          );
        },
      ),
    );
  }
}
