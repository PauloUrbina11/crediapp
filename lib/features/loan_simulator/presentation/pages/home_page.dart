import 'package:flutter/material.dart';

import '../../../credit_history/presentation/pages/credit_history_page.dart';
import '../widgets/simulator_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SimulatorForm(),
          CreditHistoryPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 30), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet, size: 30), label: 'Historial créditos'),
        ],
      ),
    );
  }
}
