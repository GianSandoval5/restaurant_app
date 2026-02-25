import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/core/routes/app_routes.dart';
import 'package:restaurant_app/core/services/storage_service.dart';
import 'package:restaurant_app/presentation/providers/auth_provider.dart';
import 'package:restaurant_app/presentation/widgets/custom_text_field.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
    );

    if (!mounted) return;

    if (success && authProvider.currentUser != null) {
      // Guardar datos del usuario en Hive
      await StorageService.saveUser(
        userId: authProvider.currentUser!.uid,
        email: authProvider.currentUser!.email,
        name: authProvider.currentUser!.name,
        isAdmin: authProvider.currentUser!.isAdmin,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Title
                FadeInDown(
                  child: Text(
                    'Crear Cuenta',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Completa los datos para registrarte',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                // Name Field
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: CustomTextField(
                    controller: _nameController,
                    label: 'Nombre completo',
                    hint: 'Juan Pérez',
                    prefixIcon: Icons.person_outline,
                    validator: (value) =>
                        Validators.required(value, 'El nombre'),
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: CustomTextField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    hint: 'usuario@ejemplo.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                FadeInLeft(
                  delay: const Duration(milliseconds: 400),
                  child: CustomTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password Field
                FadeInLeft(
                  delay: const Duration(milliseconds: 500),
                  child: CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar contraseña',
                    hint: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Register Button
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return CustomButton(
                        text: 'Registrarse',
                        onPressed: _register,
                        isLoading: authProvider.isLoading,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Login Link
                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes cuenta? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Inicia Sesión',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
