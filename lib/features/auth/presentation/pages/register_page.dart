import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _documentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _documentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      fullName: _fullNameController.text,
      documentId: _documentIdController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.userConfirmation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'No se pudo completar el registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Text(
                'CrediApp',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              Text('Registrarse', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Solo te tomará unos minutos.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Nombre completo',
                      hint: 'Escribe tu nombre',
                      controller: _fullNameController,
                      prefixIcon: Icons.person,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Identificación',
                      hint: 'Escribe tu número de identificación',
                      controller: _documentIdController,
                      keyboardType: TextInputType.number,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email',
                      hint: 'user@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),
                    AppPasswordField(
                      label: 'Contraseña',
                      controller: _passwordController,
                      validator: (value) => Validators.minLength(value, 6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Continuar',
                isLoading: authProvider.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: RichText(
                  text: TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Inicia sesión',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
