import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/routes.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_password_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'No se pudo iniciar sesión')),
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
              Text(
                'Inicia sesión o continúa, solo te tomará unos minutos',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Email o usuario',
                      hint: 'user@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.person,
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
                label: 'Iniciar sesión',
                isLoading: authProvider.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) => setState(() => _rememberMe = value ?? false),
                      ),
                      const Text('Recordarme'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Olvidé mi contraseña'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('O')),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Ingresa con Google',
                icon: Image.asset('assets/photos/google_logo.png', height: 22),
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Ingresa con Apple',
                icon: Image.asset('assets/photos/apple_logo.png', height: 22),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  text: '¿No tienes una cuenta? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Regístrate aquí',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, AppRoutes.register),
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
}
