import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RosewaterApp());
}

class RosewaterApp extends StatelessWidget {
  const RosewaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      title: 'Rosewater Cafe',
      home: const SplashScreen(),
    );
  }
}
