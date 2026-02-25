import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/presentation/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              FadeInDown(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    user?.name.isNotEmpty == true
                        ? user!.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Name
              FadeInDown(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  user?.name ?? 'Usuario',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Email
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Admin Badge
              if (authProvider.isAdmin)
                FadeInDown(
                  delay: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 18,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Administrador',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              // Options List
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _buildOptionTile(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Mis Pedidos',
                  onTap: () {
                    // TODO: Navigate to orders
                  },
                ),
              ),
              if (authProvider.isAdmin) ...[
                const SizedBox(height: 12),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  child: _buildOptionTile(
                    context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Panel de Administración',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.adminPanel);
                    },
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: _buildOptionTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
              ),
              const SizedBox(height: 12),
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: _buildOptionTile(
                  context,
                  icon: Icons.help_outline,
                  title: 'Ayuda y Soporte',
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
              ),
              const SizedBox(height: 40),
              // Logout Button
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Cerrar Sesión'),
                          content: const Text(
                            '¿Estás seguro de que quieres cerrar sesión?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Cerrar Sesión'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.login,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
