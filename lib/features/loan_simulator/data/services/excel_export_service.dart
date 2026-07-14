import 'dart:io';

import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/amortization_row.dart';

class ExcelExportResult {
  const ExcelExportResult.success(this.filePath) : errorMessage = null;
  const ExcelExportResult.failure(this.errorMessage) : filePath = null;

  final String? filePath;
  final String? errorMessage;

  bool get isSuccess => filePath != null;
}

class ExcelExportService {
  Future<ExcelExportResult> exportAmortizationSchedule(List<AmortizationRow> rows) async {
    final excelFile = excel.Excel.createExcel();
    final sheet = excelFile['Sheet1'];

    sheet.appendRow([
      excel.TextCellValue('Cuota'),
      excel.TextCellValue('Saldo Inicial'),
      excel.TextCellValue('Interés'),
      excel.TextCellValue('Abono a Capital'),
      excel.TextCellValue('Cuota Total'),
      excel.TextCellValue('Saldo Final'),
    ]);

    for (final row in rows) {
      sheet.appendRow([
        excel.IntCellValue(row.installmentNumber),
        excel.TextCellValue(row.openingBalance.toStringAsFixed(2)),
        excel.TextCellValue(row.interest.toStringAsFixed(2)),
        excel.TextCellValue(row.principalPayment.toStringAsFixed(2)),
        excel.TextCellValue(row.totalPayment.toStringAsFixed(2)),
        excel.TextCellValue(row.closingBalance.toStringAsFixed(2)),
      ]);
    }

    final bytes = excelFile.encode();
    if (bytes == null) {
      return const ExcelExportResult.failure('Error al codificar el archivo Excel.');
    }

    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      return const ExcelExportResult.failure('Error al obtener el directorio de almacenamiento.');
    }

    final filePath = '${directory.path}/amortization_table.xlsx';
    await File(filePath).writeAsBytes(bytes);
    return ExcelExportResult.success(filePath);
  }
}
