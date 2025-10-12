import 'package:brainrot_quiz/constants.dart';
import 'package:brainrot_quiz/screens/quiz_img_page/quiz_img_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor)
      ),
      home: QuizImgScreen(),
    );
  }
}
