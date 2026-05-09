import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/audio_manager.dart';
import '../models/subject.dart';
import '../models/question.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/hud_widgets.dart';
import '../widgets/question_types/mcq_question.dart';
import '../widgets/question_types/drag_drop_question.dart';
import '../widgets/question_types/matching_question.dart';
import '../widgets/question_types/picture_quiz_question.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final SubjectInfo subject;
  final int level;
  const GameScreen({super.key, required this.subject, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _showFeedback = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    AudioManager().playBgm(widget.subject.bgmAsset);
    final progress = context.read<ProgressProvider>().progressFor(widget.subject.type);
    final difficulty = _computeDifficulty(widget.level, progress);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startLevel(widget.subject.type, widget.level, difficulty);
    });
  }

  int _computeDifficulty(int level, dynamic progress) {
    return ((level - 1) * 1.2).clamp(1, 10).toInt();
  }

  Future<void> _onAnswer(String answer) async {
    final game = context.read<GameProvider>();
    await game.submitAnswer(answer);
    if (!mounted) return;
    setState(() {
      _showFeedback = true;
      _isCorrect = answer == game.currentQuestion?.correctAnswer;
    });
    if (game.lives <= 0) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) _goToResult();
      return;
    }
  }

  void _onNext() {
    final game = context.read<GameProvider>();
    setState(() => _showFeedback = false);
    game.nextQuestion();
    if (game.levelComplete) {
      _goToResult();
    }
  }

  void _goToResult() {
    final game = context.read<GameProvider>();
    final progress = context.read<ProgressProvider>();
    final existingBadges = progress.progressFor(widget.subject.type).unlockedBadges;
    final newBadges = game.computeNewBadges(existingBadges);
    progress.updateAfterLevel(
      subject: widget.subject.type,
      level: widget.level,
      score: game.score,
      stars: game.starsEarned,
      newBadges: newBadges,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          subject: widget.subject,
          level: widget.level,
          score: game.score,
          stars: game.starsEarned,
          correct: game.correctCount,
          wrong: game.wrongCount,
          maxStreak: game.maxStreak,
          newBadges: newBadges,
          nextLevel: widget.level + 1,
          nextDifficulty: game.nextDifficulty(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, game, _) {
      if (game.questions.isEmpty) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: const Center(
              child: CircularProgressIndicator(color: AppTheme.mathPrimary)),
        );
      }
      final q = game.currentQuestion!;
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: SafeArea(
            child: Column(
              children: [
                _buildHud(context, game),
                _buildQuestionProgress(game),
                Expanded(child: _buildQuestion(game, q)),
                if (_showFeedback) _buildFeedback(q),
                if (!_showFeedback && q.type != QuestionType.dragDrop && q.type != QuestionType.matching)
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHud(BuildContext context, GameProvider game) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              AudioManager().playClick();
              showDialog(
                context: context,
                builder: (_) => _QuitDialog(
                  subjectColor: widget.subject.primaryColor,
                  onQuit: () => Navigator.of(context)
                    ..pop()
                    ..pop(),
                ),
              );
            },
            icon: const Icon(Icons.close, color: Colors.white70),
          ),
          LivesBar(lives: game.lives),
          const Spacer(),
          StreakIndicator(streak: game.streak),
          const SizedBox(width: 8),
          ScoreCounter(score: game.score),
        ],
      ),
    );
  }

  Widget _buildQuestionProgress(GameProvider game) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.subject.emoji} Level ${widget.level}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Text('Soalan ${game.questionIndex + 1}/${game.totalQuestions}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (game.questionIndex + 1) / game.totalQuestions,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(widget.subject.primaryColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(GameProvider game, Question q) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.subject.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: widget.subject.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🦉', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(q.questionText,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.4)),
                ),
              ],
            ),
          )
              .animate(key: ValueKey('q_${game.questionIndex}'))
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.1, end: 0),
          const SizedBox(height: 24),
          // Question widget
          _buildQuestionWidget(game, q),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(GameProvider game, Question q) {
    switch (q.type) {
      case QuestionType.mcq:
        return McqQuestion(
          question: q,
          selectedAnswer: game.selectedAnswer,
          answered: game.answered,
          onAnswer: _onAnswer,
        );
      case QuestionType.dragDrop:
        return Column(children: [
          DragDropQuestion(
            question: q,
            answered: game.answered,
            onAnswer: _onAnswer,
          ),
          if (_showFeedback) const SizedBox(height: 12),
        ]);
      case QuestionType.matching:
        return MatchingQuestion(
          question: q,
          answered: game.answered,
          onAnswer: _onAnswer,
        );
      case QuestionType.pictureQuiz:
        return PictureQuizQuestion(
          question: q,
          selectedAnswer: game.selectedAnswer,
          answered: game.answered,
          onAnswer: _onAnswer,
        );
    }
  }

  Widget _buildFeedback(Question q) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? AppTheme.correctGreen.withOpacity(0.15)
            : AppTheme.wrongRed.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: _isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed,
            width: 2),
      ),
      child: Row(
        children: [
          Text(_isCorrect ? '🎉' : '😢', style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCorrect ? 'Betul! Tahniah! 🌟' : 'Salah. Cuba lagi!',
                  style: TextStyle(
                      color: _isCorrect
                          ? AppTheme.correctGreen
                          : AppTheme.wrongRed,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(q.explanation,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onNext,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _isCorrect ? AppTheme.correctGreen : AppTheme.wrongRed,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('Seterusnya →',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14)),
            ),
          ),
        ],
      ),
    )
        .animate()
        .slideY(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut)
        .fadeIn(duration: 200.ms);
  }
}

class _QuitDialog extends StatelessWidget {
  final Color subjectColor;
  final VoidCallback onQuit;
  const _QuitDialog({required this.subjectColor, required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Berhenti Bermain?', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      content: const Text(
          'Kemajuan level ini tidak akan disimpan.',
          style: TextStyle(color: AppTheme.textSecondary)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Teruskan', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () { Navigator.pop(context); onQuit(); },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wrongRed),
          child: const Text('Keluar'),
        ),
      ],
    );
  }
}
