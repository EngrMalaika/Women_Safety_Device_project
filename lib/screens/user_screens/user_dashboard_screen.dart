import 'package:flutter/material.dart';
import 'package:safety_app/screens/common_screens/voice_recordings_screen.dart';
import 'package:safety_app/screens/user_screens/alerts_screen.dart';
import 'package:safety_app/screens/user_screens/device_settings_screen.dart';
import 'package:safety_app/screens/common_screens/helplines_screen.dart';
import 'package:safety_app/screens/common_screens/high_alert_screen.dart';
import 'package:safety_app/screens/common_screens/map_screen.dart';
import 'package:safety_app/screens/common_screens/nearbyPolice_screen.dart';
import 'package:safety_app/screens/user_screens/settings_screen.dart';
import 'package:safety_app/screens/user_screens/track_guardian_screen.dart';
import 'package:safety_app/widgets/app_drawer.dart';

class UserDashboardScreen extends StatefulWidget {
  final String role;
  const UserDashboardScreen({required this.role, super.key});

  @override
  State<UserDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<UserDashboardScreen> {
  bool isPressed = false; // For tap animation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // In your Scaffold's drawer property:
drawer: AppDrawer(
  userName: "Malaika", // You should get this from your auth system // This should come from your user data
  onLogout: () {
    // Handle logout
    Navigator.pushReplacementNamed(context, '/welcome');
  },
  onMenuItemSelected: (menuItem) {
    Navigator.pop(context); // Close drawer first
    switch (menuItem) {
      case "dashboard":
        // Already on dashboard
        break;
      case "emergency_alert":
        Navigator.pushNamed(context, '/emergency_alert');
        break;
      case "helplines":
        Navigator.pushNamed(context, '/helplines');
        break;
      case "high_alert_areas":
        Navigator.pushNamed(context, '/high_alert_areas');
        break;
      case "nearby_police":
        Navigator.pushNamed(context, '/nearby_police');
        break;
      case "voice_recordings":
        Navigator.pushNamed(context, '/voice_recordings');
        break;
      case "track_guardian":
        Navigator.pushNamed(context, '/track_guardian');
        break;
      case "settings":
        Navigator.pushNamed(context, '/settings');
        break;
      case "device_settings":
        Navigator.pushNamed(context, '/device_settings');
        break;
      case "profile":
        Navigator.pushNamed(context, '/profile');
        break;
      // Add other cases as needed
      default:
        print("Selected: $menuItem");
    }
  },
),
      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 5,
        //shape: RoundedRectangleBorder(
        //borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        //),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- This changes the drawer icon color
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.pink),
                ),
              ),
            ),
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade50,
              const Color.fromARGB(255, 248, 247, 247),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // ---------------- TOP TWO CARDS ----------------
              Row(
                children: [
                  // -------- SOS ALERT CARD --------
                  Expanded(
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.3),
                            offset: Offset(0, 5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.pink,
                            size: 30,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "SOS Alert",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // -------- DEVICE STATUS CARD --------
                  Expanded(
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            offset: Offset(0, 5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.devices, color: Colors.green.shade800),
                          SizedBox(height: 6),
                          Text(
                            "Device: Connected",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Battery: 82%",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- GRID BUTTONS ----------------
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    menuCircle(Icons.map, "Map", MapScreen()),
                    menuCircle(
                      Icons.notifications_active,
                      "Alerts",
                      AlertsScreen(),
                    ),
                    menuCircle(
                      Icons.settings_remote,
                      "Device Settings",
                      DeviceSettingsScreen(userName: widget.role),
                    ),
                    menuCircle(
                      Icons.local_police,
                      "Nearby Police",
                      NearbyPoliceScreen(),
                    ),
                    menuCircle(
                      Icons.mic,
                      "Voice Recordings",
                      VoiceRecordingsScreen(),
                    ),
                    menuCircle(
                      Icons.location_searching,
                      "Track Guardian",
                      TrackGuardianScreen(),
                    ),
                    menuCircle(
                      Icons.support_agent,
                      "Helplines",
                      HelplinesScreen(),
                    ),
                    menuCircle(
                      Icons.warning_amber,
                      "High Alert Areas",
                      HighAlertAreasScreen(),
                    ),
                    menuCircle(Icons.settings, "Settings", SettingsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ ROUND GRADIENT BUTTON ------------------
  Widget menuCircle(IconData icon, String text, Widget destinationScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.pink.shade300, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.pink, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, size: 42, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }
}