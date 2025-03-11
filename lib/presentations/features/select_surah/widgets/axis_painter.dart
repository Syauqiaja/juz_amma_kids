import 'package:flutter/material.dart';

class AxisPainter extends CustomPainter {
  final double gridSize;
  final Color? color;

  AxisPainter(this.gridSize, {this.color = null});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.black
      ..strokeWidth = 2;

    // Draw X and Y axis
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);

    final gridPaint = Paint()
      ..color = color ?? Colors.grey
      ..strokeWidth = 1;

    // Vertical grid lines
    for (double i = gridSize; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (double i = size.height - gridSize; i > 0; i -= gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Text painter for drawing coordinates
    final textStyle = TextStyle(color: Colors.black, fontSize: 12);
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Draw coordinates in the center of each grid cell
    for (int row = 0; row < (size.height / gridSize).floor(); row++) {
      for (int col = 0; col < (size.width / gridSize).floor(); col++) {
        final textSpan = TextSpan(
          text: '(${col+1}, ${row+1})', // Coordinate text
          style: textStyle,
        );

        textPainter.text = textSpan;
        textPainter.layout();

        final offset = Offset(
          col * gridSize + gridSize / 2 - textPainter.width / 2,
          size.height - (row * gridSize + gridSize / 2 + textPainter.height / 2),
        );

        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
