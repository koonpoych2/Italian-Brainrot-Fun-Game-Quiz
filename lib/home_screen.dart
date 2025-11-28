import 'package:flutter/material.dart';
import 'home_card.dart';
import 'test_screen.dart';
import 'sound_board_screen.dart';
import 'wiki_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
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
                    // imagePath: 'assets/mammoth.png', // Replace with your image
                    destination: PlaceholderScreen(title: "Quiz"), // Your destination screen
                    icon: Icons.lightbulb_outline,
                  ),
                  SizedBox(height: 50),
                  MenuCard(
                    title: "SOUND\nBOARD",
                    backgroundColor: Color(0xFF3FA89A),
                    // imagePath: 'assets/robot.png', // Replace with your image
                    destination: SoundBoardScreen(),
                    icon: null,
                  ),
                  SizedBox(height: 50),
                  MenuCard(
                    title: "WIKI",
                    backgroundColor: Color(0xFFE9C46A),
                    // imagePath: 'assets/monkey.png', // Replace with your image
                    destination: WikiListScreen(),
                    icon: Icons.language,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFF2B2B2B),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Center(
              child: Text(
                'ADS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
