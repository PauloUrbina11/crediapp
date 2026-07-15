import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../loan_simulator/data/services/excel_export_service.dart';
import '../../../loan_simulator/domain/entities/amortization_row.dart';
import '../../../loan_simulator/domain/entities/credit_type.dart';
import '../../../loan_simulator/domain/usecases/calculate_amortization_schedule.dart';
import '../../domain/entities/saved_credit.dart';

class SavedCreditDetailPage extends StatefulWidget {
  const SavedCreditDetailPage({super.key, required this.savedCredit});

  final SavedCredit savedCredit;

  @override
  State<SavedCreditDetailPage> createState() => _SavedCreditDetailPageState();
}

class _SavedCreditDetailPageState extends State<SavedCreditDetailPage> {
  final _excelExportService = ExcelExportService();

  Future<void> _downloadExcel(List<AmortizationRow> rows) async {
    final result = await _excelExportService.exportAmortizationSchedule(rows);
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

  @override
  Widget build(BuildContext context) {
    final savedCredit = widget.savedCredit;
    final creditType = CreditType.values.firstWhere(
      (type) => type.label == savedCredit.creditTypeLabel,
    );
    final rows = CalculateAmortizationSchedule()(
      loanAmount: savedCredit.loanAmount,
      annualInterestRate: creditType.annualInterestRate,
      numberOfMonths: savedCredit.numberOfMonths,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la cotización')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        savedCredit.creditTypeLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('${savedCredit.numberOfMonths} meses'),
                      const SizedBox(height: 4),
                      Text('Monto: ${CurrencyFormatter.format(savedCredit.loanAmount)}'),
                      const SizedBox(height: 4),
                      Text(
                        'Guardada el ${DateFormat('dd/MM/yyyy').format(savedCredit.createdAt)}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                rows: rows
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
              child: PrimaryButton(
                label: 'Descargar tabla',
                onPressed: () => _downloadExcel(rows),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
