import 'package:brainrot_quiz/components/ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'widgets/outlined_title_text.dart';
import 'package:brainrot_quiz/services/rewarded_ad_manager.dart';

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
  final RewardedAdManager _adManager = RewardedAdManager();
  bool _isAdReady = false;
  VoidCallback? _onAdReadyCallback;
  
  Future<void> _playSound(String path) async {
    await _player.stop();
    await _player.play(AssetSource(path));
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

void _loadAd() {
    _adManager.loadRewardedAd(
      onAdLoaded: () {
        setState(() {
          _isAdReady = true;
        });
        // เรียก callback ถ้ามี (กรณี dialog เปิดอยู่)
        _onAdReadyCallback?.call();
      },
    );
  }
  void _showUnlockDialog(BuildContext context, int index) {
    final appState = context.read<AppStateProvider>();
    
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter setDialogState) {
            // ตั้ง callback ให้อัพเดท dialog state
            _onAdReadyCallback = () {
              if (dialogContext.mounted) {
                setDialogState(() {
                  // trigger rebuild
                });
              }
            };

            return AlertDialog(
              title: Text('Unlock Sound', style: GoogleFonts.luckiestGuy()),
              content: const Text(
                'Watch a video ad to unlock this sound?\n\n(Video ads will be added by your friend)',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _onAdReadyCallback = null; // clear callback
                    Navigator.pop(ctx);
                  },
                  child: const Text('Cancel'),
                ),
                if (_isAdReady)
                  ElevatedButton(
                    onPressed: () {
                      _onAdReadyCallback = null; // clear callback

                    _adManager.showRewardedAd(
                      context: context,
                      onRewarded: () async {
                        final success = await appState.unlockSound(index);
                        Navigator.pop(ctx);

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sound unlocked! (Video ad will play here)'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        

                      },
                      onAdClosed: () {
                        setState(() {
                          _isAdReady = false;
                        });
                        _loadAd();
                      },
                    );


                    },
                    child: const Text('Watch Ad & Unlock'),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'กำลังโหลดโฆษณา...',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // เมื่อปิด dialog แล้ว clear callback
      _onAdReadyCallback = null;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _onAdReadyCallback = null;
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

          ],
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
