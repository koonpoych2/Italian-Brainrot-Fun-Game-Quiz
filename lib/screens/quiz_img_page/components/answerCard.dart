import 'package:brainrot_quiz/components/text_show.dart';
import 'package:brainrot_quiz/constants.dart';
import 'package:flutter/material.dart';

class Answercard extends StatelessWidget {
  const Answercard({
    super.key,
    required this.questionOption,
    required this.questionOptionType,
    required this.isSelected,
    required this.currentAnswerIndex,
    required this.selectAnswerIndex,
    required this.correctAnswerIndex
  });

  final String questionOption;
  final String questionOptionType;
  final bool isSelected;
  final int currentAnswerIndex;
  final int? selectAnswerIndex;
  final int correctAnswerIndex;



  @override
  Widget build(BuildContext context) {
    bool isCorrectAnswer = correctAnswerIndex == currentAnswerIndex;
    bool isSelectThisAnswer = currentAnswerIndex == selectAnswerIndex;
    
    final Map<int, Color> colorMap = {
      0: const Color.fromARGB(255, 115, 83, 242),
      1: const Color.fromARGB(255, 25, 167, 77),
      2: const Color.fromARGB(233, 243, 145, 32),
      3: const Color.fromARGB(255, 80, 154, 250),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelectThisAnswer
              ?  Colors.green
              : Colors.black,
              width: 5,
            )
          ),
          child: Stack(
            children: [
                  ["image-sound"].contains(questionOptionType)
                  ? 
                  Align(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: colorMap[currentAnswerIndex],
                      child: Icon(
                        Icons.volume_up_rounded,
                        color: Colors.black,
                        size: 50
                      ),
                    )
                  )
                  : ["sound-image"].contains(questionOptionType)
                  ?                   Align(
                    child: Image.asset("assets/${questionOption}")
                  )
                  : Align(
                    child: 
                    TextShow(
                      title: questionOption!,
                      backgroundColor: colorMap[currentAnswerIndex]!,
                      mainTextSize: 20,
                      mainbackgroundColor: Colors.black,
                    )
                  ),
                const SizedBox(height: 10,),
                if (isSelected) 
                  Positioned(
                    right: 1, 
                    top: 1,
                    child:  isCorrectAnswer
                    ?  buildCorrectIcon()
                    : buildInCorrectIcon()
                    )
            ],
          ),
        ),
      );
  }
}

Widget buildCorrectIcon() => const CircleAvatar(
  radius: 15,
  backgroundColor: Colors.green,
  child: Icon(
    Icons.check,
    color: Colors.white,
  ),
);

Widget buildInCorrectIcon() => const CircleAvatar(
  radius: 15,
  backgroundColor: Colors.red,
  child: Icon(
    Icons.close,
    color: Colors.white,
  ),
);