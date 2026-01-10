import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpensesDayScreen extends StatefulWidget {
  final DateTime day;
  final String category;
  final List<Expense> initialExpenses;
  final void Function(List<Expense>) onSave;

  const ExpensesDayScreen({
    super.key,
    required this.day,
    required this.category,
    required this.initialExpenses,
    required this.onSave,
  });

  @override
  State<ExpensesDayScreen> createState() => _ExpensesDayScreenState();
}

class _ExpensesDayScreenState extends State<ExpensesDayScreen> {
  late List<Expense> expenses;

  @override
  void initState() {
    super.initState();
    expenses = List.from(widget.initialExpenses);
  }

  void _addExpense() {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text);
              if (amount == null) return;

              setState(() {
                expenses.add(
                  Expense(
                    id: DateTime.now().toIso8601String(),
                    amount: amount,
                    note: noteCtrl.text,
                    date: widget.day,
                    category: widget.category,
                  ),
                );
              });

              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total =
        expenses.fold<double>(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.day.day}/${widget.day.month}/${widget.day.year}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onSave(expenses);
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Total: ₹$total',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (ctx, i) {
                      final e = expenses[i];
                      return ListTile(
                        title: Text('₹${e.amount}'),
                        subtitle: Text(e.note),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              expenses.removeAt(i);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
