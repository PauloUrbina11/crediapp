class AmortizationRow {
  const AmortizationRow({
    required this.installmentNumber,
    required this.openingBalance,
    required this.interest,
    required this.principalPayment,
    required this.totalPayment,
    required this.closingBalance,
  });

  final int installmentNumber;
  final double openingBalance;
  final double interest;
  final double principalPayment;
  final double totalPayment;
  final double closingBalance;
}
