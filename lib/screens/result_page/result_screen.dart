import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/components/ad_banner.dart';
import 'package:brainrot_quiz/home_screen.dart';
import 'package:brainrot_quiz/providers/app_state_provider.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:brainrot_quiz/services/rewarded_ad_manager.dart';
import 'package:brainrot_quiz/widgets/page_background.dart';
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

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  bool _isNewHighScore = false;
  final RewardedAdManager _adManager = RewardedAdManager();
  bool _isAdReady = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadAd();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Save score and earn coins after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveResults();
    });
  }

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
    _adManager.showRewardedAd(
      context: context,
      onRewarded: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🎁 Phoenix Revive!'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizImgScreen(
              initialIndex: widget.failedQuestionIndex,
              initialScore: widget.score,
            ),
          ),
        );
      },
      onAdClosed: () {
        setState(() {
          _isAdReady = false;
        });
        _loadAd();
      },
    );
  }

  Future<void> _saveResults() async {
    final appState = context.read<AppStateProvider>();
    _isNewHighScore = widget.score > appState.highScore;
    await appState.onQuizComplete(widget.score, widget.maxScore);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _player.dispose();
    _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isClear = widget.maxScore == widget.score;
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: double.infinity),

                // Result Title and Score
                _buildResultHeader(isClear, appState),

                // Correct Answer Section
                _buildCorrectAnswerSection(),

                // Action Buttons
                _buildActionButtons(isClear),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }

  Widget _buildResultHeader(bool isClear, AppStateProvider appState) {
    return Column(
      children: [
        // Stars decoration
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.yellow[300], size: 24),
            const SizedBox(width: 8),
            Icon(
              Icons.auto_awesome,
              color: Colors.white.withOpacity(0.9),
              size: 20,
            ),
            const SizedBox(width: 8),
            Icon(Icons.star, color: Colors.yellow[300], size: 24),
          ],
        ),
        const SizedBox(height: 12),

        // WIN/LOSE Title
        Stack(
          alignment: Alignment.center,
          children: [
            // Shadow
            Transform.translate(
              offset: const Offset(3, 3),
              child: Text(
                isClear ? 'YOU WIN!' : 'YOU LOSE',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 42,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            // Outline
            Text(
              isClear ? 'YOU WIN!' : 'YOU LOSE',
              style: GoogleFonts.luckiestGuy(
                fontSize: 42,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = isClear
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF8B4513),
              ),
            ),
            // Gradient fill
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isClear
                    ? [
                        const Color(0xFF4CAF50),
                        const Color(0xFF8BC34A),
                        const Color(0xFFCDDC39),
                      ]
                    : [
                        const Color(0xFFFFD700),
                        const Color(0xFFFFA500),
                        const Color(0xFFFF8C00),
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: Text(
                isClear ? 'YOU WIN!' : 'YOU LOSE',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 42,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Score display
        _buildScoreCard(),

        const SizedBox(height: 12),

        // High Score Container
        _buildHighScoreCard(appState),
      ],
    );
  }

  Widget _buildScoreCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B59B6).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
              const Color(0xFFE0E0E0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score with gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFA500),
                    Color(0xFFFF8C00),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  '${widget.score}',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '/${widget.maxScore}',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 32,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighScoreCard(AppStateProvider appState) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _isNewHighScore
                ? Colors.amber.withOpacity(0.4)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isNewHighScore ? Colors.amber : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isNewHighScore ? Icons.star : Icons.emoji_events,
              color: _isNewHighScore ? Colors.amber : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _isNewHighScore
                  ? 'New High Score!'
                  : 'High Score: ${appState.highScore}',
              style: GoogleFonts.luckiestGuy(
                fontSize: _isNewHighScore ? 18 : 16,
                color: _isNewHighScore ? Colors.amber[700] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectAnswerSection() {
    return Column(
      children: [
        // Title
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              'CORRECT ANSWER',
              style: GoogleFonts.luckiestGuy(
                fontSize: 22,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.white,
              ),
            ),
            Text(
              'CORRECT ANSWER',
              style: GoogleFonts.luckiestGuy(
                fontSize: 22,
                color: const Color(0xFFE76F51),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Answer container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF81C784),
                  Colors.white.withOpacity(0.9),
                  const Color(0xFF4CAF50),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFA5D6A7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildAnswerContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerContent() {
    if (widget.correctAnswerType == "image") {
      return Image.asset("assets/${widget.correctAnswer}", fit: BoxFit.cover);
    } else if (widget.correctAnswerType == "text") {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            widget.correctAnswer,
            style: GoogleFonts.luckiestGuy(
              fontSize: 24,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () async {
          await _player.stop();
          await _player.play(AssetSource(widget.correctAnswer));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF9B59B6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B59B6).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildActionButtons(bool isClear) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStyledButton(
          text: 'HOME',
          color: const Color(0xFF9B59B6),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
        if (isClear)
          _buildStyledButton(
            text: 'RETRY',
            color: const Color(0xFF1ABC9C),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const QuizImgScreen()),
              );
            },
          )
        else if (_isAdReady)
          _buildStyledButton(
            text: 'RETRY',
            color: const Color(0xFFF1C40F),
            icon: Icons.videocam_rounded,
            onPressed: _watchAdForHealth,
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Loading...',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStyledButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    final lighterColor = Color.lerp(color, Colors.white, 0.5)!;
    final darkerColor = Color.lerp(color, Colors.black, 0.2)!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
              colors: [
                lighterColor,
                Colors.white.withOpacity(0.9),
                darkerColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 22,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
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
