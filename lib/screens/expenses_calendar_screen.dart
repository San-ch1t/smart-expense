import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../widgets/day_cell.dart';
import 'expenses_day_screen.dart';

class ExpensesCalendarScreen extends StatefulWidget {
  final Category category;

  const ExpensesCalendarScreen({super.key, required this.category});

  @override
  State<ExpensesCalendarScreen> createState() =>
      _ExpensesCalendarScreenState();
}

class _ExpensesCalendarScreenState
    extends State<ExpensesCalendarScreen> {
  final Map<DateTime, List<Expense>> expensesByDay = {};
  DateTime currentMonth = DateTime.now();

  // ---- Budget logic ----
  double monthlyIncome = 10000;
  double fixedExpenses = 4500;
  double savings = 1000;

  double get dailyLimit {
    final days = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    return (monthlyIncome - fixedExpenses - savings) / days;
  }

  DateTime _key(DateTime d) => DateTime(d.year, d.month, d.day);

  /// ✅ CORRECT weekday math (Mon = 0 … Sun = 6)
  List<DateTime?> _calendarDays() {
    final firstDay =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    final startOffset = firstDay.weekday - 1; // ✅ FIX
    final totalCells = startOffset + daysInMonth;

    return List.generate(totalCells, (i) {
      if (i < startOffset) return null;
      return DateTime(
        currentMonth.year,
        currentMonth.month,
        i - startOffset + 1,
      );
    });
  }

  double _totalForDay(DateTime day) {
    return expensesByDay[_key(day)]
            ?.fold<double>(0.0, (s, e) => s + e.amount) ??
        0.0;
  }

  Color _colorFor(double total) {
    if (total == 0) return Colors.grey.shade200;
    if (total > dailyLimit) return Colors.red.shade300;
    return Colors.green.shade200;
  }

  void _changeMonth(int delta) {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + delta,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _calendarDays();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: Column(
        children: [
          // ---- Month header ----
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  '${_monthName(currentMonth.month)} ${currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),

          // ---- Weekday header (Mon → Sun) ----
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _Weekday('Mon'),
                _Weekday('Tue'),
                _Weekday('Wed'),
                _Weekday('Thu'),
                _Weekday('Fri'),
                _Weekday('Sat'),
                _Weekday('Sun'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ---- Calendar grid ----
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: days.length,
              itemBuilder: (ctx, i) {
                final day = days[i];
                if (day == null) return const SizedBox.shrink();

                final key = _key(day);
                final total = _totalForDay(day);

                return DayCell(
                  day: day,
                  total: total,
                  color: _colorFor(total),
                  onTap: () async {
                    final existing = expensesByDay[key] ?? [];

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpensesDayScreen(
                          day: key,
                          category: widget.category.name,
                          initialExpenses: existing,
                          onSave: (updated) {
                            setState(() {
                              if (updated.isEmpty) {
                                expensesByDay.remove(key);
                              } else {
                                expensesByDay[key] = updated;
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Helpers ----

class _Weekday extends StatelessWidget {
  final String label;
  const _Weekday(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

String _monthName(int m) {
  const months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[m];
}
