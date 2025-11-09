import 'dart:ffi';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  
  final String correctAnswer;
  final int score;
  
  const ResultScreen({
    super.key,
    required this.correctAnswer,
    required this.score
  });

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'Your Score : ',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500
            ),
          ),
          Stack( 
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                  value: score/9,
                  color: Colors.green,
                  backgroundColor: Colors.white,
                ),
              ),
              Column(
                children: [
                  Text(
                    score.toString(),
                    style: const TextStyle(fontSize: 80),
                  )
                ],)
            ],
          )
        ],
      ),
    );
  }
}