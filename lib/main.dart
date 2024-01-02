import 'package:flutter/material.dart';
import 'package:quiz_backoffice/constants/style.dart';
import 'package:quiz_backoffice/controllers/menu_controller.dart' as menu_controller;
import 'package:quiz_backoffice/controllers/navigation_controller.dart';
import 'package:quiz_backoffice/layout.dart';
import 'package:quiz_backoffice/pages/404/error.dart';
import 'package:quiz_backoffice/pages/authentication/authentication.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'routing/routes.dart';

void main() {
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: rootRoute,
      unknownRoute: GetPage(name: '/not-found', page: () => const PageNotFound(), transition: Transition.fadeIn),
      getPages: [
        GetPage(
            name: rootRoute,
            page: () {
              return SiteLayout();
            }),
        GetPage(name: authenticationPageRoute, page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Quiz Backoffice',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: MaterialColor(
          Color.fromRGBO(78, 114, 90, 1).value,
          <int, Color>{
            50: Color.fromRGBO(78, 114, 90, 1),
            100: Color.fromRGBO(78, 114, 90, 1),
            200: Color.fromRGBO(78, 114, 90, 1),
            300: Color.fromRGBO(78, 114, 90, 1),
            400: Color.fromRGBO(78, 114, 90, 1),
            500: Color.fromRGBO(78, 114, 90, 1),
            600: Color.fromRGBO(78, 114, 90, 1),
            700: Color.fromRGBO(78, 114, 90, 1),
            800: Color.fromRGBO(78, 114, 90, 1),
            900: Color.fromRGBO(78, 114, 90, 1),
          },
        ),
      ),
    );
  }
}