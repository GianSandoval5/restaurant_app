import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administración')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              FadeInDown(
                child: Text(
                  'Gestión del Restaurante',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    FadeInLeft(
                      delay: const Duration(milliseconds: 100),
                      child: _buildAdminCard(
                        context,
                        title: 'Categorías',
                        icon: Icons.category,
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.adminCategories,
                          );
                        },
                      ),
                    ),
                    FadeInRight(
                      delay: const Duration(milliseconds: 200),
                      child: _buildAdminCard(
                        context,
                        title: 'Productos',
                        icon: Icons.fastfood,
                        color: AppColors.accent,
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.adminProducts);
                        },
                      ),
                    ),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: _buildAdminCard(
                        context,
                        title: 'Pedidos',
                        icon: Icons.shopping_bag,
                        color: AppColors.success,
                        onTap: () {
                          // TODO: Navigate to orders management
                        },
                      ),
                    ),
                    FadeInRight(
                      delay: const Duration(milliseconds: 400),
                      child: _buildAdminCard(
                        context,
                        title: 'Estadísticas',
                        icon: Icons.analytics,
                        color: AppColors.info,
                        onTap: () {
                          // TODO: Navigate to statistics
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
