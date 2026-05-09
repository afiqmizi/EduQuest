import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class LivesBar extends StatelessWidget {
  final int lives;
  final int maxLives;
  const LivesBar({super.key, required this.lives, this.maxLives = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (i) {
        final active = i < lives;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(
            active ? '❤️' : '🖤',
            style: const TextStyle(fontSize: 22),
          )
              .animate(key: ValueKey('life_${i}_$active'))
              .scale(
                  begin: active ? const Offset(1.3, 1.3) : const Offset(1, 1),
                  end: const Offset(1, 1),
                  duration: 300.ms,
                  curve: Curves.elasticOut),
        );
      }),
    );
  }
}

class StreakIndicator extends StatelessWidget {
  final int streak;
  const StreakIndicator({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak < 2) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.streakOrange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.streakOrange, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: TextStyle(
                color: AppTheme.streakOrange,
                fontWeight: FontWeight.w800,
                fontSize: 16),
          ),
        ],
      ),
    )
        .animate()
        .shake(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

class ScoreCounter extends StatelessWidget {
  final int score;
  const ScoreCounter({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            '$score',
            style: const TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.w800,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class StarReward extends StatelessWidget {
  final int stars;
  final double size;
  const StarReward({super.key, required this.stars, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final earned = i < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            earned ? '⭐' : '☆',
            style: TextStyle(
                fontSize: size,
                color: earned ? AppTheme.gold : Colors.white24),
          )
              .animate(delay: Duration(milliseconds: 200 + i * 200))
              .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 600.ms),
        );
      }),
    );
  }
}
