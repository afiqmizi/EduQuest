import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/question.dart';
import '../../core/theme.dart';

class MatchingQuestion extends StatefulWidget {
  final Question question;
  final bool answered;
  final Function(String) onAnswer;

  const MatchingQuestion({
    super.key,
    required this.question,
    required this.answered,
    required this.onAnswer,
  });

  @override
  State<MatchingQuestion> createState() => _MatchingQuestionState();
}

class _MatchingQuestionState extends State<MatchingQuestion> {
  String? _selectedLeft;
  final Map<String, String> _matched = {};

  List<List<String>> get pairs => widget.question.matchPairs ?? [];

  List<String> get leftItems => pairs.map((p) => p[0]).toList();
  List<String> get rightItems => pairs.map((p) => p[1]).toList()..shuffle();

  late List<String> _shuffledRight;

  @override
  void initState() {
    super.initState();
    _shuffledRight = pairs.map((p) => p[1]).toList()..shuffle();
  }

  bool get _allMatched => _matched.length == pairs.length;

  void _selectLeft(String item) {
    if (widget.answered || _matched.containsKey(item)) return;
    setState(() => _selectedLeft = item);
  }

  void _selectRight(String item) {
    if (widget.answered || _matched.containsValue(item)) return;
    if (_selectedLeft == null) return;

    // Check if correct pair
    final correctRight =
        pairs.firstWhere((p) => p[0] == _selectedLeft!, orElse: () => [])[1];
    if (correctRight == item) {
      setState(() {
        _matched[_selectedLeft!] = item;
        _selectedLeft = null;
      });
      if (_allMatched) {
        widget.onAnswer(widget.question.correctAnswer);
      }
    } else {
      setState(() => _selectedLeft = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Left column
            Expanded(
              child: Column(
                children: leftItems.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isMatched = _matched.containsKey(item);
                  final isSelected = _selectedLeft == item;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: GestureDetector(
                      onTap: () => _selectLeft(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? AppTheme.correctGreen.withOpacity(0.2)
                              : isSelected
                                  ? AppTheme.mathPrimary.withOpacity(0.3)
                                  : AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isMatched
                                ? AppTheme.correctGreen
                                : isSelected
                                    ? AppTheme.mathPrimary
                                    : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Text(item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      )
                          .animate(delay: Duration(milliseconds: idx * 100))
                          .slideX(begin: -0.3, end: 0, duration: 300.ms)
                          .fadeIn(),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Arrow column
            Column(
              children: List.generate(
                  pairs.length,
                  (i) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Icon(Icons.arrow_forward,
                          color: Colors.white38, size: 20))),
            ),
            // Right column
            Expanded(
              child: Column(
                children: _shuffledRight.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final isMatched = _matched.containsValue(item);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: GestureDetector(
                      onTap: () => _selectRight(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? AppTheme.correctGreen.withOpacity(0.2)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isMatched
                                ? AppTheme.correctGreen
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Text(item,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      )
                          .animate(delay: Duration(milliseconds: idx * 100))
                          .slideX(begin: 0.3, end: 0, duration: 300.ms)
                          .fadeIn(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        if (_selectedLeft != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Pilih padanan untuk "$_selectedLeft"',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
