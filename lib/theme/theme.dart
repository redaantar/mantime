import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

bool isDark = GetStorage().read('isDarkMode') ?? false;
const Color blueColor = Color(0xFF4e5ae8);
const Color yellowColor = Color(0xFFFFB746);
const Color pinkColor = Color(0xFFff4667);
const Color whiteColor = Colors.white;
const Color primaryColor = Color.fromARGB(255, 80, 67, 225);
const Color darkGreyColor = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

class Themes {
  static final dark = ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: const Color.fromARGB(255, 80, 67, 225),
      colorScheme: const ColorScheme.dark());

  static final light = ThemeData.light().copyWith(
      primaryColor: const Color.fromARGB(255, 80, 67, 225),
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light());
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingTextStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titleTextStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ));
}
