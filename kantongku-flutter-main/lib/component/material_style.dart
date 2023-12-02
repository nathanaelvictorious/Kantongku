import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kantongku/component/color.dart';

class GlobalMaterialAppStyle {
  static ThemeData materialApp(context) {
    return ThemeData(
      useMaterial3: false,
        primaryColor: GlobalColors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: GlobalColors.blue,
          secondary: GlobalColors.lightBlue,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme));
  }
}
