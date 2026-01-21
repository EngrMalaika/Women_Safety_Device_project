import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- This changes the drawer icon color
        ),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // -------- ACCOUNT DETAILS --------
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.pink),
              title: const Text("John Doe"),
              subtitle: const Text("john.doe@example.com"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.pink),
                onPressed: () {
                  // Edit account info
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // -------- EDIT OPTIONS --------
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          const SizedBox(height: 20),

          // -------- APP INFO --------
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.pink),
              title: const Text("App Info"),
              subtitle: const Text("Version 1.0.0"),
              onTap: () {
                // Show more app info
              },
            ),
          ),

          const SizedBox(height: 20),

          // -------- LOGOUT BUTTON --------
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () {
                // Perform logout action
              },
            ),
          ),
        ],
      ),
    );
  }
}