import 'package:flutter/material.dart';

/// Reusable page background widget with gradient matching home screen design
class PageBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;

  const PageBackground({super.key, required this.child, this.gradientColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              gradientColors ??
              const [
                Color(0xFFFFB347), // Warm orange
                Color(0xFFFFA867), // Main orange
                Color(0xFFFF8C42), // Deeper orange
              ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
