import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final VoidCallback onLogout;
  final Function(String) onMenuItemSelected;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.onLogout,
    required this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // -------- User Info Header --------
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: Colors.pink,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // -------- Menu Items --------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Home
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.pink),
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("home");
                    },
                  ),

                  // Profile
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.pink),
                    title: const Text("Profile"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("profile");
                    },
                  ),

                  // Notifications
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.pink),
                    title: const Text("Notifications"),
                    trailing: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("notifications");
                    },
                  ),

                  // Settings
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.pink),
                    title: const Text("Settings"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("settings");
                    },
                  ),

                  const Divider(),

                  // App Info
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blue),
                    title: const Text("About App"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("about_app");
                    },
                  ),

                  // Rate App
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text("Rate App"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("rate_app");
                    },
                  ),

                  // Share App
                  ListTile(
                    leading: const Icon(Icons.share, color: Colors.green),
                    title: const Text("Share App"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("share_app");
                    },
                  ),

                  // Send Feedback
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.purple),
                    title: const Text("Send Feedback"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("send_feedback");
                    },
                  ),

                  // Privacy Policy
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.teal),
                    title: const Text("Privacy Policy"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("privacy_policy");
                    },
                  ),

                  // Terms of Service
                  ListTile(
                    leading: const Icon(Icons.description, color: Colors.orange),
                    title: const Text("Terms of Service"),
                    onTap: () {
                      Navigator.pop(context);
                      onMenuItemSelected("terms_of_service");
                    },
                  ),

                  const Divider(),

                  // Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
                      onLogout();
                    },
                  ),

                  // App Version
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
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