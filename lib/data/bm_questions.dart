import '../models/question.dart';
import '../models/subject.dart';

class BmQuestions {
  static List<Question> getQuestions(int difficulty) {
    final all = _allQuestions
        .where((q) => (q.difficulty - difficulty).abs() <= 2)
        .toList()
      ..shuffle();
    return all.take(5).toList();
  }

  static final List<Question> _allQuestions = [
    Question(
      id: 'bm1', subject: SubjectType.bm, difficulty: 1,
      type: QuestionType.pictureQuiz,
      questionText: 'Apakah ini?',
      imageEmoji: '🐱',
      options: ['Anjing', 'Kucing', 'Burung', 'Ikan'],
      correctAnswer: 'Kucing',
      explanation: 'Ini ialah kucing! Kata nama untuk haiwan ini ialah KUCING. 🐱',
    ),
    Question(
      id: 'bm2', subject: SubjectType.bm, difficulty: 1,
      type: QuestionType.pictureQuiz,
      questionText: 'Apakah ini?',
      imageEmoji: '🌺',
      options: ['Pokok', 'Buah', 'Bunga', 'Daun'],
      correctAnswer: 'Bunga',
      explanation: 'Ini ialah bunga! Bunga adalah kata nama am. 🌺',
    ),
    Question(
      id: 'bm3', subject: SubjectType.bm, difficulty: 1,
      type: QuestionType.mcq,
      questionText: 'Yang manakah KATA NAMA?',
      options: ['Berlari', 'Buku', 'Cantik', 'Cepat'],
      correctAnswer: 'Buku',
      explanation: '"Buku" adalah kata nama kerana ia adalah nama sesuatu benda! 📚',
    ),
    Question(
      id: 'bm4', subject: SubjectType.bm, difficulty: 1,
      type: QuestionType.mcq,
      questionText: 'Pilih kata yang betul: "Saya ___ nasi."',
      options: ['makan', 'cantik', 'besar', 'merah'],
      correctAnswer: 'makan',
      explanation: '"Makan" adalah kata kerja yang sesuai. 🍚',
    ),
    Question(
      id: 'bm5', subject: SubjectType.bm, difficulty: 2,
      type: QuestionType.dragDrop,
      questionText: 'Lengkapkan ayat!',
      sentenceTemplate: 'Ali ___ ke sekolah setiap hari.',
      options: ['pergi', 'makan', 'tidur', 'main'],
      correctAnswer: 'pergi',
      explanation: 'Ali PERGI ke sekolah setiap hari. 🏫',
    ),
    Question(
      id: 'bm6', subject: SubjectType.bm, difficulty: 2,
      type: QuestionType.matching,
      questionText: 'Padankan haiwan dengan emojinya!',
      options: ['Kucing', 'Ikan', 'Burung', 'Arnab'],
      correctAnswer: 'Kucing',
      explanation: 'Setiap haiwan ada nama tersendiri!',
      matchPairs: [
        ['Kucing', '🐱'],
        ['Ikan', '🐟'],
        ['Burung', '🐦'],
        ['Arnab', '🐰'],
      ],
    ),
    Question(
      id: 'bm7', subject: SubjectType.bm, difficulty: 3,
      type: QuestionType.mcq,
      questionText: 'Ayat manakah yang BETUL?',
      options: [
        'Budak itu berlari pantas.',
        'Berlari pantas budak itu.',
        'Pantas berlari budak itu.',
        'Itu budak berlari pantas.',
      ],
      correctAnswer: 'Budak itu berlari pantas.',
      explanation: 'Susunan betul: SUBJEK + PREDIKAT.',
    ),
    Question(
      id: 'bm8', subject: SubjectType.bm, difficulty: 3,
      type: QuestionType.mcq,
      questionText: 'Apakah erti kata "gigih"?',
      options: ['Malas', 'Rajin bersungguh-sungguh', 'Nakal', 'Sombong'],
      correctAnswer: 'Rajin bersungguh-sungguh',
      explanation: '"Gigih" bermaksud rajin dan bersungguh-sungguh! 💪',
    ),
    Question(
      id: 'bm9', subject: SubjectType.bm, difficulty: 3,
      type: QuestionType.dragDrop,
      questionText: 'Lengkapkan ayat!',
      sentenceTemplate: 'Ibu memasak ___ di dapur.',
      options: ['nasi', 'buku', 'kasut', 'pokok'],
      correctAnswer: 'nasi',
      explanation: 'Ibu memasak NASI di dapur. 🍳',
    ),
    Question(
      id: 'bm10', subject: SubjectType.bm, difficulty: 4,
      type: QuestionType.mcq,
      questionText: 'Apakah imbuhan dalam "berlari"?',
      options: ['ber-', '-lari', '-ri', 'la-'],
      correctAnswer: 'ber-',
      explanation: '"Ber-" adalah imbuhan awalan. 🏃',
    ),
    Question(
      id: 'bm11', subject: SubjectType.bm, difficulty: 4,
      type: QuestionType.mcq,
      questionText: 'Yang manakah KATA SIFAT?',
      options: ['Berlari', 'Meja', 'Cantik', 'Makan'],
      correctAnswer: 'Cantik',
      explanation: '"Cantik" adalah kata sifat! ✨',
    ),
    Question(
      id: 'bm12', subject: SubjectType.bm, difficulty: 4,
      type: QuestionType.matching,
      questionText: 'Padankan antonim!',
      options: ['Panas', 'Besar', 'Cepat', 'Tinggi'],
      correctAnswer: 'Panas',
      explanation: 'Antonim = perkataan bertentangan makna!',
      matchPairs: [
        ['Panas', 'Sejuk'],
        ['Besar', 'Kecil'],
        ['Cepat', 'Lambat'],
        ['Tinggi', 'Rendah'],
      ],
    ),
    Question(
      id: 'bm13', subject: SubjectType.bm, difficulty: 5,
      type: QuestionType.mcq,
      questionText: 'Manakah penggunaan "beliau" yang betul?',
      options: [
        'Beliau pergi ke pasar.',
        'Beliau adalah kawan saya.',
        'Cikgu beliau sangat baik.',
        'Semua betul.',
      ],
      correctAnswer: 'Semua betul.',
      explanation: '"Beliau" digunakan untuk orang yang dihormati!',
    ),
    Question(
      id: 'bm14', subject: SubjectType.bm, difficulty: 5,
      type: QuestionType.mcq,
      questionText: 'Maksud "bagai aur dengan tebing"?',
      options: ['Suka bertengkar', 'Saling membantu', 'Hidup sendiri', 'Tidak peduli'],
      correctAnswer: 'Saling membantu',
      explanation: 'Bermaksud saling memerlukan antara satu sama lain! 🤝',
    ),
    Question(
      id: 'bm15', subject: SubjectType.bm, difficulty: 6,
      type: QuestionType.mcq,
      questionText: '"Saya suka makan nasi ___ roti."',
      options: ['atau', 'tetapi', 'kerana', 'semasa'],
      correctAnswer: 'atau',
      explanation: '"Atau" menunjukkan pilihan antara dua perkara!',
    ),
    Question(
      id: 'bm16', subject: SubjectType.bm, difficulty: 7,
      type: QuestionType.mcq,
      questionText: 'Ayat pasif yang betul ialah?',
      options: [
        'Ali memukul bola.',
        'Bola dipukul oleh Ali.',
        'Ali sangat kuat.',
        'Bola itu besar.',
      ],
      correctAnswer: 'Bola dipukul oleh Ali.',
      explanation: 'Ayat pasif: objek di hadapan + dipukul + oleh + subjek!',
    ),
    Question(
      id: 'bm17', subject: SubjectType.bm, difficulty: 8,
      type: QuestionType.mcq,
      questionText: 'Kata kerja transitif memerlukan?',
      options: ['Tidak perlu objek', 'Objek', 'Masa lampau', 'Perulangan'],
      correctAnswer: 'Objek',
      explanation: 'Kata kerja transitif memerlukan objek. Contoh: memakan (APA?) = memerlukan objek!',
    ),
    Question(
      id: 'bm18', subject: SubjectType.bm, difficulty: 9,
      type: QuestionType.mcq,
      questionText: 'Manakah ayat majmuk?',
      options: [
        'Ali berlari.',
        'Dia cantik dan bijak.',
        'Pokok itu tinggi.',
        'Kucing berlari.',
      ],
      correctAnswer: 'Dia cantik dan bijak.',
      explanation: 'Ayat majmuk = dua atau lebih klausa digabungkan!',
    ),
  ];
}
