import 'package:flutter/material.dart';
import 'dart:math';

class TemperatureChartScreen extends StatelessWidget {
  const TemperatureChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = List.generate(12, (i) => 20 + Random().nextInt(15));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Chart'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomPaint(
          painter: _TemperaturePainter(data),
          child: Container(),
        ),
      ),
    );
  }
}

class _TemperaturePainter extends CustomPainter {
  final List<int> data;

  _TemperaturePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final dx = size.width / (data.length - 1);
    final maxTemp = data.reduce(max);

    for (int i = 0; i < data.length; i++) {
      final x = i * dx;
      final y = size.height - (data[i] / maxTemp) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
