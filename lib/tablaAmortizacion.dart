import 'package:flutter/material.dart';
import 'models.dart';

class CotizacionManager {
  static List<Cotizacion> historialCotizaciones = [];

  static void agregarCotizacion(Cotizacion cotizacion, int? userId) {
    cotizacion.userId = userId;
    historialCotizaciones.add(cotizacion);
  }

  static void eliminarCotizacion(Cotizacion cotizacion) {
    historialCotizaciones.remove(cotizacion);
  }
}

class Cotizacion {
  int? userId;
  final double monto;
  final DateTime fecha;
  final int numeroCuotas;
  final double interes;
  final List<DataRow> amortizationRows;

  Cotizacion({
    this.userId,
    required this.monto,
    required this.fecha,
    required this.numeroCuotas,
    required this.interes,
    required this.amortizationRows,
  });
}
