import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = Colors.indigo[400]!;
final Color secondaryColor = Colors.indigo[500]!;

final TextTheme notoSansDisplayTheme = TextTheme(
  headline1: GoogleFonts.notoSansDisplay(
      fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.notoSansDisplay(
      fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3:
      GoogleFonts.notoSansDisplay(fontSize: 46, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.notoSansDisplay(
      fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5:
      GoogleFonts.notoSansDisplay(fontSize: 23, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.notoSansDisplay(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.notoSansDisplay(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.notoSansDisplay(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.notoSansDisplay(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.notoSansDisplay(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.notoSansDisplay(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.notoSansDisplay(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.notoSansDisplay(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

final TextTheme poppinsTheme = TextTheme(
  headline1: GoogleFonts.poppins(
      fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.poppins(
      fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.poppins(
      fontSize: 32, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.poppins(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.poppins(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.poppins(
      fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        toolbarTextStyle: poppinsTheme.bodyText2,
        titleTextStyle: poppinsTheme.headline6),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedLabelStyle: poppinsTheme.caption,
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color(0XFFBDBDBD),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(side: BorderSide(color: secondaryColor))),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: primaryColor)),
    dialogTheme: DialogTheme(
        titleTextStyle: poppinsTheme.bodyText1?.copyWith(color: Colors.black),
        contentTextStyle:
            poppinsTheme.bodyText2?.copyWith(color: Colors.black)),
    inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        iconColor: secondaryColor,
        prefixIconColor: secondaryColor,
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
        labelStyle: TextStyle(color: secondaryColor)),
    listTileTheme: const ListTileThemeData(tileColor: Colors.white),
    iconTheme: const IconThemeData(color: Color(0xFF616161)));

ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor),
    scaffoldBackgroundColor: const Color(0xFF212121),
    appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF212121),
        toolbarTextStyle: poppinsTheme.bodyText2,
        titleTextStyle: poppinsTheme.headline6),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF212121),
      selectedLabelStyle: poppinsTheme.caption!.copyWith(fontSize: 11),
      unselectedLabelStyle: poppinsTheme.caption!.copyWith(fontSize: 10),
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color(0XFFBDBDBD),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white))),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: primaryColor)),
    dialogTheme: DialogTheme(
        titleTextStyle: poppinsTheme.bodyText1?.copyWith(color: Colors.black),
        contentTextStyle:
            poppinsTheme.bodyText2?.copyWith(color: Colors.black)),
    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        iconColor: Colors.white,
        prefixIconColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        labelStyle: TextStyle(color: Colors.white)),
    listTileTheme: const ListTileThemeData(tileColor: Color(0xFF212121)),
    iconTheme: const IconThemeData(color: Color(0xFF616161)),
    textTheme:
        poppinsTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF212121),
    ),
    canvasColor: Colors.grey,
    dividerColor: const Color(0xFF616161),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: primaryColor, textStyle: poppinsTheme.bodyText2)));
