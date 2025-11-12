import 'dart:ffi';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  
  final String correctAnswer;
  final String correctAnswerType;
  final int score;
  final int maxScore;
  

  const ResultScreen({
    super.key,
    required this.correctAnswer,
    required this.score,
    required this.correctAnswerType,
    required this.maxScore
  });

  @override
  Widget build(BuildContext context) {

    bool isclear = maxScore == score;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => {
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (_) => QuizImgScreen()
              )
          )
          }, 
          icon: SvgPicture.asset(
            "assets/icons/back.svg", 
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          )
        ),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 1000),
          Column(
            children: [
              Text(
                isclear 
                ? 'YOU WIN'
                : 'YOU LOSE',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                ' ${score.toString()}/${maxScore}',
                style: const TextStyle(fontSize: 50),
              ),
            ],
          ),

          Column(
            children: [
              Text(
                'CORRECT ANSWER IS',
                style: const TextStyle(fontSize: 30),
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
                      color: const Color.fromARGB(255, 112, 236, 116), // สีพื้นหลัง
                      borderRadius: BorderRadius.circular(12), // มุมโค้ง 12px (ปรับได้)
                    ),
                  ),
                ),
              ],
            )
            ],
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton(
                  child: const Text("HOME", style: TextStyle(fontSize: 25)),
                  onPressed: () {},
                          ),
                FilledButton(
                  child: const Text("RETRY", style: TextStyle(fontSize: 25)),
                  onPressed: () {},
                          ),
              ],
            )
        ],
      ),
    );
  }
}