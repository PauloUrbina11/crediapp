class SavedCredit {
  const SavedCredit({
    required this.id,
    required this.creditTypeLabel,
    required this.loanAmount,
    required this.numberOfMonths,
    required this.createdAt,
  });

  final String id;
  final String creditTypeLabel;
  final double loanAmount;
  final int numberOfMonths;
  final DateTime createdAt;
}
