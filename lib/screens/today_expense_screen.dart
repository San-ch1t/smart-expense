import 'package:flutter/material.dart';
import 'expenses_day_screen.dart';

class TodayExpenseScreen extends StatelessWidget {
  const TodayExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpensesDayScreen(date: DateTime.now());
  }
}
