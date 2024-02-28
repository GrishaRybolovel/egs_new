import 'package:egs/ui/const.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final themeData = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: bgColor,
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
  canvasColor: secondaryColor,
);
