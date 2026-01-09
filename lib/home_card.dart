import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final String? imagePath;
  final IconData? icon;
  final Widget? destination;

  const MenuCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.destination,
    this.imagePath,
    this.icon,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Create lighter and darker shades for gradient border
    final Color lighterColor = Color.lerp(
      widget.backgroundColor,
      Colors.white,
      0.6,
    )!;
    final Color darkerColor = Color.lerp(
      widget.backgroundColor,
      Colors.black,
      0.3,
    )!;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.destination != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget.destination!),
              );
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            // Outer glow effect
            boxShadow: [
              // Colored glow
              BoxShadow(
                color: widget.backgroundColor.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              // Bottom shadow for depth
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            // Gradient border using decoration
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  lighterColor,
                  Colors.white.withOpacity(0.9),
                  lighterColor,
                  darkerColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
            padding: const EdgeInsets.all(3), // Border thickness
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    // Image on the right with gradient fade blend
                    Positioned(
                      right: -10,
                      top: -10,
                      bottom: -10,
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Colors.transparent, Colors.white],
                            stops: const [0.0, 0.5],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          widget.imagePath ??
                              'assets/images/burbaloni_lulliloli.png',
                          width: 200,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Pattern of subtle icons behind text
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white.withOpacity(0.15),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      left: 45,
                      top: 25,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.12),
                        size: 18,
                      ),
                    ),
                    Positioned(
                      left: 80,
                      top: 8,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(0.1),
                        size: 16,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 15,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white.withOpacity(0.1),
                        size: 12,
                      ),
                    ),
                    Positioned(
                      left: 55,
                      bottom: 25,
                      child: Icon(
                        Icons.star_rounded,
                        color: Colors.white.withOpacity(0.12),
                        size: 14,
                      ),
                    ),
                    Positioned(
                      left: 90,
                      top: 50,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.08),
                        size: 20,
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 55,
                      child: Icon(
                        Icons.hexagon_outlined,
                        color: Colors.white.withOpacity(0.1),
                        size: 18,
                      ),
                    ),
                    // Main sparkle decoration (more visible)
                    Positioned(
                      left: 18,
                      top: 18,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                    // Top shine effect
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Title text on the left
                    Positioned(
                      left: 24,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Text outline
                              Text(
                                widget.title,
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 32,
                                  height: 1.0,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 5
                                    ..color = Colors.black.withOpacity(0.3),
                                ),
                              ),
                              // Main text
                              Text(
                                widget.title,
                                style: GoogleFonts.luckiestGuy(
                                  fontSize: 32,
                                  height: 1.0,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
