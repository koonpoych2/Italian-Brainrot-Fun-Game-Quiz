import 'package:all_in_one_brainrot/components/text_show.dart';
import 'package:all_in_one_brainrot/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Card colors matching the quiz screen
const List<Color> _cardColors = [
  Color(0xFF9B59B6), // Purple
  Color(0xFF1ABC9C), // Teal
  Color(0xFFF1C40F), // Yellow
  Color(0xFFE74C3C), // Red
];

// Darker text colors for better contrast on white background
const List<Color> _darkTextColors = [
  Color(0xFF5B2C6F), // Dark Purple
  Color(0xFF0E6655), // Dark Teal
  Color(0xFF9A7D0A), // Dark Yellow/Gold
  Color(0xFF922B21), // Dark Red
];

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
    // Get the darker text color based on card index
    final textColor = _darkTextColors[currentAnswerIndex % _darkTextColors.length];

    // Handle different question types
    if (questionOptionType.contains('-image')) {
      // Image answer
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          "assets/$questionOption",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    } else if (questionOptionType.contains('-sound')) {
      // Sound answer - show play icon
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note_rounded,
                size: 40,
                color: textColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Sound ${currentAnswerIndex + 1}',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Text answer
      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            questionOption,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }
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