class MonthBudget {
  final double income;
  final double necessaryExpenses;

  MonthBudget({
    required this.income,
    required this.necessaryExpenses,
  });

  double dailyLimit(int daysInMonth) {
    final disposable = income - necessaryExpenses;
    return disposable <= 0 ? 0 : disposable / daysInMonth;
  }
}
