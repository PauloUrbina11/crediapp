enum CreditType {
  vehicle('Crédito de vehículo', 0.03),
  housing('Crédito de vivienda', 0.01),
  freeInvestment('Crédito de libre inversión', 0.035);

  const CreditType(this.label, this.annualInterestRate);

  final String label;
  final double annualInterestRate;
}
