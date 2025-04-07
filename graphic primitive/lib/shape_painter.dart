// shape_painter.dart
import 'package:flutter/material.dart';
import 'drawn_shape.dart';
import 'paint_canvas.dart';

class ShapePainter extends CustomPainter {
  final List<DrawnShape> shapes;
  final Offset? previewStart;
  final Offset? previewEnd;
  final Shape previewShape;
  final Color previewColor;
  final Tool tool;
  final List<Offset> currentPath;

  ShapePainter({
    required this.shapes,
    required this.previewStart,
    required this.previewEnd,
    required this.previewShape,
    required this.previewColor,
    required this.tool,
    required this.currentPath,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final shape in shapes) {
      paint.color = shape.borderColor;

      if (shape.path != null) {
        _drawFreehand(canvas, paint, shape.path!);
      } else if (shape.shape != null && shape.start != null && shape.end != null) {
        if (shape.fillColor != null) {
          final fillPaint = Paint()
            ..color = shape.fillColor!
            ..style = PaintingStyle.fill;
          _drawShape(canvas, fillPaint, shape.shape!, shape.start!, shape.end!);
        }
        _drawShape(canvas, paint, shape.shape!, shape.start!, shape.end!);
      } else if (shape.text != null && shape.textPosition != null) {
        final textSpan = TextSpan(
          text: shape.text!,
          style: TextStyle(color: shape.borderColor, fontSize: 18),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, shape.textPosition!);
      }
    }

    if (tool == Tool.draw && previewStart != null && previewEnd != null) {
      paint.color = previewColor;
      _drawShape(canvas, paint, previewShape, previewStart!, previewEnd!);
    } else if (tool == Tool.freehand && currentPath.isNotEmpty) {
      paint.color = previewColor;
      _drawFreehand(canvas, paint, currentPath);
    }
  }

  void _drawShape(Canvas canvas, Paint paint, Shape shape, Offset start, Offset end) {
    switch (shape) {
      case Shape.rectangle:
        canvas.drawRect(Rect.fromPoints(start, end), paint);
        break;
      case Shape.circle:
        final rect = Rect.fromPoints(start, end);
        canvas.drawOval(rect, paint);
        break;
      case Shape.line:
        canvas.drawLine(start, end, paint);
        break;
    }
  }

  void _drawFreehand(Canvas canvas, Paint paint, List<Offset> points) {
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
