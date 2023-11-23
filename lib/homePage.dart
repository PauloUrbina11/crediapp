import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:math';
import 'creditHistory.dart';
import 'tablaAmortizacion.dart';
import 'loginPage.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  final String? userName;
  final int? usuarioActivo;

  const HomePage({this.userName, this.usuarioActivo});

  @override
  _HomePageState createState() => _HomePageState();
}

class AmortizationTablePage extends StatelessWidget {
  final double loanAmount;
  final double interestRate;
  final int numberOfMonths;
  final int? usuarioActivo;

  AmortizationTablePage({
    required this.loanAmount,
    required this.interestRate,
    required this.numberOfMonths,
    this.usuarioActivo,
  });

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = generateAmortizationRows();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabla de Amortización',
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 10),
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
                rows: rows,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              await downloadExcelFile(context, rows);
            },
            child: Text('Descargar tabla'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
              minimumSize: Size(double.minPositive, 36.0),
              padding: EdgeInsets.symmetric(horizontal: 100.0),
            ),
          ),
          SizedBox(height: 2.0),
          ElevatedButton(
            onPressed: () async {
              int? userId = usuarioActivo;

              List<DataRow> rows = generateAmortizationRows();
              double monto = loanAmount;
              DateTime fecha = DateTime.now();
              int numeroCuotas = numberOfMonths;
              double interes = interestRate;

              Cotizacion cotizacion = Cotizacion(
                userId: userId ?? 1,
                monto: monto,
                fecha: fecha,
                numeroCuotas: numeroCuotas,
                interes: interes,
                amortizationRows: rows,
              );

              CotizacionManager.agregarCotizacion(
                  cotizacion, cotizacion.userId);

              final snackBar = SnackBar(
                content: Text('Se guardó correctamente la cotización'),
                duration: Duration(seconds: 3),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text(
              'Guardar cotización',
              style: TextStyle(color: Colors.deepPurple),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.white,
              minimumSize: Size(double.minPositive, 36.0),
              padding: EdgeInsets.symmetric(horizontal: 90.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
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
        final String excelPath = '${directory.path}/tabladeamortizacion.xlsx';
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

  List<DataRow> generateAmortizationRows() {
    List<DataRow> rows = [];

    double saldoInicial = loanAmount;
    double tasaInteres = interestRate;

    for (int cuotaNumero = 1; cuotaNumero <= numberOfMonths; cuotaNumero++) {
      double interes = saldoInicial * tasaInteres;
      double cuota = (loanAmount * tasaInteres) /
          (1 - pow(1 + tasaInteres, -numberOfMonths));
      double abonoCapital = cuota - interes;
      double saldoFinal = saldoInicial - abonoCapital;

      rows.add(DataRow(
        cells: [
          DataCell(Text(
            '${cuotaNumero.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )),
          DataCell(Text(
            '\$${saldoInicial.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          )),
          DataCell(Text(
            '\$${interes.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          )),
          DataCell(Text(
            '\$${abonoCapital.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          )),
          DataCell(Text(
            '\$${cuota.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          )),
          DataCell(Text(
            '\$${saldoFinal.toInt()}',
            style: TextStyle(
              fontSize: 10.0,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          )),
        ],
      ));

      saldoInicial = saldoFinal;
    }

    return rows;
  }
}

class _HomePageState extends State<HomePage> {
  String? selectedCreditType;
  List<String> creditTypes = [
    'Crédito de vehículo',
    'Crédito de vivienda',
    'Crédito de libre inversión'
  ];

  int selectedMonths = 12;
  TextEditingController salaryController = TextEditingController();
  TextEditingController calculatedValueController = TextEditingController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 20, right: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Hola ${widget.userName} 👋',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.notifications_active,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Simulador de crédito',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(width: 13),
                          Icon(
                            Icons.info,
                            size: 20.0,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      Text(
                        'Ingresa los datos para tu crédito según lo que necesites.',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Qué tipo de crédito deseas realizar?',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 13),
                              DropdownButtonFormField<String>(
                                value: selectedCreditType,
                                items: creditTypes.map((String creditType) {
                                  return DropdownMenuItem<String>(
                                    value: creditType,
                                    child: Text(
                                      creditType,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedCreditType = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  hintText: 'Selecciona el tipo de crédito',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.0,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 13),
                              Text(
                                '¿Cuál es tu salario base?',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 13),
                              TextFormField(
                                controller: salaryController,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  updateCalculatedValue();
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 8,
                                  ),
                                  hintText: '\$ 1000000',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.0,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Digita tu salario para calcular el préstamo que necesitas',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Valor máximo a prestar',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: calculatedValueController,
                                enabled: false,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 10,
                                  ),
                                  hintText: '\$ 0',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.0,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '¿A cuántos meses?',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 13),
                              DropdownButtonFormField<int>(
                                value: selectedMonths,
                                items: List.generate(73, (index) => index + 12)
                                    .map((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.grey,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedMonths = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 10,
                                  ),
                                  hintText: 'Selecciona',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat',
                                    fontSize: 12.0,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Elige un plazo desde 12 hasta 84 meses',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 13),
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedCreditType != null &&
                                      salaryController.text.isNotEmpty &&
                                      selectedMonths != null) {
                                    double interestRate;
                                    switch (selectedCreditType) {
                                      case 'Crédito de vehículo':
                                        interestRate = 0.03; // 3%
                                        break;
                                      case 'Crédito de vivienda':
                                        interestRate = 0.01; // 1%
                                        break;
                                      case 'Crédito de libre inversión':
                                        interestRate = 0.035; // 3.5%
                                        break;
                                      default:
                                        interestRate = 1.0;
                                    }

                                    double loanAmount = double.tryParse(
                                            calculatedValueController.text
                                                .replaceAll('\$', '')
                                                .replaceAll(',', '')) ??
                                        0.0;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AmortizationTablePage(
                                                loanAmount: loanAmount,
                                                interestRate: interestRate,
                                                numberOfMonths: selectedMonths!,
                                                usuarioActivo:
                                                    widget.usuarioActivo,
                                              )),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Por favor, completa todos los campos.'),
                                      ),
                                    );
                                  }
                                },
                                child: Text('Simular'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple,
                                  onPrimary: Colors.white,
                                  minimumSize: Size(double.infinity, 36.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          HistorialCreditosPage(usuarioActivo: widget.usuarioActivo),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet, size: 30),
            label: 'Historial créditos',
          ),
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void updateCalculatedValue() {
    try {
      double salary = double.tryParse(salaryController.text) ?? 0.0;
      double calculatedValue = (salary * 7) / 0.15;

      NumberFormat formatter = NumberFormat.currency(symbol: '\$');
      String formattedValue = formatter.format(calculatedValue);

      calculatedValueController.text = formattedValue;
    } catch (e) {
      calculatedValueController.text = '\$0.00';
    }
  }
}
