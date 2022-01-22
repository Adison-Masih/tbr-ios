import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_beauty_rox/core/my_store.dart';
import 'package:the_beauty_rox/models/DealModel.dart';
import 'package:the_beauty_rox/pages/login.dart';
import 'package:the_beauty_rox/pages/orders.dart';
import 'package:the_beauty_rox/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home.dart';
import 'pages/register.dart';
import 'pages/search.dart';
import 'utils/routes.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.containsKey('user_id');
  print(id.toString());
  runApp(
    VxState(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "The Beauty Rox",
        // initialRoute: Routes.loginRoute,
        initialRoute: id ? Routes.homeRoute : Routes.loginRoute,
        themeMode: ThemeMode.system,
        routes: {
          "/": (context) => const Home(),
          "/register": (context) => const RegisterPage(),
          "/login": (context) => const LoginPage(),
          "/deals": (context) => const SearchPage(),
          "/orders": (context) => const Orders(),
        },
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
      ),
      store: MyStore(),
    ),
  );
}
