import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'widgets/outlined_title_text.dart';

final images = [
  'assets/images/burbaloni_lulliloli.png',
];

final sounds = [
  'sounds/burbaloni_lulliloli.mp3',
];

final unlockedCount = 3;

class SoundBoardScreen extends StatefulWidget {
  const SoundBoardScreen({super.key});

  @override
  State<SoundBoardScreen> createState() => _SoundBoardScreenState();
}

class _SoundBoardScreenState extends State<SoundBoardScreen> {
  final AudioPlayer _player = AudioPlayer();


  final _soundItems = List.generate(20, (index) => {
    'unlocked': index < unlockedCount,
    'file': sounds[0],
    'image': images[0],
  });

  Future<void> _playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
        child: Column(
          children: [
            // 🏠 Header section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Centered title
                  OutlinedTitleText(text: 'Sound \nBoard'),
                  // Left-aligned home button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.home,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🎵 Scrollable sound grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: _soundItems.map((item) {
                    return GestureDetector(
                      onTap: item['unlocked'] == true
                          ? () => _playSound(item['file'] as String)
                          : null,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: item['unlocked'] == true
                              ? Image.asset(
                            item['image'] as String,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.black.withOpacity(0.8),
                            child: const Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // 📢 Bottom bar
            Container(
              color: const Color(0xFF2B2B2B),
              width: double.infinity,
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
      ),
    );
  }
}
