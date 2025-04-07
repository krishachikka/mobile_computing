// paint_canvas.dart
import 'package:flutter/material.dart';
import 'drawn_shape.dart';
import 'shape_painter.dart';

class PaintCanvas extends StatefulWidget {
  @override
  _PaintCanvasState createState() => _PaintCanvasState();
}

enum Shape { rectangle, circle, line }
enum Tool { draw, fill, freehand, text }

class _PaintCanvasState extends State<PaintCanvas> {
  Tool _selectedTool = Tool.draw;
  Shape _selectedShape = Shape.rectangle;
  Color _selectedColor = Colors.black;

  List<DrawnShape> _shapes = [];
  Offset? _start;
  Offset? _end;
  List<Offset> _currentPath = [];

  void _startDrawing(DragStartDetails details) {
    final pos = details.localPosition;
    if (_selectedTool == Tool.freehand) {
      _currentPath = [pos];
    } else {
      _start = pos;
      _end = pos;
    }
  }

  void _updateDrawing(DragUpdateDetails details) {
    final pos = details.localPosition;
    setState(() {
      if (_selectedTool == Tool.freehand) {
        _currentPath.add(pos);
      } else {
        _end = pos;
      }
    });
  }

  void _endDrawing(DragEndDetails details) {
    if (_selectedTool == Tool.freehand) {
      setState(() {
        _shapes.add(DrawnShape(path: List.from(_currentPath), borderColor: _selectedColor));
        _currentPath.clear();
      });
    } else if (_start != null && _end != null) {
      setState(() {
        _shapes.add(DrawnShape(
          start: _start!,
          end: _end!,
          shape: _selectedShape,
          borderColor: _selectedColor,
        ));
        _start = null;
        _end = null;
      });
    }
  }

  void _handleTapDown(TapDownDetails details) async {
    final pos = details.localPosition;
    if (_selectedTool == Tool.fill) {
      setState(() {
        for (var i = _shapes.length - 1; i >= 0; i--) {
          if (_shapes[i].contains(pos)) {
            _shapes[i] = _shapes[i].copyWith(fillColor: _selectedColor);
            break;
          }
        }
      });
    } else if (_selectedTool == Tool.text) {
      final enteredText = await _showTextInputDialog();
      if (enteredText != null && enteredText.trim().isNotEmpty) {
        setState(() {
          _shapes.add(DrawnShape(
            text: enteredText.trim(),
            textPosition: pos,
            borderColor: _selectedColor,
          ));
        });
      }
    }
  }

  Future<String?> _showTextInputDialog() async {
    String text = "";
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Text"),
          content: TextField(
            onChanged: (value) => text = value,
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(onPressed: () => Navigator.pop(context, text), child: Text("OK")),
          ],
        );
      },
    );
  }

  void _clearCanvas() => setState(() => _shapes.clear());

  bool _isToolSelected(Tool tool) => _selectedTool == tool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Cherry Paint :)', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: _clearCanvas, color: Colors.white),
        ],
      ),
      body: GestureDetector(
        onPanStart: _selectedTool == Tool.draw || _selectedTool == Tool.freehand ? _startDrawing : null,
        onPanUpdate: _selectedTool == Tool.draw || _selectedTool == Tool.freehand ? _updateDrawing : null,
        onPanEnd: _selectedTool == Tool.draw || _selectedTool == Tool.freehand ? _endDrawing : null,
        onTapDown: _handleTapDown,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'bg.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: ShapePainter(
                  shapes: _shapes,
                  previewStart: _start,
                  previewEnd: _end,
                  previewShape: _selectedShape,
                  previewColor: _selectedColor,
                  tool: _selectedTool,
                  currentPath: _currentPath,
                ),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink.shade50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _toolButton(Icons.crop_square, Tool.draw, shape: Shape.rectangle),
            _toolButton(Icons.circle_outlined, Tool.draw, shape: Shape.circle),
            _toolButton(Icons.show_chart, Tool.draw, shape: Shape.line),
            _toolButton(Icons.brush, Tool.freehand),
            _toolButton(Icons.format_color_fill, Tool.fill),
            _toolButton(Icons.text_fields, Tool.text),
            _colorButton(Colors.red),
            _colorButton(Colors.green),
            _colorButton(Colors.blue),
            _colorButton(Colors.orange),
            _colorButton(Colors.purple),
            _colorButton(Colors.yellow),
            _colorButton(Colors.teal),
            _colorButton(Colors.brown),
            _colorButton(Colors.pink),
            PopupMenuButton<Color>(
              icon: Icon(Icons.palette, color: _selectedColor),
              onSelected: (color) => setState(() => _selectedColor = color),
              itemBuilder: (_) => [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
                Colors.teal,
                Colors.brown,
                Colors.pink,
              ].map((color) {
                return PopupMenuItem(
                  value: color,
                  child: Row(children: [
                    Icon(Icons.circle, color: color),
                    SizedBox(width: 8),
                  ]),
                );
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _toolButton(IconData icon, Tool tool, {Shape? shape}) {
    final bool isSelected = _isToolSelected(tool) &&
        (tool != Tool.draw || shape == null || shape == _selectedShape);

    return IconButton(
      icon: Icon(icon),
      color: isSelected ? Colors.pink : null,
      onPressed: () {
        setState(() {
          _selectedTool = tool;
          if (tool == Tool.draw && shape != null) _selectedShape = shape;
        });
      },
    );
  }

  Widget _colorButton(Color color) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () => setState(() => _selectedColor = color),
    );
  }
}