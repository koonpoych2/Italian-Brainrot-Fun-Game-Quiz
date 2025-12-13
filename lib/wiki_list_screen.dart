import 'package:brainrot_quiz/components/ad_banner.dart';
import 'package:brainrot_quiz/services/rewarded_ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'data/app_data.dart';
import 'widgets/custom_header.dart';
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
        // เรียก callback ถ้ามี (กรณี dialog เปิดอยู่)
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
              setDialogState(() {
                // trigger rebuild
              });
            }
          };

          return AlertDialog(
            title: Text('Unlock Wiki Item', style: GoogleFonts.luckiestGuy()),
            content: const Text(
              'Watch a video ad to unlock this wiki item?\n\n(Video ads will be added by your friend)',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              if (_isAdReady)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Your friend will add video ad here
                    // After watching ad, unlock the wiki item
                      _onAdReadyCallback = null; // clear callback

                    _adManager.showRewardedAd(
                      context: context,
                      onRewarded: () async {
                        final success = await appState.unlockWiki(index);
                        Navigator.pop(ctx);

                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wiki item unlocked! (Video ad will play here)'),
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
                          'loading ads...',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
            ],
          );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
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
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
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
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: isUnlocked
                                ? Hero(
                                    tag: item.name,
                                    child: Image.asset(
                                      item.imgPath,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    color: Colors.black.withOpacity(0.8),
                                    child: const Center(
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 40,
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
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
