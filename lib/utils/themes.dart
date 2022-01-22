import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.lato().fontFamily,
        cardColor: Colors.white,
        canvasColor: creamColor,
        buttonColor: Colors.deepPurple,
        accentColor: darkBluishColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        dividerColor: Colors.black,
        // appBarTheme: AppBarTheme(
        //   color: Colors.white,
        //   elevation: 0.0,
        //   iconTheme: IconThemeData(color: Colors.black),
        //   titleTextStyle: TextStyle(
        //     color: Colors.black,
        //     fontSize: 18.0,
        //   ),
        // ),
      );

  static ThemeData get darkTheme => ThemeData(
        dividerColor: Colors.white,
        primarySwatch: Colors.deepPurple,
        fontFamily: GoogleFonts.lato().fontFamily,
        accentColor: Colors.white,
        cardColor: Colors.black,
        canvasColor: darkCreamColor,
        buttonColor: lightBluishColor,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: lightBluishColor,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black38,
        ),
      );

  static Color creamColor = Vx.hexToColor("#e1e1e1");
  static Color darkCreamColor = Vx.gray900;
  static Color darkBluishColor = const Color(0xff403b58);
  static Color lightBluishColor = Vx.indigo500;
}
