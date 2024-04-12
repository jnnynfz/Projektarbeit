import 'package:flutter/material.dart';

class AppColors {
  static Color primaryBlue = Color(0xFF141C6C);
  static const Color secondaryBlue = Color(0xFF00C2C9);
  static Color primaryRed = Color(0xFFFC0404);
  static Color secondaryGrey = Color(0xFFEEEEEE)!;
  static Color? cardColor = Color.fromARGB(255, 255, 255, 255);
  static Color backgroundColor = Color.fromARGB(255, 245, 244, 244);
  static const Color primaryFontColor = Color(0xFF000000);
  static const Color secondaryFontColor = Color(0xFF9E9E9E);
  static const Color accentFontColor = Color(0xFF141C6C);
}

class AppCardStyle{
  static const EdgeInsets cardMargin =  EdgeInsets.all(8.0);
  static const double borderRadiusValue = 8.0;
  static BorderRadiusGeometry get cardBorderRadius => BorderRadius.circular(borderRadiusValue);
  static const EdgeInsets innerPadding = EdgeInsets.all(15.0);
}


class AppTextStyle{
  static const double titleSize = 24.0;
  static const double largeFontSize = 18.0;
  static const double regularFontSize = 16.0;
  static const double smallFontSize = 12.0;
}


