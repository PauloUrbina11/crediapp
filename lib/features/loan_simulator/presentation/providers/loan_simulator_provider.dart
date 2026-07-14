import 'package:flutter/foundation.dart';

import '../../domain/entities/amortization_row.dart';
import '../../domain/entities/credit_type.dart';
import '../../domain/usecases/calculate_amortization_schedule.dart';
import '../../domain/usecases/calculate_max_loan_amount.dart';

class LoanSimulatorProvider extends ChangeNotifier {
  LoanSimulatorProvider({
    CalculateMaxLoanAmount? calculateMaxLoanAmount,
    CalculateAmortizationSchedule? calculateAmortizationSchedule,
  })  : _calculateMaxLoanAmount = calculateMaxLoanAmount ?? CalculateMaxLoanAmount(),
        _calculateAmortizationSchedule =
            calculateAmortizationSchedule ?? CalculateAmortizationSchedule();

  final CalculateMaxLoanAmount _calculateMaxLoanAmount;
  final CalculateAmortizationSchedule _calculateAmortizationSchedule;

  CreditType? selectedCreditType;
  int selectedMonths = 12;
  double maxLoanAmount = 0;

  bool get canSimulate => selectedCreditType != null && maxLoanAmount > 0;

  void selectCreditType(CreditType? creditType) {
    selectedCreditType = creditType;
    notifyListeners();
  }

  void selectMonths(int months) {
    selectedMonths = months;
    notifyListeners();
  }

  void updateSalary(String rawSalary) {
    final salary = double.tryParse(rawSalary) ?? 0;
    maxLoanAmount = _calculateMaxLoanAmount(salary);
    notifyListeners();
  }

  List<AmortizationRow> buildAmortizationSchedule() {
    return _calculateAmortizationSchedule(
      loanAmount: maxLoanAmount,
      annualInterestRate: selectedCreditType!.annualInterestRate,
      numberOfMonths: selectedMonths,
    );
  }
}
