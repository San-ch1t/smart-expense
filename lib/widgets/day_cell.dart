import 'package:flutter/material.dart';

class DayCell extends StatefulWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<DayCell> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            gradient: _gradient(),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            '${widget.day}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Gradient? _gradient() {
    if (widget.isSelected) {
      return const LinearGradient(
        colors: [Colors.teal, Colors.green],
      );
    }
    if (isHovering) {
      return LinearGradient(
        colors: [
          Colors.teal.withOpacity(0.4),
          Colors.green.withOpacity(0.4),
        ],
      );
    }
    if (widget.isToday) {
      return LinearGradient(
        colors: [
          Colors.teal.withOpacity(0.25),
          Colors.green.withOpacity(0.25),
        ],
      );
    }
    return null;
  }
}
