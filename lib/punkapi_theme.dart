import 'package:flutter/material.dart';

const kLightPrimaryColor = Color(0xFF00AFDA);

const kRobotoTextStyle = TextStyle(
  fontFamily: 'Roboto',
);

final lightTextStyle = kRobotoTextStyle.copyWith(
  color: Colors.black,
);

final darkTextStyle = kRobotoTextStyle.copyWith(
  color: Colors.white,
);

final lightTheme = ThemeData(
  primaryColor: kLightPrimaryColor,
  shadowColor: kLightPrimaryColor,
  colorScheme: ColorScheme.light(
    primary: kLightPrimaryColor,
    secondary: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    headlineSmall: lightTextStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: lightTextStyle.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: lightTextStyle.copyWith(
      fontSize: 13,
    ),
    bodyLarge: lightTextStyle.copyWith(
      fontSize: 20,
    ),
  ),
);

final darkTheme = ThemeData(
  shadowColor: Colors.white,
  colorScheme: ColorScheme.dark(
    primary: Colors.black,
    secondary: Colors.white,
    background: Colors.black87,
  ),
  cardColor: kLightPrimaryColor.withOpacity(0.5),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  textTheme: TextTheme(
    headlineSmall: darkTextStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: darkTextStyle.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: darkTextStyle.copyWith(
      fontSize: 13,
    ),
    bodyLarge: darkTextStyle.copyWith(
      fontSize: 22,
    ),
  ),
);
