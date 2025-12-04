import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(fontSize: 57, fontWeight: FontWeight.bold),
    displayMedium: GoogleFonts.montserrat(fontSize: 45, fontWeight: FontWeight.bold),
    displaySmall: GoogleFonts.montserrat(fontSize: 36, fontWeight: FontWeight.bold),
    headlineLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold),
    headlineSmall: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold),
    titleMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
    titleSmall: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
    bodyLarge: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.normal),
    labelLarge: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
    bodySmall: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.normal),
    labelSmall: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.normal),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.montserrat(fontSize: 57, fontWeight: FontWeight.bold, color: Colors.white),
    displayMedium: GoogleFonts.montserrat(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
    displaySmall: GoogleFonts.montserrat(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
    headlineLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
    headlineSmall: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    titleSmall: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
    bodyMedium: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    labelLarge: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    bodySmall: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelSmall: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
  );
}
