import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../res/colors.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      // Define the primary and accent colors
      primaryColor: ColorPalette.darkSlateBlue,
      scaffoldBackgroundColor: ColorPalette.softMintGreen,
      hintColor: ColorPalette.brightEmeraldGreen,

      // Define the color scheme
      colorScheme: const ColorScheme(
        primary: ColorPalette.darkSlateBlue,
        secondary: ColorPalette.brightEmeraldGreen,
        surface: ColorPalette.pureWhite,
        error: ColorPalette.softCoralPink,
        onPrimary: ColorPalette.pureWhite,
        onSecondary: ColorPalette.black,
        onSurface: ColorPalette.navyBlack,
        onError: ColorPalette.pureWhite,
        brightness: Brightness.light,
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(

        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: GoogleFonts.katibeh(
          color: ColorPalette.navyBlack,
          fontSize: Constants.fontSizeLarge,
          // fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: ColorPalette.navyBlack,
        ),
      ),

      // Text Theme
      textTheme: GoogleFonts.ubuntuTextTheme(
          TextTheme(
            displayLarge: const TextStyle(
              fontSize: Constants.fontSizeLarge + 4,
              fontWeight: FontWeight.bold,
              color: ColorPalette.navyBlack,
            ),
            headlineSmall: const TextStyle(
              fontSize: Constants.fontSizeLarge,
              fontWeight: FontWeight.w600,
              color: ColorPalette.darkSlateBlue,
            ),
            bodyLarge: const TextStyle(
              fontSize: Constants.fontSizeMedium,
              color: ColorPalette.darkSlateBlue,
            ),
            bodyMedium: const TextStyle(
              fontSize: Constants.fontSizeSmall,
              color: ColorPalette.navyBlack,
            ),
            labelLarge: const TextStyle(
              fontSize: Constants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: ColorPalette.pureWhite,
            ),
            titleMedium: const TextStyle(
              fontSize: Constants.fontSizeMedium,
              color: ColorPalette.darkSlateBlue,
            ),
            bodySmall: TextStyle(
              fontSize: Constants.fontSizeSmall,
              color: ColorPalette.navyBlack.withOpacity(0.6),
            ),
          )

      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: ColorPalette.pureWhite,
        size: 18,
      ),

      // Button Themes
      buttonTheme: ButtonThemeData(
        buttonColor: ColorPalette.brightEmeraldGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
        ),
        height: Constants.buttonHeight,
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: ColorPalette.pureWhite,
          backgroundColor: ColorPalette.brightEmeraldGreen,
          padding: const EdgeInsets.symmetric(
            vertical: Constants.paddingSmall,
            horizontal: Constants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
          ),
          textStyle: GoogleFonts.ubuntu(
            fontSize: Constants.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorPalette.softMintGreen,
        contentPadding: const EdgeInsets.symmetric(
          vertical: Constants.paddingSmall,
          horizontal: Constants.paddingMedium,
        ),
        hintStyle: TextStyle(
          color: ColorPalette.navyBlack.withOpacity(0.5),
          fontSize: Constants.fontSizeMedium,
        ),
        labelStyle: const TextStyle(
          color: ColorPalette.darkSlateBlue,
          fontSize: Constants.fontSizeMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusSmall),
          borderSide: const BorderSide(
            color: ColorPalette.darkSlateBlue,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
          borderSide: const BorderSide(
            color: ColorPalette.darkSlateBlue,
            width: 2,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: ColorPalette.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
          side: BorderSide(
            color: ColorPalette.darkSlateBlue.withOpacity(0.1),
            width: 1,
          ),
        ),
        elevation: 2,
        margin: const EdgeInsets.all(Constants.marginSmall),
      ),

      // BottomNavigationBar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorPalette.darkSlateBlue,
        selectedItemColor: ColorPalette.brightEmeraldGreen,
        unselectedItemColor: ColorPalette.pureWhite.withOpacity(0.7),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: Constants.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: Constants.fontSizeSmall,
          fontWeight: FontWeight.w400,
        ),
      ),

    );
  }
}
