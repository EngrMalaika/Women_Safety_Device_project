import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeviceStatusScreen extends StatefulWidget {
  const DeviceStatusScreen({super.key});

  @override
  State<DeviceStatusScreen> createState() => _DeviceStatusScreenState();
}

class _DeviceStatusScreenState extends State<DeviceStatusScreen>
    with TickerProviderStateMixin {
  // Naya Firebase Reference: Jo node hum ne discuss kiya tha
  final DatabaseReference _statusRef = FirebaseDatabase.instance.ref(
    "devices/SD-12455/status",
  );

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3), Color(0xFFD4B8DA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.32, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 12),

              // --- STREAMBUILDER START ---
              Expanded(
                child: StreamBuilder(
                  stream: _statusRef.onValue,
                  builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                    // Check karein agar data load ho raha hai ya null hai
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data?.snapshot.value == null) {
                      return const Center(
                        child: Text(
                          "No device data found",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    // Firebase se data extract karein
                    final Map<dynamic, dynamic> data =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                    final bool isOnline = data['is_online'] ?? false;
                    final int battery = data['battery'] ?? 0;
                    final String lastSync = data['last_sync'] ?? "N/A";
                    final String location = data['location'] ?? "Unknown";
                    final String safetyStatus = data['safety_status'] ?? "Safe";

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        children: [
                          _buildUserCard(safetyStatus),
                          const SizedBox(height: 14),
                          _buildBatteryCard(battery),
                          const SizedBox(height: 10),
                          _buildStatusTiles(
                            isOnline,
                            location,
                            safetyStatus,
                            lastSync,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // --- STREAMBUILDER END ---
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components with Dynamic Data ---

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              "Device Status",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ScaleTransition(scale: _pulseAnimation, child: _liveBadge()),
        ],
      ),
    );
  }

  Widget _buildUserCard(String safety) {
    bool isSafe = safety.toUpperCase() == "SAFE";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white38, width: 1),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Simra",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "ID: SD-12455",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSafe ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              safety.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryCard(int level) {
    Color batteryColor = level > 20 ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.battery_full_rounded, color: batteryColor, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "$level%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            width: 100,
            height: 10,
            color: Colors.grey.shade100,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: level / 100,
              child: Container(color: batteryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTiles(
    bool isOnline,
    String location,
    String safety,
    String syncTime,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _statusRow(
            Icons.wifi_rounded,
            "Connection",
            isOnline ? "Connected" : "Offline",
            isOnline ? Colors.green : Colors.red,
            true,
          ),
          _statusRow(
            Icons.location_on_rounded,
            "Location",
            location,
            const Color(0xFF7B4F8E),
            true,
          ),
          _statusRow(
            Icons.health_and_safety_rounded,
            "Safety",
            safety,
            safety == "Safe" ? Colors.green : Colors.red,
            true,
          ),
          _statusRow(
            Icons.access_time_rounded,
            "Last Sync",
            syncTime,
            const Color(0xFF7B4F8E),
            false,
          ),
        ],
      ),
    );
  }

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, color: Colors.white, size: 8),
          SizedBox(width: 5),
          Text(
            "LIVE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(
    IconData icon,
    String title,
    String value,
    Color color,
    bool divider,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (divider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
