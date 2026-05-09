import 'subject.dart';

enum QuestionType { mcq, dragDrop, matching, pictureQuiz }

class Question {
  final String id;
  final String questionText;
  final String? imageEmoji; // emoji as image placeholder
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int difficulty; // 1–10
  final SubjectType subject;

  // For matching questions: pairs of [term, match]
  final List<List<String>>? matchPairs;

  // For drag-drop: sentence with blank marked as ___
  final String? sentenceTemplate;

  const Question({
    required this.id,
    required this.questionText,
    this.imageEmoji,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
    required this.subject,
    this.matchPairs,
    this.sentenceTemplate,
  });
}
