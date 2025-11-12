import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:brainrot_quiz/constants.dart';
import 'package:brainrot_quiz/models/quize.dart';
import 'package:brainrot_quiz/models/quize_img_data.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/components/answerCard.dart';
import 'package:brainrot_quiz/screens/result_page/result_screen.dart';
import 'package:brainrot_quiz/services/timer_service.dart';
import 'package:flutter/material.dart';

class QuizImgScreen extends StatefulWidget {
  const QuizImgScreen({super.key});

  @override
  State<QuizImgScreen> createState() => _QuizImgScreenState();
}

class _QuizImgScreenState extends State<QuizImgScreen> {
  late final AudioPlayer _player;
  int? tempSelectAnswerIndex = null;
  int? selectAnswerIndex = null;
  int score = 0;
  int questionIndex = 0;

  void neviResultPaeg(){
    
    String answerType = "image";
    String answerCurrent = questionList[questionIndex].options[questionList[questionIndex].correctAnswerIndex];
    if ( questionList[questionIndex].questionType.contains('-text') ) {
      answerType = "text";
    }
    else if ( questionList[questionIndex].questionType.contains('-sound') ) {
      answerType = "sound";
    }


    Navigator.pushReplacement(
    context, 
    MaterialPageRoute(
      builder: (context) => ResultScreen(
        correctAnswer: answerCurrent, 
        score: score,
        maxScore: questionList.length,
        correctAnswerType: answerType,
      )
      )
  );

  }

  void pickAnswer(int value) {
    tempSelectAnswerIndex = value;
  }

  void submitAnswer() {
    selectAnswerIndex = tempSelectAnswerIndex;
    final correctIndex = questionList[questionIndex].correctAnswerIndex;
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
    if (questionIndex < questionList.length - 1) {
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
        nextQuestion();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    _startCountDown(); // เริ่มครั้งแรกที่หน้าเปิด ต่อให้เรียก setState() ก็จะไม่ทำฟังก์ชั่นนี้จะทำแค่ครั้งแรกที่ถูกสร้าางหน้านี้
  }

  @override
  void dispose() {
    _timerService.cancel(); // ล้าง timer เมื่อออกหน้า
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questionList[questionIndex];
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
              "${_seconds.toString()} sec",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                "${questionIndex + 1}/${questionList.length}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPaddin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: 
                  ["sound-text", "sound-image"].contains(question.questionType)
                  ? GestureDetector(
                    onTap: () async {
                      await _player.stop();
                      await _player.play(AssetSource(question.question));
                    },
                    child: Align(
                        child:Icon(
                          Icons.volume_up_rounded,
                          color: Colors.black,
                          size: 50
                        )
                      ),
                  )
                  : Image.asset("assets/${question.question}")
              ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ), // ขยายตามเนื้อหา
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    pickAnswer(index);
                    if ( ["image-sound"].contains(question.questionType) ) {
                      await _player.stop();
                      await _player.play(AssetSource(question.options[index]));
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
            ),
            FilledButton(
              onPressed: () {
                submitAnswer();
              },
              child: const Text("Submit", style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}
