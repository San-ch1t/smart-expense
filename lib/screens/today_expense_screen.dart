import 'package:flutter/material.dart';
import '../models/expense.dart';

class TodayExpenseScreen extends StatelessWidget {
  final Function(Expense) onAdd;

  const TodayExpenseScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String selectedCategory = 'General';

    return Scaffold(
      appBar: AppBar(title: const Text("Add Today's Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: const [
                DropdownMenuItem(value: 'General', child: Text('General')),
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => selectedCategory = v!,
              decoration:
                  const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text);
                if (amt == null) return;

                onAdd(
                  Expense(
                    id: DateTime.now().toString(),
                    date: DateTime.now(),
                    amount: amt,
                    note: noteCtrl.text,
                    category: selectedCategory,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
