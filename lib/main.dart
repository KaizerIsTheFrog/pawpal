import 'package:flutter/material.dart';
import 'package:pawpal/screens/LoginScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Color(0xFFFFF8F0),
        ),
      ),
      home: LoginPage(),
    );
  }
}
