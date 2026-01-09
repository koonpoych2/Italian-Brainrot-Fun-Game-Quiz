import 'package:brainrot_quiz/components/ad_banner.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_card.dart';
import 'sound_board_screen.dart';
import 'wiki_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB347), // Warm orange
              Color(0xFFFFA867), // Main orange
              Color(0xFFFF8C42), // Deeper orange
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Animated App Title Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AnimatedBuilder(
                  animation: _titleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _titleAnimation.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      // Decorative top element
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.yellow[300], size: 24),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.9),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.star, color: Colors.yellow[300], size: 24),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Main Title with layered effect
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Shadow layer
                          Text(
                            'BRAINROT',
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 42,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ).translate(offset: const Offset(3, 3)),
                          // Outline layer
                          Text(
                            'BRAINROT',
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 42,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 8
                                ..color = const Color(0xFF8B4513),
                            ),
                          ),
                          // Main text
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFFD700), // Gold
                                Color(0xFFFFA500), // Orange
                                Color(0xFFFF6347), // Tomato
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: Text(
                              'BRAINROT',
                              style: GoogleFonts.luckiestGuy(
                                fontSize: 42,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Subtitle
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'QUIZ',
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.white,
                            ),
                          ),
                          Text(
                            'QUIZ',
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 28,
                              color: const Color(0xFFE76F51),
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
                      const SizedBox(height: 4),
                      // Decorative line
                      Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Menu Cards
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      // Staggered animation for cards
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: const MenuCard(
                          title: "QUIZ",
                          backgroundColor: Color(0xFF9B59B6), // Purple
                          destination: QuizImgScreen(),
                          icon: Icons.lightbulb_outline,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: const MenuCard(
                          title: "SOUND\nBOARD",
                          backgroundColor: Color(0xFF1ABC9C), // Teal
                          destination: SoundBoardScreen(),
                          icon: Icons.music_note,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: const MenuCard(
                          title: "WIKI",
                          backgroundColor: Color(0xFFF1C40F), // Yellow
                          destination: WikiListScreen(),
                          icon: Icons.menu_book,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}

// Extension to easily translate widgets
extension TranslateExtension on Widget {
  Widget translate({required Offset offset}) {
    return Transform.translate(offset: offset, child: this);
  }
}
