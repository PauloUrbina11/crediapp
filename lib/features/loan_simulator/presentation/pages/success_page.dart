import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/widgets/primary_button.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado de la Simulación')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 72),
              const SizedBox(height: 16),
              const Text(
                'Tu cotización se guardó correctamente. Puedes consultarla en tu historial de créditos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Volver al inicio',
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
