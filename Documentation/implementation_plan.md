# 🎓 EduQuest — Flutter Interactive Educational Game

A gamified learning app for primary school students covering **Matematik**, **Bahasa Melayu**, **Sains**, and **Bahasa Inggeris**.

---

## Overview

**EduQuest** is a Flutter + Dart educational game with:
- 4 subjects, each with unlimited levels
- Level 1 = animated intro "lesson" (video-style animated sequence with narration cues)
- Level 2+ = interactive quiz games (MCQ, drag & drop, matching, picture quiz)
- Adaptive difficulty, lives, streaks, stars, badges, and score tracking

Since Flutter cannot embed actual video files easily without assets, **Level 1 will use a rich animated storyboard sequence** (Flutter animations + lottie/rive-style custom animations with auto-advancing slides) that mimics a video lesson with subtitles — this gives the same "video lesson" experience natively on all platforms.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Provider + ChangeNotifier |
| Animations | Flutter's built-in AnimationController + Hero |
| Audio | `audioplayers` package |
| Local Storage | `shared_preferences` |
| UI Extras | `google_fonts`, `flutter_animate` |

---

## Project Structure

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + theme
├── core/
│   ├── theme.dart                  # Colors, text styles, child-friendly design
│   ├── audio_manager.dart          # Sound effects & BGM
│   └── game_state.dart             # Global state (scores, lives, streaks)
├── models/
│   ├── subject.dart                # Subject enum & metadata
│   ├── question.dart               # Question model (MCQ, drag, match, picture)
│   └── player_progress.dart        # Per-subject progress & badges
├── data/
│   ├── math_questions.dart
│   ├── bm_questions.dart
│   ├── science_questions.dart
│   └── english_questions.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart            # Main menu with subject selection
│   ├── subject_hub_screen.dart     # Subject landing (levels list)
│   ├── lesson_screen.dart          # Level 1: animated story lesson
│   ├── game_screen.dart            # Level 2+: quiz game wrapper
│   └── result_screen.dart          # Post-level result & rewards
├── widgets/
│   ├── mascot_widget.dart          # Cartoon guide character
│   ├── lives_bar.dart
│   ├── streak_indicator.dart
│   ├── score_counter.dart
│   ├── star_reward.dart
│   └── question_types/
│       ├── mcq_question.dart
│       ├── drag_drop_question.dart
│       ├── matching_question.dart
│       └── picture_quiz_question.dart
└── providers/
    ├── game_provider.dart
    └── progress_provider.dart
```

---

## Feature Details

### 1. Home Screen
- Animated splash with EduQuest mascot (Owly the owl 🦉)
- 4 colorful subject cards with unique icons & gradients:
  - 🔢 Matematik — Blue/Purple
  - 📖 Bahasa Melayu — Green/Teal
  - 🔬 Sains — Orange/Yellow
  - 🌍 Bahasa Inggeris — Pink/Red
- Player name + total stars displayed at top

### 2. Subject Hub Screen
- Shows current level, stars earned, and badge collection
- "Play" button launches current level
- Locked/unlocked level indicators

### 3. Level 1 — Animated Lesson Screen
Auto-advancing animated slides (like a video) with:
- Large colorful illustrations (emoji + Flutter drawing)
- Animated text subtitles
- "Voice" cue text (placeholder for TTS / audio)
- Progress dots at bottom
- "Mula Game! 🚀" button after last slide

**Content per subject (5 slides):**
| Subject | Topics |
|---|---|
| Matematik | Numbers, Tambah, Tolak, Darab, Bahagi |
| BM | Kata Nama, Kata Kerja, Bina Ayat, Kosa Kata |
| Sains | Haiwan, Tumbuhan, Air, Udara, Fenomena |
| BI | Greetings, Numbers, Colors, Animals, Simple Sentences |

### 4. Game Screen (Level 2+)
Wraps 5 questions per level. Each question can be one of:
- **MCQ** — 4 animated option buttons
- **Drag & Drop** — drag word/number to correct blank
- **Matching** — tap pairs to match
- **Picture Quiz** — image shown, pick correct label

HUD: Lives (❤️❤️❤️), Streak 🔥, Score counter, Question progress

### 5. Adaptive Difficulty
```
difficulty = baseLevel + (correctStreak / 3) - (wrongStreak / 2)
difficulty = clamp(difficulty, 1, 10)
```
Question bank is tagged by difficulty 1–10. Questions are randomly sampled from ±1 band.

### 6. Result Screen
- Stars awarded (1–3 based on score %)
- Score breakdown + streak bonus
- Badge unlock animation if milestone reached
- "Next Level" or "Try Again" buttons

### 7. Game Elements
| Element | Detail |
|---|---|
| Score | 10 pts per correct answer |
| Streak Bonus | +5 per consecutive correct after 3 |
| Lives | 3 per level; lose on wrong answer |
| Stars | 1★ = 60%, 2★ = 80%, 3★ = 100% |
| Badges | First Win, 10-Streak, Perfect Level, Subject Master |

---

## Proposed Changes

### [NEW] Flutter Project
#### [NEW] `pubspec.yaml`
#### [NEW] `lib/main.dart`
#### [NEW] `lib/app.dart`
#### [NEW] `lib/core/theme.dart`
#### [NEW] `lib/core/game_state.dart`
#### [NEW] `lib/models/subject.dart`
#### [NEW] `lib/models/question.dart`
#### [NEW] `lib/models/player_progress.dart`
#### [NEW] `lib/data/math_questions.dart`
#### [NEW] `lib/data/bm_questions.dart`
#### [NEW] `lib/data/science_questions.dart`
#### [NEW] `lib/data/english_questions.dart`
#### [NEW] `lib/screens/splash_screen.dart`
#### [NEW] `lib/screens/home_screen.dart`
#### [NEW] `lib/screens/subject_hub_screen.dart`
#### [NEW] `lib/screens/lesson_screen.dart`
#### [NEW] `lib/screens/game_screen.dart`
#### [NEW] `lib/screens/result_screen.dart`
#### [NEW] `lib/widgets/` — all widget files
#### [NEW] `lib/providers/game_provider.dart`
#### [NEW] `lib/providers/progress_provider.dart`

---

## Open Questions

> [!IMPORTANT]
> **Target Platform**: Should this be Android-only, iOS-only, or cross-platform (Android + Web + Desktop)?

> [!IMPORTANT]
> **Audio**: Should I include actual sound effects / background music using `audioplayers` package? (Requires `.mp3` assets or URLs)

> [!NOTE]
> **Level 1 Video**: Since there are no actual video assets, Level 1 will use a **rich animated storyboard** (Flutter animation slides with subtitles + emoji visuals). This gives the same educational effect as a video lesson. Is this acceptable?

> [!NOTE]
> **Language**: All in-game text will be in **Bahasa Melayu** as the primary language, with English labels where appropriate.

---

## Verification Plan

### Build & Run
- `flutter pub get`
- `flutter run` on Android emulator / device

### Manual Verification
- Test all 4 subject flows (Lesson → Game → Result)
- Verify adaptive difficulty increases per level
- Verify lives system, streak counter, star rewards
- Verify shared_preferences saves progress across sessions
