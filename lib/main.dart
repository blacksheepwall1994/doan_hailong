import 'package:doan_along/routes/routes.dart';
import 'package:doan_along/util/constain.dart';
import 'package:doan_along/util/mqtt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: kPrimaryMainColor,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodyText1: const TextStyle(color: Colors.white, fontSize: 20),
          bodyText2: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      initialRoute: AppPages.initial,
    );
  }
}
