import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'home_card.dart';
import 'sound_board_screen.dart';
import 'wiki_list_screen.dart';
import 'screens/debug_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      // 1. กำหนด Ad Unit ID (ตอนนี้ใช้ Test ID)
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      // 2. กำหนดขนาดโฆษณา
      size: AdSize.banner,
      // 3. ส่ง request ไปขอโฆษณาจาก Google
      request: const AdRequest(),
      // 4. Listener สำหรับฟังเหตุการณ์ต่างๆ
      listener: BannerAdListener(

        onAdLoaded: (ad) {
          // เช็คว่า widget ยังคงอยู่ในหน้าจอหรือไม่
          if (mounted) {
            setState(() {
              _isBannerAdLoaded = true;
            });
          }
          debugPrint('✅ Banner ad loaded successfully');
        },

        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed to load: $error');
          ad.dispose(); // ทำลาย ad object ที่โหลดไม่สำเร็จ
          if (mounted) {
            setState(() {
              _isBannerAdLoaded = false;
            });
          }
        },
      ),
    );

    _bannerAd?.load(); // เริ่มโหลดโฆษณา
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // ทำลาย ad object เพื่อประหยัด memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          // Debug Button
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DebugScreen()),
              );
            },
            tooltip: 'Debug & Testing',
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Column(
                children: const [
                  MenuCard(
                    title: "QUIZ",
                    backgroundColor: Color(0xFF8B6FD8),
                    destination: QuizImgScreen(),
                    icon: Icons.lightbulb_outline,
                  ),
                  SizedBox(height: 50),
                  MenuCard(
                    title: "SOUND\nBOARD",
                    backgroundColor: Color(0xFF3FA89A),
                    destination: SoundBoardScreen(),
                    icon: null,
                  ),
                  SizedBox(height: 50),
                  MenuCard(
                    title: "WIKI",
                    backgroundColor: Color(0xFFE9C46A),
                    destination: WikiListScreen(),
                    icon: Icons.language,
                  ),
                ],
              ),
            ),
          ),
          // Banner Ad Container
          if (_isBannerAdLoaded && _bannerAd != null)
            Container(
              color: const Color(0xFF2B2B2B),
              width: double.infinity,
              height: 60,
              child: Center(
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),  // ความกว้างของโฆษณา
                  height: _bannerAd!.size.height.toDouble(), // ความสูงของโฆษณา
                  child: AdWidget(ad: _bannerAd!), // Widget สำหรับแสดงโฆษณา
                ),
              ),
            )
          else
            Container(
              color: const Color(0xFF2B2B2B),
              width: double.infinity,
              height: 60,
              child: const Center(
                child: CircularProgressIndicator( // แสดงวงกลมหมุนขณะโหลด
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}