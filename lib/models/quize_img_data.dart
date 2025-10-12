import 'package:brainrot_quiz/models/options.dart';
import 'package:brainrot_quiz/models/options_data.dart';
import 'package:brainrot_quiz/models/quize.dart';
import 'dart:math';


// build Question
List<Question> buildImgQuestions({int optionsPerQuestion=4}) {
  final rand = Random();
  final List<Question> questions = [];

  for (final opt in italianBrainrotOptions) {
    // สุ่มตัวเลือกอื่น
    final others = List<Options>.from(italianBrainrotOptions.where((o) => o != opt))
      ..shuffle(rand);
    final selected = [opt, ...others.take(optionsPerQuestion - 1)];
    selected.shuffle(rand);

    questions.add(
      Question(
        question: opt.imgPath,
        correctAnswer: opt.name,
        options: selected.map((o) => o.name).toList(),
        questionType: "image",
      ),
    );
  }
  return questions;
}


final List<Question> questionList = buildImgQuestions(optionsPerQuestion:4);