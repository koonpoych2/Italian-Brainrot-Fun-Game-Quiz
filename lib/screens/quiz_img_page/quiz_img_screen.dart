import 'package:brainrot_quiz/models/quize_img_data.dart';
import 'package:flutter/material.dart';

class QuizImgScreen extends StatefulWidget {
  const QuizImgScreen({super.key});

  @override
  State<QuizImgScreen> createState() => _QuizImgScreenState();
}

class _QuizImgScreenState extends State<QuizImgScreen> {
  @override
  Widget build(BuildContext context) {
    final question = questionList[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),

      ),
    );
  }
}
