import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/progress_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _nameController = TextEditingController();
  bool _showNameInput = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final progress = context.read<ProgressProvider>();
    await progress.load();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    if (progress.playerName == 'Murid') {
      setState(() {
        _loading = false;
        _showNameInput = true;
      });
    } else {
      _navigate();
    }
  }

  void _navigate() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    await context.read<ProgressProvider>().setPlayerName(name);
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: _loading
                ? _buildLoading()
                : _showNameInput
                    ? _buildNameInput()
                    : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('🦉', style: const TextStyle(fontSize: 100))
            .animate()
            .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 700.ms, curve: Curves.elasticOut)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -12, duration: 1000.ms, curve: Curves.easeInOut),
        const SizedBox(height: 24),
        Text('EduQuest',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.w800))
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 8),
        Text('Belajar sambil bermain! 🎮',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondary))
            .animate(delay: 700.ms)
            .fadeIn(duration: 500.ms),
        const SizedBox(height: 48),
        const CircularProgressIndicator(color: AppTheme.mathPrimary)
            .animate(delay: 800.ms)
            .fadeIn(),
      ],
    );
  }

  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🦉', style: const TextStyle(fontSize: 80))
              .animate()
              .scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text('Hai! Saya Owly! 👋',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center)
              .animate(delay: 200.ms)
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text('Siapakah nama kamu?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textSecondary),
              textAlign: TextAlign.center)
              .animate(delay: 400.ms)
              .fadeIn(),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: 'Taip nama kamu...',
              hintStyle:
                  const TextStyle(color: Colors.white38, fontSize: 18),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: AppTheme.mathPrimary, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white24),
              ),
            ),
          )
              .animate(delay: 600.ms)
              .fadeIn()
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _saveName,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mathPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Mula Belajar! 🚀',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
            ),
          )
              .animate(delay: 800.ms)
              .fadeIn()
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    );
  }
}
