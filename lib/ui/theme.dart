import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const lightScaffoldBackgroundColor = Color(0xFFFAFBFF);
const darkScaffoldBackgroundColor = Color(0xFF171616);

const lightCanvasColor = Color(0xFFFFFFFF);
const darkCanvasColor = Color(0xFF1E1E1E);

final lightThemeData = ThemeData.light().copyWith(
  scaffoldBackgroundColor: lightCanvasColor,
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),
  canvasColor: lightCanvasColor,
  brightness: Brightness.light
);

final darkThemeData = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: darkCanvasColor,
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
  canvasColor: darkCanvasColor,
  brightness: Brightness.dark
);
