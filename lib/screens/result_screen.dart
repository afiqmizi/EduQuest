import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../core/audio_manager.dart';
import '../models/subject.dart';
import '../models/player_progress.dart' as pp;
import '../widgets/hud_widgets.dart';
import '../widgets/mascot_widget.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final SubjectInfo subject;
  final int level;
  final int score;
  final int stars;
  final int correct;
  final int wrong;
  final int maxStreak;
  final List<String> newBadges;
  final int nextLevel;
  final int nextDifficulty;

  const ResultScreen({
    super.key,
    required this.subject,
    required this.level,
    required this.score,
    required this.stars,
    required this.correct,
    required this.wrong,
    required this.maxStreak,
    required this.newBadges,
    required this.nextLevel,
    required this.nextDifficulty,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _confettiController;
  bool _showBadges = false;

  String get _resultEmoji {
    if (widget.stars == 3) return 'celebrate';
    if (widget.stars >= 1) return 'happy';
    return 'sad';
  }

  String get _resultTitle {
    if (widget.stars == 3) return 'Sempurna! 🌟';
    if (widget.stars == 2) return 'Bagus Sekali! 🎉';
    if (widget.stars == 1) return 'Teruskan! 💪';
    return 'Cuba Lagi! 😊';
  }

  String get _resultMessage {
    if (widget.stars == 3) return 'Kamu mendapat 3 bintang!\nHebat sekali!';
    if (widget.stars == 2) return 'Kamu mendapat 2 bintang!\nLain kali boleh dapat lebih!';
    if (widget.stars == 1) return 'Kamu mendapat 1 bintang!\nTerus berlatih!';
    return 'Jangan putus asa!\nCuba sekali lagi!';
  }

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));
    if (widget.stars > 0) {
      _confettiController.forward();
      AudioManager().playStarEarn();
    }
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted && widget.newBadges.isNotEmpty) {
        setState(() => _showBadges = true);
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Mascot
                    MascotWidget(expression: _resultEmoji, size: 100)
                        .animate()
                        .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 16),
                    // Result title
                    Text(_resultTitle,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800))
                        .animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 8),
                    Text(_resultMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary))
                        .animate(delay: 350.ms).fadeIn(),
                    const SizedBox(height: 24),
                    // Stars
                    StarReward(stars: widget.stars, size: 52),
                    const SizedBox(height: 28),
                    // Stats card
                    _buildStatsCard(),
                    const SizedBox(height: 20),
                    // New badges
                    if (_showBadges && widget.newBadges.isNotEmpty)
                      _buildBadgesSection(),
                    const SizedBox(height: 28),
                    // Action buttons
                    _buildButtons(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Confetti particles
              if (widget.stars == 3)
                _buildConfetti(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text('Statistik Level ${widget.level}',
              style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(icon: '✅', label: 'Betul', value: '${widget.correct}', color: AppTheme.correctGreen),
              _StatItem(icon: '❌', label: 'Salah', value: '${widget.wrong}', color: AppTheme.wrongRed),
              _StatItem(icon: '🔥', label: 'Streak', value: '${widget.maxStreak}', color: AppTheme.streakOrange),
              _StatItem(icon: '⭐', label: 'Skor', value: '${widget.score}', color: AppTheme.gold),
            ],
          ),
        ],
      ),
    ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildBadgesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.gold.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          const Text('🏆 Badge Baru Dibuka!',
              style: TextStyle(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: widget.newBadges.map((id) {
              final badge = pp.Badge.all.firstWhere(
                  (b) => b.id == id,
                  orElse: () => const pp.Badge(
                      id: '', name: 'Badge', emoji: '🏅', description: ''));
              return _BadgeChip(badge: badge);
            }).toList(),
          ),
        ],
      ),
    )
        .animate()
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut)
        .fadeIn();
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Next Level button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              AudioManager().playClick();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                      subject: widget.subject,
                      level: widget.nextLevel),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.subject.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Level ${widget.nextLevel} ▶',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
            ]),
          ),
        )
            .animate(delay: 700.ms)
            .fadeIn()
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        const SizedBox(height: 12),
        // Retry current level
        if (widget.stars < 3)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                AudioManager().playClick();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(
                        subject: widget.subject, level: widget.level),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('🔄 Cuba Semula',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
          ).animate(delay: 850.ms).fadeIn(),
        const SizedBox(height: 12),
        // Home button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: TextButton(
            onPressed: () {
              AudioManager().playClick();
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('🏠 Menu Utama',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
        ).animate(delay: 950.ms).fadeIn(),
      ],
    );
  }

  Widget _buildConfetti() {
    final colors = [
      AppTheme.gold, AppTheme.correctGreen, AppTheme.mathPrimary,
      AppTheme.englishPrimary, AppTheme.sciencePrimary,
    ];
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, _) {
          return Stack(
            children: List.generate(20, (i) {
              final color = colors[i % colors.length];
              return Positioned(
                left: (i * 37.0) % MediaQuery.of(context).size.width,
                top: -30 + _confettiController.value * (MediaQuery.of(context).size.height + 60),
                child: Transform.rotate(
                  angle: i * 0.7 * _confettiController.value * 6,
                  child: Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(i % 2 == 0 ? 5 : 2),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(icon, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 4),
      Text(value,
          style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 22)),
      Text(label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
    ]);
  }
}

class _BadgeChip extends StatelessWidget {
  final pp.Badge badge;
  const _BadgeChip({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.gold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.gold.withOpacity(0.4)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(badge.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(badge.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
        Text(badge.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
      ]),
    );
  }
}
