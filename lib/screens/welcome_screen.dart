import 'package:flutter/material.dart';
import 'guardian_screens/login_guardian_screen.dart';
import 'user_screens/login_user_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------------- GRADIENT BACKGROUND ----------------
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 249, 162, 191),
                  Colors.pink.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // ---------------- MAIN CONTENT ----------------
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ---------------- ILLUSTRATION ICON ----------------
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(30),
                    child: Icon(
                      Icons.security,
                      size: 100,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ---------------- TITLE ----------------
                  Text(
                    "Welcome to Women Safety Device App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade900,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // ---------------- GUARDIAN BUTTON ----------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade700,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginGuardianScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Signup / Login As Guardian",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 252, 229, 237),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ---------------- USER BUTTON ----------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.pink, width: 2),
                      ),
                      elevation: 5,
                      shadowColor: Colors.pink.shade200,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginUserScreen()),
                      );
                    },
                    child: Text(
                      "Signup / Login As User",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // ---------------- FOOTER TEXT ----------------
                  Text(
                    "Stay Safe. Stay Confident.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.pink.shade800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}