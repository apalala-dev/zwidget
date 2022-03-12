import 'package:flutter/material.dart';

class ExampleCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(size.width / 2.0, size.height / 2.0),
            width: size.width / 4.0,
            height: size.height / 4.0),
        Paint()..color = Colors.black);

    canvas.drawCircle(
        Offset(size.shortestSide / 2.0, size.shortestSide / 2.0),
        size.shortestSide / 3.0,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    canvas.drawLine(Offset.zero, size.bottomRight(Offset.zero),
        Paint()..color = Colors.red);

    canvas.drawLine(
        size.bottomLeft(Offset.zero),
        size.topRight(Offset.zero),
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4);

    canvas.drawCircle(Offset(size.shortestSide / 8.0, size.shortestSide / 2.0),
        size.shortestSide / 10.0, Paint()..color = Colors.purple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
