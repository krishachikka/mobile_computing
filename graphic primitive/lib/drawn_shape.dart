// drawn_shape.dart
import 'package:flutter/material.dart';
import 'paint_canvas.dart';

class DrawnShape {
  final Offset? start;
  final Offset? end;
  final List<Offset>? path;
  final String? text;
  final Offset? textPosition;
  final Shape? shape;
  final Color borderColor;
  final Color? fillColor;

  DrawnShape({
    this.start,
    this.end,
    this.path,
    this.text,
    this.textPosition,
    this.shape,
    required this.borderColor,
    this.fillColor,
  });

  bool contains(Offset point) {
    if (shape == Shape.rectangle && start != null && end != null) {
      final rect = Rect.fromPoints(start!, end!);
      return rect.contains(point);
    } else if (shape == Shape.circle && start != null && end != null) {
      final center = (start! + end!) / 2;
      final radius = (end! - start!).distance / 2;
      return (point - center).distance <= radius;
    }
    return false;
  }

  DrawnShape copyWith({Color? fillColor}) {
    return DrawnShape(
      start: this.start,
      end: this.end,
      path: this.path,
      text: this.text,
      textPosition: this.textPosition,
      shape: this.shape,
      borderColor: this.borderColor,
      fillColor: fillColor ?? this.fillColor,
    );
  }
}
