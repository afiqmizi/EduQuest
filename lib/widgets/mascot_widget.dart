import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class MascotWidget extends StatefulWidget {
  final String expression; // 'happy', 'excited', 'sad', 'thinking', 'celebrate'
  final double size;
  const MascotWidget({super.key, this.expression = 'happy', this.size = 100});

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _emoji {
    switch (widget.expression) {
      case 'excited':
        return '🦉✨';
      case 'sad':
        return '🦉😢';
      case 'thinking':
        return '🦉🤔';
      case 'celebrate':
        return '🦉🎉';
      case 'happy':
      default:
        return '🦉';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bounce = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, -6 * bounce + 3),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [
            AppTheme.mathPrimary.withOpacity(0.3),
            Colors.transparent
          ]),
        ),
        child: Center(
          child: Text(_emoji,
              style: TextStyle(fontSize: widget.size * 0.55)),
        ),
      ),
    ).animate().scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: 400.ms,
        curve: Curves.elasticOut);
  }
}
