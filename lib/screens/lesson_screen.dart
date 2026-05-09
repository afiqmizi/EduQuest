import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import '../core/audio_manager.dart';
import '../models/subject.dart';
import 'game_screen.dart';

class LessonSlide {
  final String emoji;
  final String title;
  final String body;
  final Color accentColor;
  const LessonSlide({required this.emoji, required this.title, required this.body, required this.accentColor});
}

class LessonScreen extends StatefulWidget {
  final SubjectInfo subject;
  const LessonScreen({super.key, required this.subject});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with TickerProviderStateMixin {
  int _slideIndex = 0;
  late AnimationController _slideController;
  late AnimationController _autoController;
  bool _autoPlay = true;
  bool _finished = false;

  List<LessonSlide> get _slides => _getSlides(widget.subject.type);

  @override
  void initState() {
    super.initState();
    AudioManager().playBgm(widget.subject.bgmAsset);
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _autoController = AnimationController(
        vsync: this, duration: const Duration(seconds: 6));
    _autoController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _autoPlay) {
        _nextSlide();
      }
    });
    _autoController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _autoController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_slideIndex < _slides.length - 1) {
      _slideController.reset();
      _slideController.forward();
      setState(() => _slideIndex++);
      _autoController.reset();
      if (_autoPlay) _autoController.forward();
    } else {
      setState(() => _finished = true);
      _autoController.stop();
    }
  }

  void _prevSlide() {
    if (_slideIndex > 0) {
      _slideController.reset();
      _slideController.forward();
      setState(() => _slideIndex--);
      _autoController.reset();
      if (_autoPlay) _autoController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_slideIndex];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              _buildProgressBar(),
              Expanded(child: _buildSlide(slide)),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white70, size: 26),
          ),
          const Spacer(),
          Text('${widget.subject.emoji} Pelajaran ${widget.subject.name}',
              style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() {
              _autoPlay = !_autoPlay;
              if (_autoPlay) _autoController.forward();
              else _autoController.stop();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _autoPlay ? widget.subject.primaryColor.withOpacity(0.3) : Colors.white12,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _autoPlay ? widget.subject.primaryColor : Colors.white24),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_autoPlay ? Icons.pause : Icons.play_arrow,
                    color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(_autoPlay ? 'Auto' : 'Manual',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            children: _slides.asMap().entries.map((e) {
              final active = e.key == _slideIndex;
              final done = e.key < _slideIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      color: done
                          ? widget.subject.primaryColor
                          : active
                              ? widget.subject.secondaryColor.withOpacity(0.7)
                              : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: active && _autoPlay
                        ? AnimatedBuilder(
                            animation: _autoController,
                            builder: (_, __) => LinearProgressIndicator(
                              value: _autoController.value,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(
                                  widget.subject.primaryColor),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text('${_slideIndex + 1} / ${_slides.length}',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSlide(LessonSlide slide) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main emoji illustration
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: slide.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: slide.accentColor.withOpacity(0.3)),
            ),
            child: Text(slide.emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 90)),
          )
              .animate(key: ValueKey('emoji_$_slideIndex'))
              .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 28),
          // Title
          Text(slide.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: slide.accentColor, fontWeight: FontWeight.w800))
              .animate(key: ValueKey('title_$_slideIndex'))
              .fadeIn(delay: 150.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          // Body text
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: slide.accentColor.withOpacity(0.2)),
            ),
            child: Text(slide.body,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.6,
                    fontWeight: FontWeight.w500)),
          )
              .animate(key: ValueKey('body_$_slideIndex'))
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: _finished
          ? SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  AudioManager().playClick();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GameScreen(
                            subject: widget.subject, level: 2)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.subject.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Mula Game! 🚀',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ),
            )
              .animate()
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut)
          : Row(
              children: [
                if (_slideIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevSlide,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: Colors.white24),
                      ),
                      child: const Text('◀ Sebelum',
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ),
                  ),
                if (_slideIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _nextSlide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.subject.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                        _slideIndex == _slides.length - 1
                            ? 'Tamat! 🎉'
                            : 'Seterusnya ▶',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
    );
  }

  static List<LessonSlide> _getSlides(SubjectType type) {
    switch (type) {
      case SubjectType.math:
        return [
          LessonSlide(emoji: '🔢', accentColor: AppTheme.mathPrimary,
              title: 'Nombor & Kira!',
              body: 'Matematik adalah ilmu nombor!\nKita akan belajar cara menambah, menolak, mendarab dan membahagi.\nMari kita mulakan! 🚀'),
          LessonSlide(emoji: '➕🍎', accentColor: Color(0xFF9C8FFF),
              title: 'Tambah (Campur)',
              body: 'TAMBAH bermaksud mencantumkan dua kumpulan bersama.\n\n3 + 2 = 5\n\nCuba bayangkan: 3 epal + 2 epal = 5 epal! 🍎🍎🍎🍎🍎'),
          LessonSlide(emoji: '➖🌟', accentColor: Color(0xFF6C63FF),
              title: 'Tolak (Kurang)',
              body: 'TOLAK bermaksud mengambil sesuatu daripada kumpulan.\n\n7 - 3 = 4\n\nCuba bayangkan: 7 bintang, ambil 3... tinggal 4! ⭐⭐⭐⭐'),
          LessonSlide(emoji: '✖️🐣', accentColor: Color(0xFF3D35B5),
              title: 'Darab (Kali)',
              body: 'DARAB bermaksud tambah berulang kali!\n\n3 × 4 = 12\n\nErtinya: 3 + 3 + 3 + 3 = 12\nMudah bukan? 😊'),
          LessonSlide(emoji: '➗🍰', accentColor: Color(0xFF9C8FFF),
              title: 'Bahagi (Kongsi)',
              body: 'BAHAGI bermaksud kongsi sama rata!\n\n12 ÷ 3 = 4\n\nErtinya: Bahagikan 12 kek kepada 3 orang.\nSetiap orang dapat 4 kek! 🍰🍰🍰🍰'),
        ];
      case SubjectType.bm:
        return [
          LessonSlide(emoji: '📖✨', accentColor: AppTheme.bmPrimary,
              title: 'Bahasa Melayu!',
              body: 'Bahasa Melayu adalah bahasa kebangsaan kita!\nKita akan belajar kata nama, kata kerja, bina ayat dan kosa kata baru. Mari mulakan! 🇲🇾'),
          LessonSlide(emoji: '🏠🌳🐱', accentColor: Color(0xFF00C897),
              title: 'Kata Nama',
              body: 'KATA NAMA adalah nama bagi orang, tempat, haiwan atau benda.\n\n🏠 Rumah   🌳 Pokok\n🐱 Kucing   📚 Buku\n\nCuba cari kata nama di sekeliling kamu!'),
          LessonSlide(emoji: '🏃🍳📝', accentColor: Color(0xFF009970),
              title: 'Kata Kerja',
              body: 'KATA KERJA adalah perbuatan atau tindakan.\n\n🏃 Berlari   🍳 Memasak\n📝 Menulis   😴 Tidur\n\nKata kerja menerangkan APA yang dilakukan!'),
          LessonSlide(emoji: '✨🌺🦋', accentColor: Color(0xFF00E8B0),
              title: 'Kata Sifat',
              body: 'KATA SIFAT menerangkan sifat atau keadaan.\n\n🌺 Cantik   💪 Kuat\n🐘 Besar   🌟 Bijak\n\nGunakan kata sifat untuk jadikan ayat lebih menarik!'),
          LessonSlide(emoji: '💬🌟', accentColor: AppTheme.bmPrimary,
              title: 'Bina Ayat!',
              body: 'Ayat yang baik ada SUBJEK + PREDIKAT.\n\n"Ali berlari pantas."\n  ↑ Subjek  ↑ Predikat\n\nCuba bina ayat kamu sendiri! 🖊️'),
        ];
      case SubjectType.science:
        return [
          LessonSlide(emoji: '🔬🌍', accentColor: AppTheme.sciencePrimary,
              title: 'Dunia Sains!',
              body: 'Sains adalah ilmu tentang alam semesta kita!\nKita akan belajar tentang haiwan, tumbuhan dan fenomena alam yang menakjubkan! 🌟'),
          LessonSlide(emoji: '🦁🐬🦋🐝', accentColor: Color(0xFFFF8C42),
              title: 'Dunia Haiwan',
              body: 'Haiwan dibahagikan kepada:\n\n🥩 Karnivor — makan daging (Singa)\n🌿 Herbivor — makan tumbuhan (Lembu)\n🍖🌿 Omnivor — makan kedua-dua (Beruang)\n\nHaiwan manakah kamu suka?'),
          LessonSlide(emoji: '🌱☀️💧', accentColor: Color(0xFFE05A10),
              title: 'Dunia Tumbuhan',
              body: 'Tumbuhan membuat makanan sendiri melalui:\n\n☀️ FOTOSINTESIS\n\nBahan diperlukan:\n• Cahaya matahari\n• Air (H₂O)\n• Karbon dioksida (CO₂)\n\nKlorofil (zat hijau) menjadikannya boleh!'),
          LessonSlide(emoji: '🌧️☁️🌊', accentColor: Color(0xFFFF8C42),
              title: 'Kitaran Air',
              body: 'Air bergerak dalam kitaran!\n\n🌊 Sejatan — air menjadi wap\n☁️ Pemeluwapan — wap jadi awan\n🌧️ Kerpasan — hujan turun\n\nKitaran ini berulang selama-lamanya!'),
          LessonSlide(emoji: '🌈⚡🌋', accentColor: Color(0xFFFFB347),
              title: 'Fenomena Alam',
              body: 'Alam penuh dengan kejadian menakjubkan!\n\n🌈 Pelangi — cahaya + air hujan\n⚡ Petir — elektrik statik di awan\n🌋 Gunung Berapi — magma dari bumi\n\nSains menerangkan semua ini! 🔬'),
        ];
      case SubjectType.english:
        return [
          LessonSlide(emoji: '🌍📚', accentColor: AppTheme.englishPrimary,
              title: 'English Time!',
              body: 'English is spoken all around the world!\nWe will learn vocabulary, sentences and how to communicate in English. Let\'s go! 🚀'),
          LessonSlide(emoji: '👋😊🌅', accentColor: Color(0xFFFF4B7D),
              title: 'Greetings!',
              body: 'How to greet people in English:\n\n☀️ Good morning! — Pagi\n🌤️ Good afternoon! — Tengahari\n🌙 Good evening! — Petang/Malam\n👋 Hello! / Hi! — Hai!\n\nAlways smile when you greet! 😊'),
          LessonSlide(emoji: '🔴🔵🟡🟢', accentColor: Color(0xFFBF1050),
              title: 'Colors!',
              body: 'Learn your colors in English!\n\n🔴 Red — Merah\n🔵 Blue — Biru\n🟡 Yellow — Kuning\n🟢 Green — Hijau\n⚫ Black — Hitam\n⚪ White — Putih\n\nWhat\'s your favourite color?'),
          LessonSlide(emoji: '🐶🐱🐦🐟', accentColor: Color(0xFFFF7EA8),
              title: 'Animals!',
              body: 'Animal names in English:\n\n🐶 Dog — Anjing\n🐱 Cat — Kucing\n🐦 Bird — Burung\n🐟 Fish — Ikan\n🐰 Rabbit — Arnab\n🐘 Elephant — Gajah\n\nCan you name more animals?'),
          LessonSlide(emoji: '💬✏️', accentColor: AppTheme.englishPrimary,
              title: 'Simple Sentences!',
              body: 'Build sentences using:\nSubject + Verb + Object\n\n"I eat rice."\n"She reads a book."\n"He plays football."\n\nRemember: Add "s" to verb for he/she/it! 📝'),
        ];
    }
  }
}
