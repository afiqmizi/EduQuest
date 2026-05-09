import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/question.dart';
import '../../core/theme.dart';

class McqQuestion extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final bool answered;
  final Function(String) onAnswer;

  const McqQuestion({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.answered,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final idx = entry.key;
        final option = entry.value;
        final isSelected = selectedAnswer == option;
        final isCorrect = question.correctAnswer == option;

        Color borderColor = Colors.white24;
        Color bgColor = AppTheme.cardBg;
        Widget? trailingIcon;

        if (answered) {
          if (isCorrect) {
            borderColor = AppTheme.correctGreen;
            bgColor = AppTheme.correctGreen.withOpacity(0.15);
            trailingIcon = const Icon(Icons.check_circle, color: AppTheme.correctGreen);
          } else if (isSelected) {
            borderColor = AppTheme.wrongRed;
            bgColor = AppTheme.wrongRed.withOpacity(0.15);
            trailingIcon = const Icon(Icons.cancel, color: AppTheme.wrongRed);
          }
        } else if (isSelected) {
          borderColor = AppTheme.mathPrimary;
          bgColor = AppTheme.mathPrimary.withOpacity(0.2);
        }

        final labels = ['A', 'B', 'C', 'D'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: answered ? null : () => onAnswer(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: borderColor,
                  radius: 18,
                  child: Text(labels[idx],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                title: Text(option,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                trailing: trailingIcon,
              ),
            )
                .animate(delay: Duration(milliseconds: idx * 80))
                .slideX(begin: 0.3, end: 0, duration: 300.ms)
                .fadeIn(),
          ),
        );
      }).toList(),
    );
  }
}
