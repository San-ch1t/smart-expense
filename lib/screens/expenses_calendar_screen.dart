import 'package:flutter/material.dart';
import '../widgets/day_cell.dart';
import 'expenses_day_screen.dart';

class ExpensesCalendarScreen extends StatefulWidget {
  const ExpensesCalendarScreen({super.key});

  @override
  State<ExpensesCalendarScreen> createState() =>
      _ExpensesCalendarScreenState();
}

class _ExpensesCalendarScreenState extends State<ExpensesCalendarScreen> {
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime selectedDate = DateTime.now();

  final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final List<String> monthNames = const [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  void _changeMonth(int delta) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${monthNames[currentMonth.month - 1]} ${currentMonth.year}',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeMonth(-1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: weekdays
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                .toList(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: daysInMonth + startOffset,
              itemBuilder: (context, index) {
                if (index < startOffset) return const SizedBox.shrink();

                final day = index - startOffset + 1;
                final date =
                    DateTime(currentMonth.year, currentMonth.month, day);

                return DayCell(
                  day: day,
                  isToday: _sameDay(date, DateTime.now()),
                  isSelected: _sameDay(date, selectedDate),
                  onTap: () async {
                    selectedDate = date;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpensesDayScreen(date: date),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
