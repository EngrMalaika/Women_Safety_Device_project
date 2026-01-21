import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safety_app/screens/common_screens/map_screen.dart';
import 'package:safety_app/widgets/app_drawer.dart';

class GuardianDashboardScreen extends StatefulWidget {
  final String role;
  const GuardianDashboardScreen({required this.role, super.key});

  @override
  State<GuardianDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<GuardianDashboardScreen> {
  bool isPressed = false; // For tap animation
  final MapController _mapController = MapController();
  LatLng _userLocation = const LatLng(31.582045, 74.329376); // Default location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 5,
        title: const Text(
          "Guardian Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search contacts or locations...",
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // ---------------- MINI MAP WIDGET ----------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                },
                child: Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // OpenStreetMap
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _userLocation,
                            initialZoom: 15,
                            interactiveFlags: InteractiveFlag.none, // Disable interaction for mini map
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.womensafety.app',
                              subdomains: const ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _userLocation,
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // Tap overlay with instructions
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap for Live Tracking',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3,
                                          color: Colors.black54,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // User Info Card
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.pink,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tracking: Sarah Khan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Status: Safe • Last updated: 2 min ago',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ---------------- QUICK ACTIONS GRID ----------------
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  padding: const EdgeInsets.all(10),
                  children: [
                    _menuCircle(
                      Icons.notifications_active,
                      "Alerts",
                      Colors.red,
                      () {
                        _showComingSoon(context, "Alerts");
                      },
                    ),
                    _menuCircle(
                      Icons.health_and_safety,
                      "User Health",
                      Colors.green,
                      () {
                        _showComingSoon(context, "User Health Monitoring");
                      },
                    ),
                    _menuCircle(
                      Icons.map,
                      "Live Map",
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MapScreen()),
                        );
                      },
                    ),
                    _menuCircle(
                      Icons.settings_remote,
                      "Device",
                      Colors.orange,
                      () {
                        _showComingSoon(context, "Device Status");
                      },
                    ),
                    _menuCircle(
                      Icons.mic,
                      "Recordings",
                      Colors.purple,
                      () {
                        _showComingSoon(context, "Voice Recordings");
                      },
                    ),
                    _menuCircle(
                      Icons.support_agent,
                      "Helplines",
                      Colors.teal,
                      () {
                        _showComingSoon(context, "Helplines");
                      },
                    ),
                    _menuCircle(
                      Icons.warning_amber,
                      "High Alert",
                      Colors.amber,
                      () {
                        _showComingSoon(context, "High Alert Areas");
                      },
                    ),
                    _menuCircle(
                      Icons.local_police,
                      "Police",
                      Colors.indigo,
                      () {
                        _showComingSoon(context, "Nearby Police");
                      },
                    ),
                    _menuCircle(
                      Icons.settings,
                      "Settings",
                      Colors.grey,
                      () {
                        _showComingSoon(context, "Settings");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Emergency SOS Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showEmergencyDialog(context);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.warning),
        label: const Text('SOS'),
      ),
    );
  }

  // ------------------ ROUND GRID BUTTON ------------------
  Widget _menuCircle(IconData icon, String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  offset: const Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Icon(icon, size: 34, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to show coming soon message
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text('Emergency Alert'),
          ],
        ),
        content: const Text('Send emergency alert to emergency contacts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency alert sent to contacts!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}