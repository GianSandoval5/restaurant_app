import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/presentation/providers/category_provider.dart';
import 'package:restaurant_app/presentation/widgets/common_widgets.dart';
import 'package:restaurant_app/presentation/pages/admin/category/admin_category_form_page.dart';
import 'package:restaurant_app/data/models/category_model.dart';

class AdminCategoriesPage extends StatelessWidget {
  const AdminCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Categorías')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminCategoryFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: context.read<CategoryProvider>().allCategoriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Cargando categorías...');
          }
          if (snapshot.hasError) {
            return ErrorWidgets(message: 'Error: ${snapshot.error}');
          }
          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return const EmptyWidget(
              message: 'No hay categorías.\n¡Crea la primera!',
              icon: Icons.category,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(context, category);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: category.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: category.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.surfaceVariant,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.category),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.category),
                ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              category.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: category.isActive
                        ? AppColors.success.withOpacity(0.2)
                        : AppColors.error.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      fontSize: 11,
                      color: category.isActive
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Orden: ${category.order}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminCategoryFormPage(category: category),
                ),
              );
            } else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar Categoría'),
                  content: Text(
                    '¿Estás seguro de eliminar "${category.name}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                final success = await context
                    .read<CategoryProvider>()
                    .deleteCategory(category);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Categoría eliminada' : 'Error al eliminar',
                      ),
                      backgroundColor: success
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
