// main.dart
import 'package:flutter/material.dart';
import 'paint_canvas.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(PaintApp());

class PaintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaintCanvas(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaTextTheme(),
      ),
    );
  }
}
