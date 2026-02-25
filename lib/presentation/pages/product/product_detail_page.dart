import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/presentation/providers/favorite_provider.dart';
import 'package:restaurant_app/presentation/providers/cart_provider.dart';
import 'package:restaurant_app/data/models/product_model.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Slider AppBar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.product.imageUrls.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                          itemCount: widget.product.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.product.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.surfaceVariant,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                        if (widget.product.imageUrls.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.product.imageUrls.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? AppColors.primary
                                        : AppColors.textWhite.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.fastfood,
                        size: 80,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            actions: [
              StreamBuilder<List<String>>(
                stream: context
                    .read<FavoriteProvider>()
                    .favoriteProductIdsStream,
                builder: (context, snapshot) {
                  final favoriteIds = snapshot.data ?? [];
                  final isFavorite = favoriteIds.contains(widget.product.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? AppColors.favoriteActive
                          : AppColors.textWhite,
                    ),
                    onPressed: () {
                      context.read<FavoriteProvider>().toggleFavorite(
                        widget.product.id,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Price
                  FadeInUp(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.product.hasDiscount) ...[
                              Text(
                                currencyFormat.format(widget.product.price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            Text(
                              currencyFormat.format(widget.product.finalPrice),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Badges
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (widget.product.hasDiscount)
                          _buildBadge(
                            '-${widget.product.discount!.toStringAsFixed(0)}%',
                            AppColors.error,
                          ),
                        if (widget.product.isFeatured)
                          _buildBadge('Destacado', AppColors.accent),
                        if (widget.product.preparationTime != null)
                          _buildBadge(
                            '⏱ ${widget.product.preparationTime}',
                            AppColors.info,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descripción',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  // Ingredients
                  if (widget.product.ingredients != null &&
                      widget.product.ingredients!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredientes',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.product.ingredients!
                                .map(
                                  (ingredient) => Chip(
                                    label: Text(ingredient),
                                    backgroundColor: AppColors.surfaceVariant,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Nutritional Info
                  if (widget.product.nutritionalInfo != null &&
                      widget.product.nutritionalInfo!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información Nutricional',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: widget.product.nutritionalInfo!.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                          Text(
                                            '${entry.value}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: widget.product.isAvailable
                ? () async {
                    await context.read<CartProvider>().addItem(widget.product);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${widget.product.name} agregado al carrito',
                        ),
                        backgroundColor: AppColors.success,
                        action: SnackBarAction(
                          label: 'Ver carrito',
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              widget.product.isAvailable
                  ? 'Agregar al Carrito'
                  : 'No Disponible',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
