import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../credit_history/presentation/providers/credit_history_provider.dart';
import '../../data/services/excel_export_service.dart';
import '../../domain/entities/amortization_row.dart';
import '../providers/loan_simulator_provider.dart';
import 'success_page.dart';

class AmortizationTablePage extends StatefulWidget {
  const AmortizationTablePage({super.key});

  @override
  State<AmortizationTablePage> createState() => _AmortizationTablePageState();
}

class _AmortizationTablePageState extends State<AmortizationTablePage> {
  final _excelExportService = ExcelExportService();
  late final List<AmortizationRow> _rows;

  @override
  void initState() {
    super.initState();
    _rows = context.read<LoanSimulatorProvider>().buildAmortizationSchedule();
  }

  Future<void> _downloadExcel() async {
    final result = await _excelExportService.exportAmortizationSchedule(_rows);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? 'Tabla descargada con éxito: ${result.filePath}'
              : result.errorMessage!,
        ),
      ),
    );
  }

  void _saveQuote() {
    final loanProvider = context.read<LoanSimulatorProvider>();
    final creditType = loanProvider.selectedCreditType!;
    context.read<CreditHistoryProvider>().save(
          creditTypeLabel: creditType.label,
          loanAmount: loanProvider.maxLoanAmount,
          numberOfMonths: loanProvider.selectedMonths,
        );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabla de Amortización')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('Cuota')),
                  DataColumn(label: Text('Saldo Inicial')),
                  DataColumn(label: Text('Interés')),
                  DataColumn(label: Text('Abono a Capital')),
                  DataColumn(label: Text('Cuota Total')),
                  DataColumn(label: Text('Saldo Final')),
                ],
                rows: _rows
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(Text('${row.installmentNumber}')),
                          DataCell(Text(CurrencyFormatter.format(row.openingBalance))),
                          DataCell(Text(CurrencyFormatter.format(row.interest))),
                          DataCell(Text(CurrencyFormatter.format(row.principalPayment))),
                          DataCell(Text(CurrencyFormatter.format(row.totalPayment))),
                          DataCell(Text(CurrencyFormatter.format(row.closingBalance))),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PrimaryButton(label: 'Descargar tabla', onPressed: _downloadExcel),
                  const SizedBox(height: 8),
                  SecondaryButton(label: 'Guardar cotización', onPressed: _saveQuote),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
