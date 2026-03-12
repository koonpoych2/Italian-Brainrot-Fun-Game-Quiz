import 'package:all_in_one_brainrot/components/ad_banner.dart';
import 'package:all_in_one_brainrot/services/rewarded_ad_manager.dart';
import 'package:all_in_one_brainrot/widgets/page_background.dart';
import 'package:all_in_one_brainrot/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'data/app_data.dart';
import 'wiki_detail_screen.dart';

class WikiListScreen extends StatefulWidget {
  const WikiListScreen({super.key});

  @override
  State<WikiListScreen> createState() => _WikiListScreenState();
}

class _WikiListScreenState extends State<WikiListScreen> {
  final RewardedAdManager _adManager = RewardedAdManager();
  bool _isAdReady = false;
  VoidCallback? _onAdReadyCallback;

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

  @override
  void initState() {
    super.initState();
    _loadAd();
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
                'Unlock Wiki Item',
                style: GoogleFonts.luckiestGuy(color: const Color(0xFFE76F51)),
              ),
              content: const Text(
                'Watch a video ad to unlock this wiki item?',
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
                      backgroundColor: const Color(0xFFF1C40F),
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
                          final success = await appState.unlockWiki(index);
                          Navigator.pop(ctx);

                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Wiki item unlocked! 🎉'),
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
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              CustomHeader(
                title: "WIKI",
                onHomeTap: () => Navigator.pop(context),
              ),

              // Wiki Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: AppData.wikiItems.length,
                  itemBuilder: (context, index) {
                    final item = AppData.wikiItems[index];
                    final isUnlocked = appState.isWikiUnlocked(index);

                    return GestureDetector(
                      onTap: isUnlocked
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WikiDetailScreen(item: item),
                                ),
                              );
                            }
                          : () => _showUnlockDialog(context, index),
                      child: _buildWikiCard(index, item, isUnlocked),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }

  Widget _buildWikiCard(int index, dynamic item, bool isUnlocked) {
    // Create different colors for cards
    final colors = [
      const Color(0xFFF1C40F), // Yellow
      const Color(0xFF9B59B6), // Purple
      const Color(0xFF1ABC9C), // Teal
      const Color(0xFFE74C3C), // Red
      const Color(0xFF3498DB), // Blue
    ];
    final cardColor = colors[index % colors.length];
    final lighterColor = Color.lerp(cardColor, Colors.white, 0.6)!;
    final darkerColor = Color.lerp(cardColor, Colors.black, 0.3)!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
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
            color: isUnlocked ? Colors.white : cardColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Background image for unlocked
                if (isUnlocked)
                  Positioned.fill(
                    child: Hero(
                      tag: item.name,
                      child: Image.asset('assets/${item.imgPath}', fit: BoxFit.cover),
                    ),
                  ),
                // Locked overlay
                if (!isUnlocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cardColor.withOpacity(0.8), cardColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${index + 1}',
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Video ad indicator for locked
                if (!isUnlocked)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red[600],
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.videocam_rounded,
                        color: Colors.white,
                        size: 12,
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
