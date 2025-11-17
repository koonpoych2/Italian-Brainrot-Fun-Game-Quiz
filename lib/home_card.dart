import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String? imagePath;
  final IconData? icon;
  final Widget? destination;

  const MenuCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.destination, // Make it required
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: destination != null
          ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination!),
        );
      }
          : null, // No action if destination is null
      child: SizedBox(
      height: 160, // Increased to accommodate text overflow
      child: Stack(
        clipBehavior: Clip.none, // Allow children to overflow
        children: [
          // Main card container
          Positioned(
            top: 20, // Offset to make room for text
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                // color: backgroundColor,
                gradient: LinearGradient(
                  colors: [
                    backgroundColor.withValues(alpha: 1.2),
                    backgroundColor.withValues(alpha: 1),
                    backgroundColor.withValues(alpha: 0.5),
                    // Lighter version
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // White rounded rectangle for icon/image background
                    Positioned(
                      right: 16,
                      top: 16,
                      bottom: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                        child: Image(
                          image: AssetImage('assets/images/burbaloni_lulliloli.png'),
                          fit: BoxFit.cover, // Optional: helps with image scaling
                        ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Title text with outline - positioned outside container
          Positioned(
            left: -5,
            top: 0, // Positioned at the top, above the card
            child: Stack(
              children: [
                // Outline/stroke layer
                Text(
                  title,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 10
                      ..color = Colors.white,
                      // ..color = Colors.black.withOpacity(0.3),
                  ),
                ),
                // Fill layer
                Text(
                  title,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFE76F51),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}

