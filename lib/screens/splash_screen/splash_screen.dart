import 'package:brainrot_quiz/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      // Test Interstitial Ad Unit ID
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // เมื่อโหลดสำเร็จ
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial ad loaded successfully');
          _interstitialAd = ad;
          
          setState(() {
            _isAdLoaded = true;
          });

          // ตั้งค่า callback สำหรับเหตุการณ์ต่างๆ
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            // เมื่อโฆษณาแสดงเต็มจอ
            onAdShowedFullScreenContent: (ad) {
              debugPrint('📺 Interstitial ad showed full screen');
            },
            // เมื่อโฆษณาถูกปิด
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('❌ Interstitial ad dismissed');
              ad.dispose();
              _navigateToHome(); // ไปหน้า Home
            },
            // เมื่อเกิด error ขณะแสดงโฆษณา
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('⚠️ Interstitial ad failed to show: $error');
              ad.dispose();
              _navigateToHome(); // ไปหน้า Home ถึงแม้โฆษณาจะไม่แสดง
            },
          );

          // แสดงโฆษณาหลังจากโหลดเสร็จ 1 วินาที
          Future.delayed(const Duration(seconds: 1), () {
            _showInterstitialAd();
          });
        },
        // เมื่อโหลดไม่สำเร็จ
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial ad failed to load: $error');
          // ถ้าโหลดไม่สำเร็จ รอ 2 วินาทีแล้วไปหน้า Home เลย
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
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo หรือชื่อแอป
            const Icon(
              Icons.quiz,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text(
              'Brainrot Quiz',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // Loading indicator
            if (!_isAdLoaded)
              const Column(
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}