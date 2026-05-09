import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Subject Colors
  static const Color mathPrimary = Color(0xFF6C63FF);
  static const Color mathSecondary = Color(0xFF9C8FFF);
  static const Color bmPrimary = Color(0xFF00C897);
  static const Color bmSecondary = Color(0xFF00E8B0);
  static const Color sciencePrimary = Color(0xFFFF8C42);
  static const Color scienceSecondary = Color(0xFFFFB347);
  static const Color englishPrimary = Color(0xFFFF4B7D);
  static const Color englishSecondary = Color(0xFFFF7EA8);

  // Neutral Colors
  static const Color background = Color(0xFF0F1035);
  static const Color surface = Color(0xFF1A1D4E);
  static const Color cardBg = Color(0xFF252866);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3D6);
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color heartRed = Color(0xFFFF4444);
  static const Color streakOrange = Color(0xFFFF8C00);
  static const Color correctGreen = Color(0xFF00E676);
  static const Color wrongRed = Color(0xFFFF1744);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: mathPrimary,
          surface: surface,
        ),
        textTheme: GoogleFonts.nunitoTextTheme(
          const TextTheme(
            displayLarge: TextStyle(
                color: white, fontSize: 48, fontWeight: FontWeight.w800),
            displayMedium: TextStyle(
                color: white, fontSize: 36, fontWeight: FontWeight.w800),
            displaySmall: TextStyle(
                color: white, fontSize: 28, fontWeight: FontWeight.w700),
            headlineLarge: TextStyle(
                color: white, fontSize: 24, fontWeight: FontWeight.w700),
            headlineMedium: TextStyle(
                color: white, fontSize: 20, fontWeight: FontWeight.w700),
            headlineSmall: TextStyle(
                color: white, fontSize: 18, fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(color: white, fontSize: 16),
            bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
          ),
        ),
        cardTheme: CardTheme(
          color: cardBg,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mathPrimary,
            foregroundColor: white,
            elevation: 0,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: GoogleFonts.nunito(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      );

  // Subject gradients
  static LinearGradient mathGradient = const LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF3D35B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient bmGradient = const LinearGradient(
    colors: [Color(0xFF00C897), Color(0xFF009970)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient scienceGradient = const LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFE05A10)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient englishGradient = const LinearGradient(
    colors: [Color(0xFFFF4B7D), Color(0xFFBF1050)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFF0F1035), Color(0xFF1A0F3C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
