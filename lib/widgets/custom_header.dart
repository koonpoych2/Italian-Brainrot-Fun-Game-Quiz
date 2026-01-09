import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onHomeTap;

  const CustomHeader({super.key, required this.title, this.onHomeTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Home Button
          if (onHomeTap != null)
            GestureDetector(
              onTap: onHomeTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.home, color: Colors.black, size: 28),
              ),
            ),
          // Title - Centered with Expanded widgets on both sides
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Stack(
                  children: [
                    // Dark brown outline (outer)
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 8
                          ..color = const Color(0xFF8B4513),
                      ),
                    ),
                    // Orange/golden gradient fill
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFFFFD700), // Gold
                          Color(0xFFFFA500), // Orange
                          Color(0xFFFF8C00), // Dark Orange
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        title.toUpperCase(),
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Spacer to balance the home button (keeps title centered)
          if (onHomeTap != null)
            const SizedBox(width: 48), // Same width as home button
        ],
      ),
    );
  }
}
