import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  static String format(double value) => _formatter.format(value);
}
