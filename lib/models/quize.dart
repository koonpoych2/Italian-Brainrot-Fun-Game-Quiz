
class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String questionType;

  const Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
    required this.questionType
  });

}