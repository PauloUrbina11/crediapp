class CalculateMaxLoanAmount {
  static const double _salaryMultiplier = 7;
  static const double _affordabilityFactor = 0.15;

  double call(double salary) => (salary * _salaryMultiplier) / _affordabilityFactor;
}
