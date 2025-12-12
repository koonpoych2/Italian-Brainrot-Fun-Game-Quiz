import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/components/text_show.dart';
import 'package:brainrot_quiz/home_screen.dart';
import 'package:brainrot_quiz/providers/app_state_provider.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:brainrot_quiz/services/rewarded_ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final String correctAnswer;
  final String correctAnswerType;
  final int score;
  final int maxScore;
  final int failedQuestionIndex;

  const ResultScreen({
    super.key,
    required this.correctAnswer,
    required this.score,
    required this.correctAnswerType,
    required this.maxScore,
    this.failedQuestionIndex = 0,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final AudioPlayer _player;
  bool _isNewHighScore = false;
  final RewardedAdManager _adManager = RewardedAdManager();
  bool _isAdReady = false;


void _loadAd() {
    _adManager.loadRewardedAd(
      onAdLoaded: () {
        setState(() {
          _isAdReady = true;
        });
      },
    );
  }

  void _watchAdForHealth() {
    debugPrint('ทำงานแล้ว');
    _adManager.showRewardedAd(
      context: context,
      // เมื่อดูโฆษณาจนจบ -> ได้รับรางวัล
      onRewarded: () {
        // setState(() {
        //   _health = (_health + 25).clamp(0, _maxHealth); // เพิ่มเลือด 25
        // });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎁 Pheonix !'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizImgScreen(
              initialIndex: widget.failedQuestionIndex, // เริ่มที่ข้อเดิม
              initialScore: widget.score, // คะแนนเท่าเดิม
            ),
          ),
        );
      },
      // เมื่อปิดโฆษณา (ไม่ว่าจะได้รับรางวัลหรือไม่)
      onAdClosed: () {
        setState(() {
          _isAdReady = false;
        });
        debugPrint('Rewarded ad closed');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Save score and earn coins after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveResults();
    });
  }

  Future<void> _saveResults() async {
    final appState = context.read<AppStateProvider>();

    // Check if this is a new high score
    _isNewHighScore = widget.score > appState.highScore;

    // Save results to persistent storage
    await appState.onQuizComplete(widget.score, widget.maxScore);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _adManager.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    bool isclear = widget.maxScore == widget.score;
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFA867),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 1000),

            // Result Title and Score
            Column(
              children: [
                Stack(
                  children: [
                    TextShow(
                      title: isclear ? 'YOU WIN' : 'YOU LOSE',
                      backgroundColor: Colors.white,
                      mainTextSize: 54,
                      mainbackgroundColor: const Color(0xFFE76F51),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextShow(
                  title: '${widget.score}/${widget.maxScore}',
                  backgroundColor: Colors.black,
                  mainTextSize: 50,
                  mainbackgroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(height: 15),

                // High Score Container
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isNewHighScore ? Icons.star : Icons.emoji_events,
                        color: _isNewHighScore
                            ? Colors.amber
                            : Colors.grey[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isNewHighScore
                            ? 'New High Score!'
                            : 'High Score: ${appState.highScore}',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: _isNewHighScore ? 20 : 18,
                          color: _isNewHighScore
                              ? Colors.amber[700]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Correct Answer Section
            Column(
              children: [
                Text(
                  'CORRECT ANSWER IS',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 112, 236, 116),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    widget.correctAnswerType == "image"
                        ? SizedBox(
                            height: 250,
                            width: 250,
                            child: Image.asset(
                              "assets/${widget.correctAnswer}",
                            ),
                          )
                        : widget.correctAnswerType == "text"
                        ? SizedBox(
                            width: 250,
                            child: Center(
                              child: TextShow(
                                title: widget.correctAnswer,
                                backgroundColor: Colors.black,
                                mainTextSize: 30,
                                mainbackgroundColor: const Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              await _player.stop();
                              await _player.play(
                                AssetSource(widget.correctAnswer),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.volume_up_rounded,
                                color: Colors.black,
                                size: 50,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'HOME',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'RETRY',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => QuizImgScreen()),
                    );
                  },
                ),
              ],
            ),
              if (!isclear) 
                 FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'RETRY ADS',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 25,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  onPressed: () {
                    if (_isAdReady) {
                      _watchAdForHealth(); // ✅ มีวงเล็บเพื่อสั่งทำงาน
                    } else {
                      debugPrint("ไม่จริง");
                    }
                  },
                ),
                
              if (!_isAdReady)
                const Text(
                  'กำลังโหลดโฆษณา...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
          ],
        ),
      ),

      // Bottom Ad Banner
      bottomNavigationBar: Container(
        color: const Color(0xFF2B2B2B),
        padding: EdgeInsets.only(
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        child: const Text(
          'ADS',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 3),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.luckiestGuy(
          fontSize: 25,
          fontWeight: FontWeight.w200,
          color: Colors.black,
          height: 1.1,
        ),
      ),
    );
  }
}
