import 'package:flutter/material.dart';

class DeviceStatusScreen extends StatelessWidget {
  const DeviceStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "User's Device Status",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // <-- This changes the drawer icon color
        ),
        centerTitle: true,
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // USER & DEVICE INFO CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.pink.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Device Holder: Simra",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Device ID: SD-12455",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // LIVE STATUS BLOCKS
            Expanded(
              child: ListView(
                children: [
                  // CONNECTION STATUS
                  statusTile(
                    icon: Icons.wifi,
                    title: "Connection Status",
                    value: "Connected",
                    valueColor: Colors.green,
                  ),

                  statusTile(
                    icon: Icons.battery_full,
                    title: "Battery",
                    value: "78%",
                    valueColor: Colors.green,
                  ),

                  statusTile(
                    icon: Icons.location_on,
                    title: "Last Known Location",
                    value: "Multan • 2 mins ago",
                    valueColor: Colors.pink,
                  ),

                  statusTile(
                    icon: Icons.health_and_safety,
                    title: "User Safety Status",
                    value: "Safe",
                    valueColor: Colors.green,
                  ),

                  statusTile(
                    icon: Icons.warning_amber_rounded,
                    title: "Last Alert Triggered",
                    value: "No recent alerts",
                    valueColor: Colors.orange,
                  ),

                  statusTile(
                    icon: Icons.access_time_rounded,
                    title: "Last Sync Time",
                    value: "10:48 PM",
                    valueColor: Colors.pink,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET FOR EACH STATUS ROW
  Widget statusTile({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.pink.shade100, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.15),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.pink),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}