import 'package:flutter/material.dart';
import 'detalleCotizacion.dart';
import 'tablaAmortizacion.dart';
import 'package:intl/intl.dart';

class HistorialCreditosPage extends StatefulWidget {
  final int? usuarioActivo;

  HistorialCreditosPage({this.usuarioActivo});

  @override
  _HistorialCreditosPageState createState() => _HistorialCreditosPageState();
}

class _HistorialCreditosPageState extends State<HistorialCreditosPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Historial de créditos',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Aquí encontrarás tu historial de créditos y el registro de todas tus simulaciones.',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 20.0,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: _buildHistorialCotizaciones(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialCotizaciones() {
    int? currentUserId = widget.usuarioActivo;

    bool tieneCotizaciones = CotizacionManager.historialCotizaciones
        .any((cotizacion) => cotizacion.userId == currentUserId);

    if (!tieneCotizaciones) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text(
              'No hay datos para mostrar',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else {
      final currencyFormat = NumberFormat.currency(symbol: '\$ ');
      List<Cotizacion> historialCotizaciones = CotizacionManager
          .historialCotizaciones
          .where((cotizacion) => cotizacion.userId == currentUserId)
          .toList();
      return DataTable(
        columnSpacing: 13.0,
        horizontalMargin: 8.0,
        columns: [
          DataColumn(
            label: Text('Monto',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          DataColumn(
            label: Text('Fecha',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          DataColumn(
            label: Text('No. de Cuotas',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          DataColumn(
            label: Text('Interés',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ),
          DataColumn(
            label: Text(
              '',
              style: TextStyle(
                fontSize: 10.0,
                fontFamily: 'Montserrat',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        rows: historialCotizaciones.map((cotizacion) {
          return DataRow(cells: [
            DataCell(
              Text(
                '${currencyFormat.format(cotizacion.monto)}',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                '${cotizacion.fecha.day}/${cotizacion.fecha.month}/${cotizacion.fecha.year}',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                '${cotizacion.numeroCuotas}',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              Text(
                '${(cotizacion.interes * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(
                  Icons.table_view,
                  color: Colors.green,
                ),
                iconSize: 30.0,
                onPressed: () =>
                    _mostrarDetallesCotizacion(context, cotizacion),
              ),
            ),
          ]);
        }).toList(),
      );
    }
  }

  void _mostrarDetallesCotizacion(
      BuildContext context, Cotizacion cotizacion) async {
    bool cotizacionEliminada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleCotizacionPage(cotizacion: cotizacion),
      ),
    );

    if (cotizacionEliminada != null && cotizacionEliminada) {
      setState(() {
        CotizacionManager.historialCotizaciones.remove(cotizacion);
      });
    }
  }
}
