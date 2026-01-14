import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class ExpensesDayScreen extends StatefulWidget {
  final DateTime date;

  const ExpensesDayScreen({super.key, required this.date});

  @override
  State<ExpensesDayScreen> createState() => _ExpensesDayScreenState();
}

class _ExpensesDayScreenState extends State<ExpensesDayScreen> {
  final StorageService _storage = StorageService();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();

  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    expenses = await _storage.getExpenses(widget.date);
    setState(() {});
  }

  Future<void> _addExpense() async {
    if (_titleCtrl.text.trim().isEmpty ||
        _amountCtrl.text.trim().isEmpty) return;

    expenses.add(
      Expense(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        amount: double.tryParse(_amountCtrl.text) ?? 0,
      ),
    );

    await _storage.saveExpenses(widget.date, expenses);

    _titleCtrl.clear();
    _amountCtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // PLACEHOLDER VALUES (logic later)
    const double monthlyBudget = 20000;
    const double totalExpense = 3450;

    return Scaffold(
      body: Column(
        children: [
          // SUMMARY TABLE
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          'Monthly Budget',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '₹20,000',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          'Total Expense',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '₹3,450',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // EXPENSE INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Expense title',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Add Expense'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses yet'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (_, i) {
                      final e = expenses[i];
                      return ListTile(
                        title: Text(e.title),
                        trailing:
                            Text('₹${e.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
