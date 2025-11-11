import 'package:flutter/material.dart';
import 'Pantallas/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediExpress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE8F3FF), // Fondo azul claro
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFE8F9FF),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF4A90E2)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
