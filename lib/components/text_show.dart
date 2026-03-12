import 'package:all_in_one_brainrot/screens/result_page/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextShow extends StatelessWidget {
  final String title;
  final double mainTextSize;
  final Color backgroundColor;
  final Color mainbackgroundColor;

  const TextShow({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.mainTextSize,
    required this.mainbackgroundColor,
  });


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outline/stroke layer
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.luckiestGuy(
            fontSize: mainTextSize,
            fontWeight: FontWeight.w900,
            // height: 1.1,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8
              ..color = backgroundColor,
            // ..color = Colors.black.withOpacity(0.3),
          ),
        ),
        // Fill layer
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.luckiestGuy(
            fontSize: mainTextSize,
            fontWeight: FontWeight.w900,
            color: mainbackgroundColor,
            // height: 1.1,
          ),
        ),
      ],
    );
  }
}
