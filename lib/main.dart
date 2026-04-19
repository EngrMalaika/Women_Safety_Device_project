import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 1. Flutter engine ko initialize karna zaroori hai
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase ko start karna
  try {
    await Firebase.initializeApp();
    print("Firebase connected successfully!");
  } catch (e) {
    print("Firebase connect nahi ho saka: $e");
  }

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
