import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wada/wada_bottom_navigation.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return MaterialApp(
      title: 'Wada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2A5AFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2A5AFF),
          secondary: const Color(0xFF3BC57D),
          background: Colors.white,
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const WadaBottomNavigation(),
    );
  }
}