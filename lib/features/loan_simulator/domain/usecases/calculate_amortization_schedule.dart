import 'dart:math';

import '../entities/amortization_row.dart';

class CalculateAmortizationSchedule {
  List<AmortizationRow> call({
    required double loanAmount,
    required double annualInterestRate,
    required int numberOfMonths,
  }) {
    final monthlyInterestRate = annualInterestRate / 12;
    final installment = (loanAmount * monthlyInterestRate) /
        (1 - pow(1 + monthlyInterestRate, -numberOfMonths));

    final rows = <AmortizationRow>[];
    var openingBalance = loanAmount;

    for (var month = 1; month <= numberOfMonths; month++) {
      final interest = openingBalance * monthlyInterestRate;
      final principalPayment = installment - interest;
      final closingBalance = openingBalance - principalPayment;

      rows.add(AmortizationRow(
        installmentNumber: month,
        openingBalance: openingBalance,
        interest: interest,
        principalPayment: principalPayment,
        totalPayment: installment,
        closingBalance: closingBalance,
      ));

      openingBalance = closingBalance;
    }

    return rows;
  }
}
