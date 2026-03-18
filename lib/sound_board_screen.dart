import 'dart:ui';

import 'package:all_in_one_brainrot/components/ad_banner.dart';
import 'package:all_in_one_brainrot/data/sound_board_data.dart';
import 'package:all_in_one_brainrot/widgets/page_background.dart';
import 'package:all_in_one_brainrot/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'package:all_in_one_brainrot/services/rewarded_ad_manager.dart';

class SoundBoardScreen extends StatefulWidget {
  const SoundBoardScreen({super.key});

  @override
  State<SoundBoardScreen> createState() => _SoundBoardScreenState();
}

class _SoundBoardScreenState extends State<SoundBoardScreen> {
  final AudioPlayer _player = AudioPlayer();
  int get _totalSounds => SoundBoardData.totalItems;
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
            _onAdReadyCallback = () {
              if (dialogContext.mounted) {
                setDialogState(() {});
              }
            };

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Unlock Sound',
                style: GoogleFonts.luckiestGuy(color: const Color(0xFFE76F51)),
              ),
              content: const Text(
                'Watch a video ad to unlock this sound?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _onAdReadyCallback = null;
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                if (_isAdReady)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9B59B6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _onAdReadyCallback = null;
                      _adManager.showRewardedAd(
                        context: context,
                        onRewarded: () async {
                          final success = await appState.unlockSound(index);
                          Navigator.pop(ctx);

                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Sound unlocked! 🎉'),
                                backgroundColor: Colors.green[600],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                        Text('Loading ads...', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    ).then((_) {
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
      body: PageBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              CustomHeader(
                title: 'Sound Board',
                onHomeTap: () => Navigator.pop(context),
              ),

              // Scrollable sound grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: List.generate(_totalSounds, (index) {
                      final isUnlocked = appState.isSoundUnlocked(index);

                      return GestureDetector(
                        onTap: isUnlocked
                            ? () => _playSound(SoundBoardData.sounds[index])
                            : () => _showUnlockDialog(context, index),
                        child: _buildSoundCard(index, isUnlocked),
                      );
                    }),
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

  Widget _buildSoundCard(int index, bool isUnlocked) {
    // Create different colors for cards
    final colors = [
      const Color(0xFF9B59B6), // Purple
      const Color(0xFF1ABC9C), // Teal
      const Color(0xFFF1C40F), // Yellow
      const Color(0xFFE74C3C), // Red
      const Color(0xFF3498DB), // Blue
    ];
    final cardColor = colors[index % colors.length];
    final lighterColor = Color.lerp(cardColor, Colors.white, 0.6)!;
    final darkerColor = Color.lerp(cardColor, Colors.black, 0.3)!;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [lighterColor, Colors.white.withOpacity(0.9), darkerColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Stack(
              children: [
                // Background image - use the correct image for this index
                Positioned.fill(
                  child: Image.asset(SoundBoardData.images[index], fit: BoxFit.cover),
                ),
                // Blur effect and overlay for locked items
                if (!isUnlocked) ...[
                  // Blur effect
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  // Semi-transparent black overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                  ),
                  // Lock icon and number
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          color: Colors.white.withOpacity(0.95),
                          size: 36,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${index + 1}',
                          style: GoogleFonts.luckiestGuy(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Video ad indicator
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
                // Play icon overlay for unlocked
                if (isUnlocked)
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
