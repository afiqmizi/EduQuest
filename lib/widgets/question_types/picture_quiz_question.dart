import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/question.dart';
import '../../core/theme.dart';

class PictureQuizQuestion extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final bool answered;
  final Function(String) onAnswer;

  const PictureQuizQuestion({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.answered,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image / Emoji display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.surface,
                AppTheme.cardBg,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            question.imageEmoji ?? '❓',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64),
          ),
        )
            .animate()
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms, curve: Curves.elasticOut)
            .fadeIn(),
        const SizedBox(height: 24),
        // Options grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: question.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == option;
            final isCorrect = question.correctAnswer == option;

            Color borderColor = Colors.white24;
            Color bgColor = AppTheme.cardBg;
            Widget? icon;

            if (answered) {
              if (isCorrect) {
                borderColor = AppTheme.correctGreen;
                bgColor = AppTheme.correctGreen.withOpacity(0.2);
                icon = const Icon(Icons.check, color: AppTheme.correctGreen, size: 20);
              } else if (isSelected) {
                borderColor = AppTheme.wrongRed;
                bgColor = AppTheme.wrongRed.withOpacity(0.2);
                icon = const Icon(Icons.close, color: AppTheme.wrongRed, size: 20);
              }
            } else if (isSelected) {
              borderColor = AppTheme.mathPrimary;
              bgColor = AppTheme.mathPrimary.withOpacity(0.2);
            }

            return GestureDetector(
              onTap: answered ? null : () => onAnswer(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[icon, const SizedBox(width: 6)],
                    Flexible(
                      child: Text(option,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: idx * 80))
                  .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), duration: 300.ms, curve: Curves.elasticOut),
            );
          }).toList(),
        ),
      ],
    );
  }
}
