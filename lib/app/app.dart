import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/data/repositories/mock_auth_repository.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/credit_history/data/repositories/in_memory_credit_history_repository.dart';
import '../features/credit_history/presentation/providers/credit_history_provider.dart';
import '../features/loan_simulator/presentation/providers/loan_simulator_provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

class CrediAppRoot extends StatelessWidget {
  const CrediAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(MockAuthRepository())),
        ChangeNotifierProvider(
          create: (_) => CreditHistoryProvider(InMemoryCreditHistoryRepository()),
        ),
        ChangeNotifierProvider(create: (_) => LoanSimulatorProvider()),
      ],
      child: MaterialApp(
        title: 'CrediApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
