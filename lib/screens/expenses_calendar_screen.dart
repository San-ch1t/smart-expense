import 'package:flutter/material.dart';
import '../models/category.dart';

class ExpensesCalendarScreen extends StatefulWidget {
  final Category category;

  const ExpensesCalendarScreen({super.key, required this.category});

  @override
  State<ExpensesCalendarScreen> createState() =>
      _ExpensesCalendarScreenState();
}

class _ExpensesCalendarScreenState
    extends State<ExpensesCalendarScreen> {
  final Map<DateTime, double> dailyExpenses = {};

  DateTime _normalize(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  double _getExpense(DateTime date) =>
      dailyExpenses[_normalize(date)] ?? 0;

  void _addExpense(DateTime date, double amount) {
    setState(() {
      dailyExpenses[_normalize(date)] = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth =
        DateUtils.getDaysInMonth(now.year, now.month);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: daysInMonth,
        itemBuilder: (ctx, index) {
          final day =
              DateTime(now.year, now.month, index + 1);
          final amount = _getExpense(day);

          return GestureDetector(
            onTap: () => _showAddExpenseDialog(day),
            child: Container(
              decoration: BoxDecoration(
                color: amount > 0
                    ? Colors.indigo.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${index + 1}',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  if (amount > 0)
                    Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddExpenseDialog(DateTime date) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            'Expense — ${date.day}/${date.month}/${date.year}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value =
                  double.tryParse(controller.text);
              if (value != null) {
                _addExpense(date, value);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
