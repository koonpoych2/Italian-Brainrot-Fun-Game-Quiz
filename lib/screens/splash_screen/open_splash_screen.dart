import 'package:all_in_one_brainrot/home_screen.dart';
import 'package:all_in_one_brainrot/widgets/page_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-4822776885970693/3597334696',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          setState(() {
            _isAdLoaded = true;
          });

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdShowedFullScreenContent: (ad) {},
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                  _navigateToHome();
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  ad.dispose();
                  _navigateToHome();
                },
              );

          Future.delayed(const Duration(seconds: 2), () {
            _showInterstitialAd();
          });
        },
        onAdFailedToLoad: (error) {
          Future.delayed(const Duration(seconds: 2), () {
            _navigateToHome();
          });
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sparkle decorations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow[300], size: 28),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.star, color: Colors.yellow[300], size: 28),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Main Title - BRAINROT
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Shadow
                      Transform.translate(
                        offset: const Offset(3, 3),
                        child: Text(
                          'BRAINROT',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 52,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                      // Dark outline
                      Text(
                        'BRAINROT',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 52,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 10
                            ..color = const Color(0xFF8B4513),
                        ),
                      ),
                      // Gradient fill
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
                          'BRAINROT',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 52,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Subtitle - QUIZ
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'QUIZ',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 36,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 8
                            ..color = Colors.white,
                        ),
                      ),
                      Text(
                        'QUIZ',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 36,
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

                  const SizedBox(height: 8),

                  // Decorative line
                  Container(
                    width: 150,
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

                  const SizedBox(height: 60),

                  // Loading indicator
                  if (!_isAdLoaded) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Loading...',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
