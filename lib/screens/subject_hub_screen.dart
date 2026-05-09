import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/audio_manager.dart';
import '../models/subject.dart';
import '../providers/progress_provider.dart';
import '../widgets/mascot_widget.dart';
import 'lesson_screen.dart';
import 'game_screen.dart';

class SubjectHubScreen extends StatelessWidget {
  final SubjectInfo subject;
  const SubjectHubScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>().progressFor(subject.type);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 16),
              // Subject banner
              _buildBanner(context, progress.currentLevel, progress.totalStars),
              const SizedBox(height: 20),
              // Level list
              Expanded(
                child: _buildLevelList(context, progress),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 22),
          ),
          const Spacer(),
          Text(subject.name,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(width: 8),
          Text(subject.emoji, style: const TextStyle(fontSize: 24)),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, int currentLevel, int totalStars) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: subject.gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: subject.primaryColor.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          children: [
            MascotWidget(size: 70, expression: 'happy'),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.description,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(children: [
                    _InfoPill(icon: '🎯', label: 'Level $currentLevel'),
                    const SizedBox(width: 8),
                    _InfoPill(icon: '⭐', label: '$totalStars bintang'),
                  ]),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: -0.1, end: 0),
    );
  }

  Widget _buildLevelList(BuildContext context, dynamic progress) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: progress.currentLevel + 2, // Show 2 future levels
      itemBuilder: (context, index) {
        final level = index + 1;
        final isUnlocked = level <= progress.currentLevel;
        final isCurrent = level == progress.currentLevel;
        final stars = progress.levelStars[level] ?? 0;
        final isLesson = level == 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _LevelCard(
            level: level,
            isUnlocked: isUnlocked,
            isCurrent: isCurrent,
            stars: stars,
            isLesson: isLesson,
            subject: subject,
            onTap: isUnlocked
                ? () {
                    AudioManager().playClick();
                    if (isLesson) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  LessonScreen(subject: subject)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => GameScreen(
                                  subject: subject, level: level)));
                    }
                  }
                : null,
          )
              .animate(delay: Duration(milliseconds: index * 80))
              .slideX(begin: 0.2, end: 0, duration: 300.ms)
              .fadeIn(),
        );
      },
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final bool isUnlocked;
  final bool isCurrent;
  final int stars;
  final bool isLesson;
  final SubjectInfo subject;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
    required this.stars,
    required this.isLesson,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? subject.primaryColor.withOpacity(0.2)
              : isUnlocked
                  ? AppTheme.cardBg
                  : AppTheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrent ? subject.primaryColor : Colors.white12,
            width: isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isUnlocked
                    ? subject.primaryColor.withOpacity(0.2)
                    : Colors.white10,
                border: Border.all(
                    color: isUnlocked ? subject.primaryColor : Colors.white24,
                    width: 2),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(isLesson ? '🎬' : '$level',
                        style: TextStyle(
                            fontSize: isLesson ? 22 : 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w800))
                    : const Icon(Icons.lock, color: Colors.white38, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLesson ? 'Level 1 — Video Pelajaran 🎬' : 'Level $level',
                    style: TextStyle(
                        color: isUnlocked ? Colors.white : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLesson
                        ? 'Tonton animasi pembelajaran!'
                        : isUnlocked
                            ? '5 soalan • ${_difficultyLabel(level)}'
                            : 'Kunci — tamatkan level sebelum ini',
                    style: TextStyle(
                        color: isUnlocked
                            ? AppTheme.textSecondary
                            : Colors.white24,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isUnlocked && stars > 0)
              Row(
                children: List.generate(
                    3,
                    (i) => Text(i < stars ? '⭐' : '☆',
                        style: TextStyle(
                            fontSize: 16,
                            color: i < stars ? AppTheme.gold : Colors.white24))),
              ),
            if (isCurrent)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: subject.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('MULA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800)),
              ),
          ],
        ),
      ),
    );
  }

  String _difficultyLabel(int level) {
    if (level <= 2) return 'Mudah';
    if (level <= 4) return 'Sederhana';
    if (level <= 6) return 'Susah';
    if (level <= 8) return 'Sangat Susah';
    return 'Pakar';
  }
}
