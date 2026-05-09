import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_progress.dart';
import '../models/subject.dart';

class ProgressProvider extends ChangeNotifier {
  Map<SubjectType, PlayerProgress> _progress = {};
  String _playerName = 'Murid';

  String get playerName => _playerName;
  Map<SubjectType, PlayerProgress> get progress => _progress;

  PlayerProgress progressFor(SubjectType subject) =>
      _progress[subject] ?? PlayerProgress(subject: subject);

  int get totalStars => _progress.values.fold(0, (s, p) => s + p.totalStars);
  int get totalScore => _progress.values.fold(0, (s, p) => s + p.totalScore);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _playerName = prefs.getString('playerName') ?? 'Murid';
    for (final subject in SubjectType.values) {
      final raw = prefs.getString('progress_${subject.name}');
      if (raw != null) {
        _progress[subject] =
            PlayerProgress.fromJson(jsonDecode(raw));
      } else {
        _progress[subject] = PlayerProgress(subject: subject);
      }
    }
    notifyListeners();
  }

  Future<void> setPlayerName(String name) async {
    _playerName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', name);
    notifyListeners();
  }

  Future<void> saveProgress(SubjectType subject) async {
    final prefs = await SharedPreferences.getInstance();
    final p = _progress[subject];
    if (p != null) {
      await prefs.setString(
          'progress_${subject.name}', jsonEncode(p.toJson()));
    }
  }

  void updateAfterLevel({
    required SubjectType subject,
    required int level,
    required int score,
    required int stars,
    required List<String> newBadges,
  }) {
    final p = _progress[subject] ?? PlayerProgress(subject: subject);
    p.totalScore += score;
    p.totalStars += stars;
    if (!p.levelStars.containsKey(level) || p.levelStars[level]! < stars) {
      p.levelStars[level] = stars;
    }
    if (level >= p.currentLevel) {
      p.currentLevel = level + 1;
    }
    for (final badge in newBadges) {
      if (!p.unlockedBadges.contains(badge)) {
        p.unlockedBadges.add(badge);
      }
    }
    _progress[subject] = p;
    saveProgress(subject);
    notifyListeners();
  }
}
