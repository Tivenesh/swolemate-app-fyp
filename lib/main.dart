// lib/main.dart
import 'package:flutter/material.dart';
import 'package:swolemate_app/screens/auth_screen.dart'; // We'll create this file next, this import will initially show an error, which is normal.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwoleMate',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize your app's main color here
      ),
      home: const AuthScreen(), // This is where your authentication screen will be displayed
    );
  }
}