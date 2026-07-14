import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/credit_type.dart';
import '../pages/amortization_table_page.dart';
import '../providers/loan_simulator_provider.dart';

class SimulatorForm extends StatefulWidget {
  const SimulatorForm({super.key});

  @override
  State<SimulatorForm> createState() => _SimulatorFormState();
}

class _SimulatorFormState extends State<SimulatorForm> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _maxLoanController = TextEditingController();

  @override
  void dispose() {
    _salaryController.dispose();
    _maxLoanController.dispose();
    super.dispose();
  }

  void _simulate() {
    final provider = context.read<LoanSimulatorProvider>();
    if (!_formKey.currentState!.validate() || !provider.canSimulate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AmortizationTablePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoanSimulatorProvider>();
    final userName = context.watch<AuthProvider>().currentUser?.fullName ?? 'Usuario';

    final formattedMax =
        provider.maxLoanAmount > 0 ? CurrencyFormatter.format(provider.maxLoanAmount) : '';
    if (_maxLoanController.text != formattedMax) {
      _maxLoanController.text = formattedMax;
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hola $userName 👋',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.notifications_active),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Simulador de crédito',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.info, color: Theme.of(context).colorScheme.primary, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Ingresa los datos para tu crédito según lo que necesites.'),
              const SizedBox(height: 16),
              AppDropdownField<CreditType>(
                label: '¿Qué tipo de crédito deseas realizar?',
                value: provider.selectedCreditType,
                items: CreditType.values,
                itemLabel: (type) => type.label,
                hint: 'Selecciona el tipo de crédito',
                onChanged: provider.selectCreditType,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: '¿Cuál es tu salario base?',
                hint: '\$ 1000000',
                controller: _salaryController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Ingresa tu salario' : null,
                onChanged: provider.updateSalary,
              ),
              const SizedBox(height: 4),
              const Text(
                'Digita tu salario para calcular el préstamo que necesitas',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Valor máximo a prestar',
                hint: '\$ 0',
                controller: _maxLoanController,
                enabled: false,
              ),
              const SizedBox(height: 16),
              AppDropdownField<int>(
                label: '¿A cuántos meses?',
                value: provider.selectedMonths,
                items: List.generate(73, (index) => index + 12),
                itemLabel: (months) => '$months',
                hint: 'Selecciona',
                onChanged: (value) {
                  if (value != null) provider.selectMonths(value);
                },
              ),
              const SizedBox(height: 4),
              const Text(
                'Elige un plazo desde 12 hasta 84 meses',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              PrimaryButton(label: 'Simular', onPressed: _simulate),
            ],
          ),
        ),
      ),
    );
  }
}
