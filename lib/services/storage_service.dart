import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const String _prefix = 'expenses_';

  String _dateKey(DateTime date) {
    return "$_prefix${date.toIso8601String().substring(0, 10)}";
  }

  Future<List<Expense>> getExpenses(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _dateKey(date);

    final raw = prefs.getString(key);
    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> saveExpenses(DateTime date, List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _dateKey(date);

    final encoded =
        jsonEncode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(key, encoded);
  }
}
