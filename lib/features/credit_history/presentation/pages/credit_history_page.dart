import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../providers/credit_history_provider.dart';

class CreditHistoryPage extends StatelessWidget {
  const CreditHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<CreditHistoryProvider>().items;

    return SafeArea(
      child: items.isEmpty
          ? const Center(child: Text('Aún no tienes cotizaciones guardadas.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.creditTypeLabel),
                    subtitle: Text('${item.numberOfMonths} meses'),
                    trailing: Text(CurrencyFormatter.format(item.loanAmount)),
                  ),
                );
              },
            ),
    );
  }
}
