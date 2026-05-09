import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _soundEnabled = true;
  bool get soundEnabled => _soundEnabled;

  void toggleSound() => _soundEnabled = !_soundEnabled;

  Future<void> playBgm(String assetPath) async {
    if (!_soundEnabled) return;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.4);
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  Future<void> playSfx(String assetPath) async {
    if (!_soundEnabled) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(1.0);
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (_) {}
  }

  Future<void> playCorrect() => playSfx('audio/correct.mp3');
  Future<void> playWrong() => playSfx('audio/wrong.mp3');
  Future<void> playClick() => playSfx('audio/click.mp3');
  Future<void> playLevelUp() => playSfx('audio/levelup.mp3');
  Future<void> playStarEarn() => playSfx('audio/star.mp3');
  Future<void> playStreak() => playSfx('audio/streak.mp3');

  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
