import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'tablaAmortizacion.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as excel;

class DetalleCotizacionPage extends StatelessWidget {
  final Cotizacion cotizacion;

  DetalleCotizacionPage({required this.cotizacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10, left: 8),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          child: Icon(Icons.arrow_back),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                30.0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 20),
            child: SizedBox(
              width: 300,
              child: Text(
                'Resultado de tu simulador de crédito',
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'Montserrat',
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 20),
            child: SizedBox(
              width: 350,
              child: Text(
                  'Te presentamos en tu tabla de amortización el resultado del movimiento de tu credito:',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: SizedBox(
              width: 350,
              child: Text('Tabla de créditos',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 13),
                child: DataTable(
                  columnSpacing: 5.0,
                  horizontalMargin: 5.0,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Cuota',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Saldo Inicial',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Interés',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Abono a Capital',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Cuota Total',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Saldo Final',
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: cotizacion.amortizationRows,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () async {
                    await downloadExcelFile(
                        context, cotizacion.amortizationRows);
                  },
                  icon: Image.asset(
                    'assets/photos/excelIcon.png',
                    width: 36.0,
                    height: 36.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _mostrarConfirmacionEliminar(context, cotizacion);
                  },
                  color: Colors.black38,
                  iconSize: 36.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadExcelFile(
      BuildContext context, List<DataRow> rows) async {
    excel.Excel excelFile = excel.Excel.createExcel();
    excel.Sheet sheetObject = excelFile['Sheet1'];

    sheetObject.appendRow([
      'Cuota',
      'Saldo Inicial',
      'Interés',
      'Abono a Capital',
      'Cuota Total',
      'Saldo Final'
    ]);

    for (DataRow row in rows) {
      List<dynamic> rowData = [];
      for (DataCell cell in row.cells) {
        Widget childWidget = cell.child!;

        String textValue = (childWidget as Text).data!;

        rowData.add(textValue);
      }

      sheetObject.appendRow(rowData);
    }

    List<int>? excelBytes = excelFile.encode();
    if (excelBytes != null) {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final String excelPath = '${directory.path}/tabladecreditos.xlsx';
        File excelFileStorage = File(excelPath);
        await excelFileStorage.writeAsBytes(excelBytes);

        OpenFile.open(excelPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tabla descargada con éxito: $excelPath'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error al obtener el directorio de almacenamiento externo.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al codificar el archivo Excel.'),
        ),
      );
    }
  }

  void _mostrarConfirmacionEliminar(
      BuildContext context, Cotizacion cotizacion) async {
    bool confirmarEliminacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar Cotización',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro que deseas eliminar la cotización?',
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Sí',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmarEliminacion ?? false) {
      Navigator.pop(context, true);
      CotizacionManager.eliminarCotizacion(cotizacion);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cotización eliminada'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
