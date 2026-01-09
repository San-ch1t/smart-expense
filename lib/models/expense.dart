class Expense {
  final String id;
  final DateTime date;
  final double amount;
  final String note;

  Expense({
    required this.id,
    required this.date,
    required this.amount,
    this.note = '',
  });
}
