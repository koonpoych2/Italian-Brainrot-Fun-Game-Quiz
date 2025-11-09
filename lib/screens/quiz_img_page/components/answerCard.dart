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
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(kDefaultPaddin),
        decoration: BoxDecoration(
          color: isSelectThisAnswer ? Colors.lightGreenAccent : Colors.black,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
              ? isCorrectAnswer 
                ? Colors.green
                : Colors.red
              : Colors.black
                )
          ),
          child: Stack(
            children: [
                  ["image-sound"].contains(questionOptionType)
                  ? 
                  Align(
                    child:Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 50
                    )
                  )
                  : ["sound-image"].contains(questionOptionType)
                  ?                   Align(
                    child: Image.asset("assets/${questionOption}")
                  )
                  : Align(
                    child: 
                      Text(
                        questionOption!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
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