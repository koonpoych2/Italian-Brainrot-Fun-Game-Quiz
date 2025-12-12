import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'widgets/outlined_title_text.dart';

final images = ['assets/images/burbaloni_lulliloli.png'];

final sounds = ['sounds/burbaloni_lulliloli.mp3'];

class SoundBoardScreen extends StatefulWidget {
  const SoundBoardScreen({super.key});

  @override
  State<SoundBoardScreen> createState() => _SoundBoardScreenState();
}

class _SoundBoardScreenState extends State<SoundBoardScreen> {
  final AudioPlayer _player = AudioPlayer();
  static const int _totalSounds = 20;

  Future<void> _playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  void _showUnlockDialog(BuildContext context, int index) {
    final appState = context.read<AppStateProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Unlock Sound', style: GoogleFonts.luckiestGuy()),
        content: const Text(
          'Watch a video ad to unlock this sound?\n\n(Video ads will be added by your friend)',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Your friend will add video ad here
              // After watching ad, unlock the sound
              final success = await appState.unlockSound(index);
              Navigator.pop(ctx);

              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Sound unlocked! (Video ad will play here)',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: const Text('Watch Ad & Unlock'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const OutlinedTitleText(text: 'Sound \nBoard'),
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

            // Scrollable sound grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(_totalSounds, (index) {
                    final isUnlocked = appState.isSoundUnlocked(index);

                    return GestureDetector(
                      onTap: isUnlocked
                          ? () => _playSound(sounds[0])
                          : () => _showUnlockDialog(context, index),
                      child: Stack(
                        children: [
                          Container(
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
                              child: isUnlocked
                                  ? Image.asset(images[0], fit: BoxFit.cover)
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
                          // Show video ad icon on locked items
                          if (!isUnlocked)
                            Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red[700],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Bottom bar
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
