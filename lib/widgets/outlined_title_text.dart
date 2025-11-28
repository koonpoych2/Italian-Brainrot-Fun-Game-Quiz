import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable cartoon-style outlined text widget.
/// Matches the look of the title in MenuCard.
class OutlinedTitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final TextAlign textAlign;

  const OutlinedTitleText({
    super.key,
    required this.text,
    this.fontSize = 54,
    this.fillColor = const Color(0xFFE76F51),
    this.strokeColor = Colors.white,
    this.strokeWidth = 10,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Outline (stroke)
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.luckiestGuy(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            height: 1.1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill (inner color)
        Text(
          text,
          textAlign: textAlign,
          style: GoogleFonts.luckiestGuy(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: fillColor,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
