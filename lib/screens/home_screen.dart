import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/audio_manager.dart';
import '../models/subject.dart';
import '../providers/progress_provider.dart';
import '../widgets/mascot_widget.dart';
import 'subject_hub_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    AudioManager().playBgm('audio/bgm_home.mp3');
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(progress),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const MascotWidget(size: 80),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selamat datang,',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium),
                          Text(progress.playerName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(begin: 0.2, end: 0),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Pilih subjek untuk bermain! 🎯',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textSecondary))
                    .animate(delay: 400.ms)
                    .fadeIn(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: SubjectInfo.all.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final subject = entry.value;
                      final prog = progress.progressFor(subject.type);
                      return _SubjectCard(
                        subject: subject,
                        currentLevel: prog.currentLevel,
                        totalStars: prog.totalStars,
                        animDelay: Duration(milliseconds: 100 + idx * 120),
                        onTap: () {
                          AudioManager().playClick();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SubjectHubScreen(subject: subject),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              _buildBottomBar(progress),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProgressProvider progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.gold.withOpacity(0.5)),
              ),
              child: Row(children: [
                const Text('⭐', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text('${progress.totalStars}',
                    style: const TextStyle(
                        color: AppTheme.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
              ]),
            ),
          ]).animate().fadeIn(delay: 100.ms),
          Text('EduQuest 🎓',
              style: Theme.of(context).textTheme.headlineLarge)
              .animate()
              .fadeIn(delay: 100.ms),
          IconButton(
            onPressed: () {
              AudioManager().toggleSound();
              setState(() {});
            },
            icon: Icon(
              AudioManager().soundEnabled ? Icons.volume_up : Icons.volume_off,
              color: Colors.white70,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProgressProvider progress) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(icon: '⭐', label: 'Bintang', value: '${progress.totalStars}'),
          _StatChip(icon: '🏆', label: 'Skor', value: '${progress.totalScore}'),
          _StatChip(
            icon: '📚',
            label: 'Subjek',
            value:
                '${progress.progress.values.where((p) => p.currentLevel > 1).length}/4',
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _StatChip(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 2),
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
      Text(label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
    ]);
  }
}

class _SubjectCard extends StatelessWidget {
  final SubjectInfo subject;
  final int currentLevel;
  final int totalStars;
  final Duration animDelay;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.currentLevel,
    required this.totalStars,
    required this.animDelay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: subject.gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: subject.primaryColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background circles
            Positioned(
              right: -20, top: -20,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              left: -10, bottom: -25,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(subject.emoji,
                      style: const TextStyle(fontSize: 42)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.layers, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text('Level $currentLevel',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const Spacer(),
                        const Text('⭐', style: TextStyle(fontSize: 13)),
                        Text(' $totalStars',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: animDelay)
        .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), duration: 400.ms, curve: Curves.elasticOut)
        .fadeIn();
  }
}
