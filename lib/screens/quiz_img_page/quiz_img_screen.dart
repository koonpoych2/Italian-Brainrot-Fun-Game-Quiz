import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/components/ad_banner.dart';
import 'package:brainrot_quiz/components/text_show.dart';
import 'package:brainrot_quiz/constants.dart';
import 'package:brainrot_quiz/models/quize.dart';
import 'package:brainrot_quiz/models/quize_img_data.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/components/answerCard.dart';
import 'package:brainrot_quiz/screens/result_page/result_screen.dart';
import 'package:brainrot_quiz/services/timer_service.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFFFA867),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),

        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${_seconds.toString()}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "s",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${questionIndex + 1}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "/${_questionList.length}",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        elevation: 0,
      ),

      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: kDefaultPaddin, bottom: 10,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child:
                    ["sound-text", "sound-image"].contains(question.questionType)
                    ? GestureDetector(
                        onTap: () async {
                          await _player.stop();
                          await _player.play(AssetSource(question.question));
                        },
                        child: Align(
                          child: Stack(
                            alignment : Alignment.center,
                            children: [
                              Image.asset("assets/images/sound_disk.png"),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.black,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset("assets/${question.question}"),
                      ),
              ),
        
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const crossAxisCount = 2;
                          const crossSpacing = 10.0;
                          const mainSpacing = 10.0;
        
                          // จำนวนแถวตามจำนวนตัวเลือก
                          final rows = (question.options.length / crossAxisCount)
                              .ceil();
        
                          // คำนวณขนาดช่องให้พอดีกับพื้นที่
                          final itemWidth =
                              (constraints.maxWidth -
                                  (crossAxisCount - 1) * crossSpacing) /
                              crossAxisCount;
                          final itemHeight =
                              (constraints.maxHeight - (rows - 1) * mainSpacing) /
                              rows;
        
                          final childAspectRatio = itemWidth / itemHeight;
        
                          return GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // ❗ ไม่ให้ scroll
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                  if ([
                                    "image-sound",
                                  ].contains(question.questionType)) {
                                    await _player.stop();
                                    await _player.play(
                                      AssetSource(question.options[index]),
                                    );
                                  }
                                },
                                child: Answercard(
                                  questionOption: question.options[index],
                                  questionOptionType: question.questionType,
                                  isSelected: selectAnswerIndex != null,
                                  currentAnswerIndex: index,
                                  selectAnswerIndex: tempSelectAnswerIndex,
                                  correctAnswerIndex: question.correctAnswerIndex,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
        
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity, 
                        child: FilledButton(
                          onPressed: () {
                            submitAnswer();
                          },
                          child: TextShow(
                            title: 'OK',
                            backgroundColor: Colors.black,
                            mainTextSize: 20,
                            mainbackgroundColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdBannerWidget(),
    );
  }
}
