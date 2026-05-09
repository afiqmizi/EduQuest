import 'package:flutter/material.dart';

enum SubjectType { math, bm, science, english }

class SubjectInfo {
  final SubjectType type;
  final String name;
  final String nameMalay;
  final String emoji;
  final Color primaryColor;
  final Color secondaryColor;
  final String bgmAsset;
  final String description;

  const SubjectInfo({
    required this.type,
    required this.name,
    required this.nameMalay,
    required this.emoji,
    required this.primaryColor,
    required this.secondaryColor,
    required this.bgmAsset,
    required this.description,
  });

  static const List<SubjectInfo> all = [
    SubjectInfo(
      type: SubjectType.math,
      name: 'Matematik',
      nameMalay: 'Matematik',
      emoji: '🔢',
      primaryColor: Color(0xFF6C63FF),
      secondaryColor: Color(0xFF9C8FFF),
      bgmAsset: 'audio/bgm_math.mp3',
      description: 'Belajar tambah, tolak, darab & bahagi!',
    ),
    SubjectInfo(
      type: SubjectType.bm,
      name: 'Bahasa Melayu',
      nameMalay: 'Bahasa Melayu',
      emoji: '📖',
      primaryColor: Color(0xFF00C897),
      secondaryColor: Color(0xFF00E8B0),
      bgmAsset: 'audio/bgm_bm.mp3',
      description: 'Terokai kata nama, ayat & kosa kata!',
    ),
    SubjectInfo(
      type: SubjectType.science,
      name: 'Sains',
      nameMalay: 'Sains',
      emoji: '🔬',
      primaryColor: Color(0xFFFF8C42),
      secondaryColor: Color(0xFFFFB347),
      bgmAsset: 'audio/bgm_science.mp3',
      description: 'Kenali haiwan, tumbuhan & alam!',
    ),
    SubjectInfo(
      type: SubjectType.english,
      name: 'English',
      nameMalay: 'Bahasa Inggeris',
      emoji: '🌍',
      primaryColor: Color(0xFFFF4B7D),
      secondaryColor: Color(0xFFFF7EA8),
      bgmAsset: 'audio/bgm_english.mp3',
      description: 'Learn words, sentences & more!',
    ),
  ];

  static SubjectInfo fromType(SubjectType type) =>
      all.firstWhere((s) => s.type == type);

  LinearGradient get gradient => LinearGradient(
        colors: [primaryColor, secondaryColor.withOpacity(0.6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
