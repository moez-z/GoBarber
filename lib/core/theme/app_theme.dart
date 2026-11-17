import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const bg = Color(0xFF090D16), card = Color(0xFF111827), el = Color(0xFF1E293B);
  static const amber = Color(0xFFF59E0B), amberHi = Color(0xFFFFC174), text = Color(0xFFF8FAFC);
  static const muted = Color(0xFF94A3B8), ok = Color(0xFF10B981), err = Color(0xFFEF4444);
  static const blue = Color(0xFF8FD5FF);
}

const muted = TextStyle(color: C.muted, fontSize: 13);

/// [lang] is 'fr' or 'ar'. Arabic uses Cairo (Inter has no Arabic glyphs).
/// Pass `googleFonts: false` in tests to avoid network font downloads.
ThemeData appTheme(String lang, {bool googleFonts = true}) {
  final base = ThemeData.dark(useMaterial3: true);
  final textTheme = !googleFonts
      ? base.textTheme
      : lang == 'ar'
          ? GoogleFonts.cairoTextTheme(base.textTheme)
          : GoogleFonts.interTextTheme(base.textTheme);
  OutlineInputBorder ob(Color c) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: c));
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(primary: C.amber, onPrimary: C.bg, surface: C.card, error: C.err),
    textTheme: textTheme.apply(bodyColor: C.text, displayColor: C.text),
    appBarTheme: const AppBarTheme(backgroundColor: C.bg, elevation: 0, scrolledUnderElevation: 0),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: C.card, indicatorColor: C.amber.withValues(alpha: .2)),
    inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: const Color(0xFF0D131F),
        border: ob(C.el), enabledBorder: ob(C.el), focusedBorder: ob(C.amber)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: C.amber, foregroundColor: C.bg,
            disabledBackgroundColor: C.el, minimumSize: const Size.fromHeight(48),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: C.text, side: const BorderSide(color: Color(0xFF334155)),
            minimumSize: const Size.fromHeight(48), shape: const StadiumBorder())),
  );
}
