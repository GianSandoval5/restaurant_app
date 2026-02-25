import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/presentation/providers/favorite_provider.dart';
import 'package:restaurant_app/presentation/widgets/product_card.dart';
import 'package:restaurant_app/presentation/widgets/common_widgets.dart';
import 'package:restaurant_app/data/models/product_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: SafeArea(
        child: StreamBuilder<List<ProductModel>>(
          stream: context.read<FavoriteProvider>().favoriteProductsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(message: 'Cargando favoritos...');
            }
            if (snapshot.hasError) {
              return ErrorWidgets(message: 'Error: ${snapshot.error}');
            }
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const EmptyWidget(
                message:
                    'No tienes productos favoritos.\n¡Agrega algunos desde el inicio!',
                icon: Icons.favorite_border,
              );
            }
            return FadeIn(
              child: GridView.builder(
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
                  return ProductCard(
                    product: product,
                    isFavorite: true,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
