import 'package:all_in_one_brainrot/models/options.dart';
import 'package:all_in_one_brainrot/models/options_data.dart';
import 'package:all_in_one_brainrot/models/quize.dart';
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
    int correctIndex = selected.indexOf(opt);

    final types = ["image-text", "image-sound", "sound-text", "sound-image"];
    String questionType = types[rand.nextInt(types.length)];
    // String questionType = "sound-image";

    questions.add(
      Question(
        question:  ["sound-text", "sound-image"].contains(questionType)
              ? opt.soundPath
              : opt.imgPath,
        correctAnswerIndex: correctIndex,
        options: selected.map((o) {
          if ( ["image-text", "sound-text"].contains(questionType) ) {
            return o.name;
          }
          else if ( ["image-sound"].contains(questionType) ) {
            return o.soundPath;
          }
          else {
            return o.imgPath; // ค่า default กัน error
          }
        }).toList(),
        questionType: questionType,
      ),
    );
  }
  return questions;
}


final List<Question> questionList = buildImgQuestions(optionsPerQuestion:4);