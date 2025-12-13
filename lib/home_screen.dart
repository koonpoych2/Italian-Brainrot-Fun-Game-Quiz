import 'package:brainrot_quiz/components/ad_banner.dart';
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
        ],
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}