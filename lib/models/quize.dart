
class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String questionType;

  const Question({
    required this.question,
    required this.correctAnswerIndex,
    required this.options,
    required this.questionType
  });

}

