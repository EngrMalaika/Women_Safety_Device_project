import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(WomenSafetyApp());
}

class WomenSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Safety Device',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}