import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const _key = 'expenses_data';

  static Future<void> save(Map<DateTime, List<Expense>> data) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = data.map((key, value) => MapEntry(
          key.toIso8601String(),
          value
              .map((e) => {
                    'id': e.id,
                    'date': e.date.toIso8601String(),
                    'amount': e.amount,
                    'note': e.note,
                    'category': e.category,
                  })
              .toList(),
        ));

    prefs.setString(_key, jsonEncode(encoded));
  }

  static Future<Map<DateTime, List<Expense>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    return decoded.map((key, value) => MapEntry(
          DateTime.parse(key),
          (value as List)
              .map(
                (e) => Expense(
                  id: e['id'],
                  date: DateTime.parse(e['date']),
                  amount: (e['amount'] as num).toDouble(),
                  note: e['note'],
                  category: e['category'],
                ),
              )
              .toList(),
        ));
  }
}
