class Expense {
  final String id;
  final String title;
  final double amount;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
