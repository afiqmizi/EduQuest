import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/question.dart';
import '../../core/theme.dart';

class DragDropQuestion extends StatefulWidget {
  final Question question;
  final bool answered;
  final Function(String) onAnswer;

  const DragDropQuestion({
    super.key,
    required this.question,
    required this.answered,
    required this.onAnswer,
  });

  @override
  State<DragDropQuestion> createState() => _DragDropQuestionState();
}

class _DragDropQuestionState extends State<DragDropQuestion> {
  String? _droppedAnswer;

  @override
  Widget build(BuildContext context) {
    final parts = (widget.question.sentenceTemplate ?? '').split('___');
    final before = parts.isNotEmpty ? parts[0] : '';
    final after = parts.length > 1 ? parts[1] : '';

    final isCorrect = _droppedAnswer == widget.question.correctAnswer;

    return Column(
      children: [
        // Sentence with drop zone
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(before,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              DragTarget<String>(
                onAcceptWithDetails: (details) {
                  if (!widget.answered) {
                    setState(() => _droppedAnswer = details.data);
                    widget.onAnswer(details.data);
                  }
                },
                builder: (context, candidates, rejected) {
                  final filled = _droppedAnswer != null;
                  Color borderColor = candidates.isNotEmpty
                      ? AppTheme.mathPrimary
                      : Colors.white38;
                  if (widget.answered) {
                    borderColor =
                        isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed;
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    height: 44,
                    decoration: BoxDecoration(
                      color: filled
                          ? borderColor.withOpacity(0.2)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _droppedAnswer ?? '  ?  ',
                      style: TextStyle(
                          color: filled ? borderColor : Colors.white38,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
              Text(after,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        // Draggable options
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: widget.question.options.asMap().entries.map((entry) {
            final idx = entry.key;
            final opt = entry.value;
            final used = _droppedAnswer == opt && widget.answered;
            return Draggable<String>(
              data: opt,
              feedback: Material(
                color: Colors.transparent,
                child: _OptionChip(label: opt, color: AppTheme.mathPrimary),
              ),
              childWhenDragging: _OptionChip(
                  label: opt, color: Colors.white12, textColor: Colors.white24),
              child: _OptionChip(
                label: opt,
                color: used ? Colors.white12 : AppTheme.mathPrimary,
                textColor: used ? Colors.white24 : Colors.white,
              ),
            )
                .animate(delay: Duration(milliseconds: idx * 80))
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1), duration: 300.ms, curve: Curves.elasticOut);
          }).toList(),
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _OptionChip(
      {required this.label,
      required this.color,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Text(label,
          style: TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.w700)),
    );
  }
}
