import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/subject.dart';
import '../data/math_questions.dart';
import '../data/bm_questions.dart';
import '../data/science_questions.dart';
import '../data/english_questions.dart';
import '../core/audio_manager.dart';

class GameProvider extends ChangeNotifier {
  SubjectType? _currentSubject;
  int _currentLevel = 1;
  List<Question> _questions = [];
  int _questionIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _streak = 0;
  int _maxStreak = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  bool _answered = false;
  String? _selectedAnswer;
  bool _levelComplete = false;
  int _difficulty = 1;

  // Getters
  SubjectType? get currentSubject => _currentSubject;
  int get currentLevel => _currentLevel;
  List<Question> get questions => _questions;
  int get questionIndex => _questionIndex;
  Question? get currentQuestion =>
      _questions.isEmpty ? null : _questions[_questionIndex];
  int get score => _score;
  int get lives => _lives;
  int get streak => _streak;
  int get maxStreak => _maxStreak;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  bool get answered => _answered;
  String? get selectedAnswer => _selectedAnswer;
  bool get levelComplete => _levelComplete;
  int get difficulty => _difficulty;
  int get totalQuestions => _questions.length;

  void startLevel(SubjectType subject, int level, int difficulty) {
    _currentSubject = subject;
    _currentLevel = level;
    _difficulty = difficulty;
    _questionIndex = 0;
    _score = 0;
    _lives = 3;
    _streak = 0;
    _maxStreak = 0;
    _correctCount = 0;
    _wrongCount = 0;
    _answered = false;
    _selectedAnswer = null;
    _levelComplete = false;
    _questions = _loadQuestions(subject, difficulty);
    notifyListeners();
  }

  List<Question> _loadQuestions(SubjectType subject, int difficulty) {
    switch (subject) {
      case SubjectType.math:
        return MathQuestions.getQuestions(difficulty);
      case SubjectType.bm:
        return BmQuestions.getQuestions(difficulty);
      case SubjectType.science:
        return ScienceQuestions.getQuestions(difficulty);
      case SubjectType.english:
        return EnglishQuestions.getQuestions(difficulty);
    }
  }

  Future<void> submitAnswer(String answer) async {
    if (_answered || _levelComplete) return;
    _answered = true;
    _selectedAnswer = answer;
    final correct = currentQuestion?.correctAnswer == answer;

    if (correct) {
      _correctCount++;
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
      // Score: 10 base + streak bonus
      int bonus = _streak > 3 ? (_streak - 3) * 5 : 0;
      _score += 10 + bonus;
      if (_streak == 5) AudioManager().playStreak();
      await AudioManager().playCorrect();
    } else {
      _wrongCount++;
      _streak = 0;
      _lives--;
      await AudioManager().playWrong();
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_questionIndex < _questions.length - 1) {
      _questionIndex++;
      _answered = false;
      _selectedAnswer = null;
    } else {
      _levelComplete = true;
      AudioManager().playLevelUp();
    }
    notifyListeners();
  }

  /// 1–3 stars based on score percentage
  int get starsEarned {
    if (_questions.isEmpty) return 0;
    final maxScore = _questions.length * 10;
    final pct = _score / maxScore;
    if (pct >= 1.0) return 3;
    if (pct >= 0.8) return 2;
    if (pct >= 0.6) return 1;
    return 0;
  }

  /// Compute next difficulty adaptively
  int nextDifficulty() {
    int d = _difficulty;
    if (_correctCount >= 4) d++;
    if (_wrongCount >= 3) d--;
    return d.clamp(1, 10);
  }

  List<String> computeNewBadges(List<String> existing) {
    final earned = <String>[];
    if (!existing.contains('first_win')) earned.add('first_win');
    if (_maxStreak >= 5 && !existing.contains('streak_5')) earned.add('streak_5');
    if (_maxStreak >= 10 && !existing.contains('streak_10')) earned.add('streak_10');
    if (starsEarned == 3 && !existing.contains('perfect_level')) earned.add('perfect_level');
    if (_currentLevel >= 5 && !existing.contains('level_5')) earned.add('level_5');
    if (_currentLevel >= 10 && !existing.contains('level_10')) earned.add('level_10');
    return earned;
  }
}
