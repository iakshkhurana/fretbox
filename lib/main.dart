import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FretboxApp());
}

class FretboxApp extends StatelessWidget {
  const FretboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIET Resident App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC62B6D)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
