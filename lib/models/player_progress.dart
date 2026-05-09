import 'subject.dart';

class PlayerProgress {
  final SubjectType subject;
  int currentLevel;
  int totalStars;
  int totalScore;
  List<String> unlockedBadges;
  Map<int, int> levelStars; // level -> stars earned (1-3)

  PlayerProgress({
    required this.subject,
    this.currentLevel = 1,
    this.totalStars = 0,
    this.totalScore = 0,
    List<String>? unlockedBadges,
    Map<int, int>? levelStars,
  })  : unlockedBadges = unlockedBadges ?? [],
        levelStars = levelStars ?? {};

  Map<String, dynamic> toJson() => {
        'subject': subject.name,
        'currentLevel': currentLevel,
        'totalStars': totalStars,
        'totalScore': totalScore,
        'unlockedBadges': unlockedBadges,
        'levelStars': levelStars.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory PlayerProgress.fromJson(Map<String, dynamic> json) =>
      PlayerProgress(
        subject: SubjectType.values
            .firstWhere((s) => s.name == json['subject']),
        currentLevel: json['currentLevel'] ?? 1,
        totalStars: json['totalStars'] ?? 0,
        totalScore: json['totalScore'] ?? 0,
        unlockedBadges: List<String>.from(json['unlockedBadges'] ?? []),
        levelStars: (json['levelStars'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(int.parse(k), v as int)),
      );
}

class Badge {
  final String id;
  final String name;
  final String emoji;
  final String description;

  const Badge({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });

  static const List<Badge> all = [
    Badge(
        id: 'first_win',
        name: 'Pemain Pertama',
        emoji: '🏆',
        description: 'Tamatkan level pertama!'),
    Badge(
        id: 'streak_5',
        name: 'Streak 5',
        emoji: '🔥',
        description: '5 jawapan betul berturut-turut!'),
    Badge(
        id: 'streak_10',
        name: 'Streak 10',
        emoji: '⚡',
        description: '10 jawapan betul berturut-turut!'),
    Badge(
        id: 'perfect_level',
        name: 'Sempurna!',
        emoji: '⭐',
        description: 'Dapat 3 bintang dalam satu level!'),
    Badge(
        id: 'level_5',
        name: 'Pakar Muda',
        emoji: '🎓',
        description: 'Capai Level 5!'),
    Badge(
        id: 'level_10',
        name: 'Juara Ilmu',
        emoji: '👑',
        description: 'Capai Level 10!'),
    Badge(
        id: 'all_subjects',
        name: 'Murid Terbaik',
        emoji: '🌟',
        description: 'Main semua 4 subjek!'),
  ];
}
