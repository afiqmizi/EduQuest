import '../models/question.dart';
import '../models/subject.dart';

class ScienceQuestions {
  static List<Question> getQuestions(int difficulty) {
    final all = _allQuestions
        .where((q) => (q.difficulty - difficulty).abs() <= 2)
        .toList()
      ..shuffle();
    return all.take(5).toList();
  }

  static final List<Question> _allQuestions = [
    Question(
      id: 'sc1', subject: SubjectType.science, difficulty: 1,
      type: QuestionType.pictureQuiz,
      questionText: 'Haiwan apakah ini?',
      imageEmoji: '🦁',
      options: ['Harimau', 'Singa', 'Beruang', 'Serigala'],
      correctAnswer: 'Singa',
      explanation: 'Ini adalah SINGA! Singa dikenali sebagai Raja Hutan. 👑',
    ),
    Question(
      id: 'sc2', subject: SubjectType.science, difficulty: 1,
      type: QuestionType.pictureQuiz,
      questionText: 'Tumbuhan apakah ini?',
      imageEmoji: '🌵',
      options: ['Pokok Kelapa', 'Kaktus', 'Bunga Ros', 'Paku Pakis'],
      correctAnswer: 'Kaktus',
      explanation: 'Ini adalah KAKTUS! Kaktus boleh hidup di kawasan panas dan kering. 🌵',
    ),
    Question(
      id: 'sc3', subject: SubjectType.science, difficulty: 1,
      type: QuestionType.mcq,
      questionText: 'Apakah yang diperlukan oleh tumbuhan untuk membuat makanan?',
      options: ['Air sahaja', 'Cahaya matahari sahaja', 'Air, cahaya matahari & CO2', 'Tanah sahaja'],
      correctAnswer: 'Air, cahaya matahari & CO2',
      explanation: 'Tumbuhan perlukan air, cahaya matahari dan CO2 untuk proses fotosintesis! ☀️',
    ),
    Question(
      id: 'sc4', subject: SubjectType.science, difficulty: 1,
      type: QuestionType.mcq,
      questionText: 'Haiwan manakah yang boleh terbang?',
      options: ['Ikan', 'Arnab', 'Burung', 'Katak'],
      correctAnswer: 'Burung',
      explanation: 'Burung mempunyai sayap untuk terbang! 🐦',
    ),
    Question(
      id: 'sc5', subject: SubjectType.science, difficulty: 2,
      type: QuestionType.matching,
      questionText: 'Padankan haiwan dengan habitatnya!',
      options: ['Ikan', 'Burung Helang', 'Cacing', 'Monyet'],
      correctAnswer: 'Ikan',
      explanation: 'Setiap haiwan ada habitat yang sesuai!',
      matchPairs: [
        ['Ikan', 'Air 🌊'],
        ['Burung Helang', 'Langit ☁️'],
        ['Cacing', 'Tanah 🌍'],
        ['Monyet', 'Pokok 🌳'],
      ],
    ),
    Question(
      id: 'sc6', subject: SubjectType.science, difficulty: 2,
      type: QuestionType.mcq,
      questionText: 'Apakah yang berlaku semasa hujan?',
      options: ['Air dari bumi naik ke awan', 'Air dari awan turun ke bumi', 'Angin bertiup kencang', 'Matahari bersinar terang'],
      correctAnswer: 'Air dari awan turun ke bumi',
      explanation: 'Hujan berlaku apabila titisan air dalam awan jatuh ke bumi! 🌧️',
    ),
    Question(
      id: 'sc7', subject: SubjectType.science, difficulty: 3,
      type: QuestionType.mcq,
      questionText: 'Proses apakah yang digunakan tumbuhan untuk membuat makanan?',
      options: ['Respirasi', 'Fotosintesis', 'Evaporasi', 'Kondensasi'],
      correctAnswer: 'Fotosintesis',
      explanation: 'FOTOSINTESIS = foto (cahaya) + sintesis (membuat). Tumbuhan buat makanan guna cahaya! ☀️',
    ),
    Question(
      id: 'sc8', subject: SubjectType.science, difficulty: 3,
      type: QuestionType.dragDrop,
      questionText: 'Lengkapkan pernyataan!',
      sentenceTemplate: 'Haiwan yang makan daging sahaja dipanggil ___.',
      options: ['Karnivor', 'Herbivor', 'Omnivor', 'Dekomposer'],
      correctAnswer: 'Karnivor',
      explanation: 'KARNIVOR = haiwan pemakan daging. Contoh: Singa, Harimau! 🦁',
    ),
    Question(
      id: 'sc9', subject: SubjectType.science, difficulty: 3,
      type: QuestionType.mcq,
      questionText: 'Apakah gas yang kita sedut semasa bernafas?',
      options: ['Karbon dioksida', 'Nitrogen', 'Oksigen', 'Hidrogen'],
      correctAnswer: 'Oksigen',
      explanation: 'Kita menghirup OKSIGEN (O2) dan menghembuskan karbon dioksida (CO2)! 💨',
    ),
    Question(
      id: 'sc10', subject: SubjectType.science, difficulty: 4,
      type: QuestionType.mcq,
      questionText: 'Kitaran air terdiri daripada?',
      options: [
        'Sejatan, pemeluwapan, kerpasan',
        'Hujan, ribut, banjir',
        'Sungai, laut, awan',
        'Panas, sejuk, lembab',
      ],
      correctAnswer: 'Sejatan, pemeluwapan, kerpasan',
      explanation: 'Kitaran air: SEJATAN (evaporasi) → PEMELUWAPAN (kondensasi) → KERPASAN (hujan)! 🌊',
    ),
    Question(
      id: 'sc11', subject: SubjectType.science, difficulty: 4,
      type: QuestionType.matching,
      questionText: 'Padankan haiwan dengan jenis pemakanannya!',
      options: ['Singa', 'Lembu', 'Beruang', 'Arnab'],
      correctAnswer: 'Singa',
      explanation: 'Karnivor makan daging, Herbivor makan tumbuhan, Omnivor makan kedua-dua!',
      matchPairs: [
        ['Singa', 'Karnivor 🥩'],
        ['Lembu', 'Herbivor 🌿'],
        ['Beruang', 'Omnivor 🐻'],
        ['Arnab', 'Herbivor 🥕'],
      ],
    ),
    Question(
      id: 'sc12', subject: SubjectType.science, difficulty: 5,
      type: QuestionType.mcq,
      questionText: 'Apakah yang dimaksudkan dengan rantai makanan?',
      options: [
        'Haiwan yang hidup bersama',
        'Urutan pemakanan antara organisma',
        'Jenis-jenis makanan haiwan',
        'Cara haiwan memburu mangsa',
      ],
      correctAnswer: 'Urutan pemakanan antara organisma',
      explanation: 'Rantai makanan: Rumput → Belalang → Katak → Ular → Helang! 🌿',
    ),
    Question(
      id: 'sc13', subject: SubjectType.science, difficulty: 5,
      type: QuestionType.mcq,
      questionText: 'Apakah fungsi akar pada tumbuhan?',
      options: [
        'Membuat makanan',
        'Menyerap air dan mineral dari tanah',
        'Menghasilkan bunga',
        'Menarik serangga',
      ],
      correctAnswer: 'Menyerap air dan mineral dari tanah',
      explanation: 'Akar menyerap air dan mineral, serta memegang tumbuhan di tanah! 🌱',
    ),
    Question(
      id: 'sc14', subject: SubjectType.science, difficulty: 6,
      type: QuestionType.mcq,
      questionText: 'Apakah tiga keadaan jirim?',
      options: [
        'Pepejal, cecair, gas',
        'Keras, lembut, cair',
        'Panas, sejuk, sederhana',
        'Kayu, air, udara',
      ],
      correctAnswer: 'Pepejal, cecair, gas',
      explanation: 'Tiga keadaan jirim: PEPEJAL (es), CECAIR (air), GAS (wap air)! 💧',
    ),
    Question(
      id: 'sc15', subject: SubjectType.science, difficulty: 6,
      type: QuestionType.mcq,
      questionText: 'Apakah yang menyebabkan pelangi terbentuk?',
      options: [
        'Cahaya matahari melalui titisan air',
        'Angin kencang',
        'Awan tebal',
        'Petir dan kilat',
      ],
      correctAnswer: 'Cahaya matahari melalui titisan air',
      explanation: 'Pelangi terbentuk apabila cahaya matahari melewati titisan air hujan dan terurai menjadi warna! 🌈',
    ),
    Question(
      id: 'sc16', subject: SubjectType.science, difficulty: 7,
      type: QuestionType.mcq,
      questionText: 'Apakah yang dimaksudkan dengan ekosistem?',
      options: [
        'Kumpulan haiwan',
        'Komuniti organisma dan persekitarannya',
        'Jenis-jenis tumbuhan',
        'Kawasan hutan',
      ],
      correctAnswer: 'Komuniti organisma dan persekitarannya',
      explanation: 'Ekosistem = semua organisma hidup + persekitaran fizikal mereka yang berinteraksi!',
    ),
    Question(
      id: 'sc17', subject: SubjectType.science, difficulty: 8,
      type: QuestionType.mcq,
      questionText: 'Apakah peranan dekomposer dalam ekosistem?',
      options: [
        'Memburu mangsa',
        'Mengurai bahan organik mati',
        'Menghasilkan oksigen',
        'Menyerap karbon dioksida',
      ],
      correctAnswer: 'Mengurai bahan organik mati',
      explanation: 'Dekomposer (cendawan, bakteria) mengurai bahan mati menjadi nutrien untuk tumbuhan! 🍄',
    ),
    Question(
      id: 'sc18', subject: SubjectType.science, difficulty: 9,
      type: QuestionType.mcq,
      questionText: 'Apakah perbezaan antara sel haiwan dan sel tumbuhan?',
      options: [
        'Sel tumbuhan ada dinding sel, sel haiwan tidak',
        'Sel haiwan lebih besar',
        'Sel tumbuhan tidak ada nukleus',
        'Tiada perbezaan',
      ],
      correctAnswer: 'Sel tumbuhan ada dinding sel, sel haiwan tidak',
      explanation: 'Sel tumbuhan ada dinding sel (selulosa) & kloroplas yang tidak ada pada sel haiwan!',
    ),
    Question(
      id: 'sc19', subject: SubjectType.science, difficulty: 10,
      type: QuestionType.mcq,
      questionText: 'Apakah proses yang berlaku semasa metamorfosis kupu-kupu?',
      options: [
        'Telur → Ulat → Pupa → Kupu-kupu',
        'Telur → Kupu-kupu → Pupa',
        'Ulat → Telur → Pupa → Kupu-kupu',
        'Pupa → Ulat → Kupu-kupu',
      ],
      correctAnswer: 'Telur → Ulat → Pupa → Kupu-kupu',
      explanation: 'Metamorfosis lengkap: TELUR → ULAT (larva) → PUPA (kepompong) → KUPU-KUPU! 🦋',
    ),
  ];
}
