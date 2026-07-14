import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/widgets/primary_button.dart';

class UserConfirmationPage extends StatelessWidget {
  const UserConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: const FractionalOffset(0.5, 0.2),
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Image.asset('assets/photos/verified_logo.png'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Registro Exitoso',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Hemos guardado tus credenciales de forma exitosa. Presiona continuar para seguir adelante',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Continuar',
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
