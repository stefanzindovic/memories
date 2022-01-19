import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/theme/colors.dart';

generateTheme() {
  return ThemeData(
    scaffoldBackgroundColor: darkColor,
    shadowColor: shadowColor,
    primaryColor: primaryColor,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    // application bar styles
    appBarTheme: AppBarTheme(
      titleSpacing: 20.w,
      backgroundColor: darkColor,
      titleTextStyle: GoogleFonts.encodeSans(
        color: lightColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
      actionsIconTheme: IconThemeData(
        size: 35.w,
        color: lightColor,
      ),
    ),

    // elevated button style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        onPrimary: lightColor,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.r),
        ),
        textStyle: GoogleFonts.encodeSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // text button style
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
        backgroundColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        textStyle: GoogleFonts.encodeSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // input text fields style
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      errorMaxLines: 4,
      errorStyle: GoogleFonts.encodeSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: errorColor,
      ),
      fillColor: backgroundColor,
      hintStyle: GoogleFonts.encodeSans(
        color: textColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    ),

    // bottom navigation bar style
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: darkColor,
      unselectedItemColor: textColor,
      selectedItemColor: primaryColor,
      unselectedIconTheme: IconThemeData(size: 25.w),
      selectedIconTheme: IconThemeData(size: 25.w),
      selectedLabelStyle: GoogleFonts.encodeSans(fontSize: 10.sp),
      unselectedLabelStyle: GoogleFonts.encodeSans(fontSize: 10.sp),
    ),

    // text styles
    textTheme: TextTheme(
      bodyText1: GoogleFonts.encodeSans(
        fontSize: 14.sp,
        color: textColor,
        fontWeight: FontWeight.w400,
      ),
      bodyText2: GoogleFonts.encodeSans(
        fontSize: 14.sp,
        color: lightColor,
        fontWeight: FontWeight.w400,
      ),
      headline1: GoogleFonts.encodeSans(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: lightColor,
      ),
      headline2: GoogleFonts.encodeSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: lightColor,
      ),
      headline3: GoogleFonts.encodeSans(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: lightColor,
      ),
    ),

    // card styles
    cardTheme: CardTheme(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.r), side: BorderSide.none),
      margin: EdgeInsetsDirectional.only(bottom: 20.h),
    ),

    // icon styles
    iconTheme: IconThemeData(
      color: textColor,
      size: 20.w,
    ),

    // popup menu styles
    popupMenuTheme: PopupMenuThemeData(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.r),
      ),
      textStyle: GoogleFonts.encodeSans(
        fontSize: 14.sp,
        color: lightColor,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
