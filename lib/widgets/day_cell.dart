import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final DateTime day;
  final double total;
  final Color color;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.total,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (total > 0)
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
