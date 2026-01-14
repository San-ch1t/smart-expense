import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/expense.dart';

class SpendingTemperatureScreen extends StatefulWidget {
  const SpendingTemperatureScreen({super.key});

  @override
  State<SpendingTemperatureScreen> createState() =>
      _SpendingTemperatureScreenState();
}

class _SpendingTemperatureScreenState
    extends State<SpendingTemperatureScreen> {
  final StorageService _storage = StorageService();
  double total = 0;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    final expenses = await _storage.getExpenses(DateTime.now());
    total = expenses.fold(0, (sum, e) => sum + e.amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (total < 500) {
      color = Colors.blue;
      label = 'Cold ❄️';
    } else if (total < 1500) {
      color = Colors.orange;
      label = 'Warm 🌤️';
    } else {
      color = Colors.red;
      label = 'Hot 🔥';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Temperature'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Today\'s spending: ₹${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
