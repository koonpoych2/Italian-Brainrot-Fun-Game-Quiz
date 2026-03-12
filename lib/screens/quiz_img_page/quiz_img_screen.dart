import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:all_in_one_brainrot/components/ad_banner.dart';
import 'package:all_in_one_brainrot/components/text_show.dart';
import 'package:all_in_one_brainrot/constants.dart';
import 'package:all_in_one_brainrot/models/quize.dart';
import 'package:all_in_one_brainrot/models/quize_img_data.dart';
import 'package:all_in_one_brainrot/screens/quiz_img_page/components/answerCard.dart';
import 'package:all_in_one_brainrot/screens/result_page/result_screen.dart';
import 'package:all_in_one_brainrot/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Card colors matching home page style
const List<Color> _cardColors = [
  Color(0xFF9B59B6), // Purple
  Color(0xFF1ABC9C), // Teal
  Color(0xFFF1C40F), // Yellow
  Color(0xFFE74C3C), // Red
];

class QuizImgScreen extends StatefulWidget {
  final int initialIndex;
  final int initialScore;

  const QuizImgScreen({
    super.key, 
    this.initialIndex = 0, // ค่า default คือ 0 (เล่นใหม่)
    this.initialScore = 0, // ค่า default คือ 0
  });

  @override
  State<QuizImgScreen> createState() => _QuizImgScreenState();
}

class _QuizImgScreenState extends State<QuizImgScreen> {
  late final List<Question> _questionList;
  late final AudioPlayer _player;
  int? tempSelectAnswerIndex = null;
  int? selectAnswerIndex = null;

  late int score;
  late int questionIndex;

  @override
  void initState() {
    super.initState();

    score = widget.initialScore;
    questionIndex = widget.initialIndex;

    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _questionList = buildImgQuestions(optionsPerQuestion: 4);
    _startCountDown(); // เริ่มครั้งแรกที่หน้าเปิด ต่อให้เรียก setState() ก็จะไม่ทำฟังก์ชั่นนี้จะทำแค่ครั้งแรกที่ถูกสร้าางหน้านี้
  }

  @override
  void dispose() {
    _timerService.cancel(); // ล้าง timer เมื่อออกหน้า
    _player.dispose();
    super.dispose();
  }

  void neviResultPaeg() {
    String answerType = "image";
    String answerCurrent = _questionList[questionIndex]
        .options[_questionList[questionIndex].correctAnswerIndex];
    if (_questionList[questionIndex].questionType.contains('-text')) {
      answerType = "text";
    } else if (_questionList[questionIndex].questionType.contains('-sound')) {
      answerType = "sound";
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctAnswer: answerCurrent,
          score: score,
          maxScore: _questionList.length,
          correctAnswerType: answerType,
          failedQuestionIndex: questionIndex,
        ),
      ),
    );
  }

  void pickAnswer(int value) {
    tempSelectAnswerIndex = value;
  }

  void submitAnswer() {
    selectAnswerIndex = tempSelectAnswerIndex;
    final correctIndex = _questionList[questionIndex].correctAnswerIndex;
    if (selectAnswerIndex == correctIndex) {
      score++;
      nextQuestion();
    } else {
      neviResultPaeg();
    }
    setState(() {});
  }

  void nextQuestion() {
    _timerService.cancel();
    tempSelectAnswerIndex = null;
    if (questionIndex < _questionList.length - 1) {
      questionIndex++;
      selectAnswerIndex = null;

      _startCountDown();
    } else {
      // result page
      neviResultPaeg();
    }
  }

  void resultPage() {}

  // Timer Part
  final TimerService _timerService = TimerService();
  int _seconds = 10;
  bool _isRunning = false;

  void _startCountDown() {
    setState(() {
      _isRunning = true;
    });

    _timerService.start(
      seconds: 60,
      onTick: (remaind) {
        setState(() {
          _seconds = remaind;
        });
      },
      onFinished: () {
        setState(() {
          _isRunning = false;
        });

        if (selectAnswerIndex == null) {
          neviResultPaeg();
        }
        nextQuestion();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questionList[questionIndex];
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildTimerWidget(),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildProgressWidget(),
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFB347), // Warm orange
              Color(0xFFFFA867), // Main orange
              Color(0xFFFF8C42), // Deeper orange
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Question Card
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: _buildQuestionContent(question),
                      ),
                    ),
                  ),
                ),

                // Answer Options
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const crossAxisCount = 2;
                            const crossSpacing = 12.0;
                            const mainSpacing = 12.0;

                            final rows = (question.options.length / crossAxisCount).ceil();
                            final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * crossSpacing) / crossAxisCount;
                            final itemHeight = (constraints.maxHeight - (rows - 1) * mainSpacing) / rows;
                            final childAspectRatio = itemWidth / itemHeight;

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: crossSpacing,
                                mainAxisSpacing: mainSpacing,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemCount: question.options.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    pickAnswer(index);
                                    setState(() {});
                                    if (["image-sound"].contains(question.questionType)) {
                                      await _player.stop();
                                      await _player.play(AssetSource(question.options[index]));
                                    }
                                  },
                                  child: _buildStyledAnswerCard(question, index),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Submit Button
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }

  Widget _buildTimerWidget() {
    final isLowTime = _seconds <= 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            color: isLowTime ? const Color(0xFFE74C3C) : const Color(0xFF8B4513),
            size: 22,
          ),
          const SizedBox(width: 6),
          Text(
            "${_seconds}s",
            style: GoogleFonts.luckiestGuy(
              fontSize: 20,
              color: isLowTime ? const Color(0xFFE74C3C) : const Color(0xFF8B4513),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${questionIndex + 1}",
            style: GoogleFonts.luckiestGuy(
              fontSize: 18,
              color: const Color(0xFF9B59B6),
            ),
          ),
          Text(
            " / ${_questionList.length}",
            style: GoogleFonts.luckiestGuy(
              fontSize: 16,
              color: const Color(0xFF8B4513).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(Question question) {
    if (["sound-text", "sound-image"].contains(question.questionType)) {
      return GestureDetector(
        onTap: () async {
          await _player.stop();
          await _player.play(AssetSource(question.question));
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "assets/images/sound_disk.png",
                  width: 150,
                  height: 150,
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9B59B6).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Image.asset(
          "assets/${question.question}",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildStyledAnswerCard(Question question, int index) {
    final isSelected = tempSelectAnswerIndex == index;
    final cardColor = _cardColors[index % _cardColors.length];

    // Create darker shade for gradient
    final darkerColor = HSLColor.fromColor(cardColor)
        .withLightness((HSLColor.fromColor(cardColor).lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor, darkerColor],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          width: isSelected ? 4 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(isSelected ? 0.6 : 0.4),
            blurRadius: isSelected ? 20 : 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Answer content (rendered first, at bottom)
          Center(
            child: Answercard(
              questionOption: question.options[index],
              questionOptionType: question.questionType,
              isSelected: selectAnswerIndex != null,
              currentAnswerIndex: index,
              selectAnswerIndex: tempSelectAnswerIndex,
              correctAnswerIndex: question.correctAnswerIndex,
            ),
          ),
          // Selection indicator (rendered last, on top)
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: cardColor,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9B59B6).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: submitAnswer,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SUBMIT',
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
