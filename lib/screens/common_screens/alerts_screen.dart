import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/screens/common_screens/map_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertsScreen extends StatefulWidget {
  final bool isGuardian; // Ye line add karein
  const AlertsScreen({super.key, required this.isGuardian});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // 1. Firebase Reference
  final DatabaseReference _notifRef = FirebaseDatabase.instance.ref().child(
    'notifications',
  );

  // 2. Type based Icon Helper
  IconData _getIcon(String type) {
    switch (type) {
      case 'sos':
        return Icons.warning_amber_rounded;
      case 'location':
        return Icons.location_on_rounded;
      case 'battery':
        return Icons.battery_alert_rounded;
      case 'police':
        return Icons.local_police_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  // 3. Type based Color Helper
  Color _getColor(String type) {
    switch (type) {
      case 'sos':
        return Colors.red;
      case 'location':
        return Colors.blue;
      case 'battery':
        return Colors.orange;
      case 'police':
        return Colors.indigo;
      default:
        return Colors.green;
    }
  }

  void _clearAll() {
    _notifRef.remove();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All Alerts cleared'),
        backgroundColor: Color(0xFF8A5F9A),
      ),
    );
  }

  void _markRead(String id) {
    _notifRef.child(id).update({'read': true});
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber.trim());

    try {
      // Mode explicitly set karein
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching dialer: $e");
      // Fallback: Agar dialer fail ho toh snackbar dikhayein
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open dialer for: $phoneNumber")),
        );
      }
    }
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
              // ── APP BAR ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Alerts",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAll,
                      child: const Text(
                        "Clear All",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── REAL-TIME LIST ──────────────────────────────
              Expanded(
                child: StreamBuilder(
                  stream: _notifRef.orderByChild('timestamp').onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.snapshot.value == null) {
                      return _buildEmptyState();
                    }

                    // Firebase Data Parsing
                    final Map<dynamic, dynamic> data =
                        snapshot.data!.snapshot.value as Map;
                    List<Map<String, dynamic>> items = [];
                    data.forEach((key, value) {
                      items.add({
                        'id': key,
                        ...Map<String, dynamic>.from(value),
                      });
                    });

                    // Latest alerts on top
                    items.sort(
                      (a, b) => b['timestamp'].compareTo(a['timestamp']),
                    );

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final n = items[index];
                        final String type = n['type'] ?? 'default';
                        final Color color = _getColor(type);
                        final bool isUnread = n['read'] == false;

                        return GestureDetector(
                          onTap: () => _markRead(n['id']),
                          child: _buildAlertsCard(n, color, isUnread),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsCard(Map<String, dynamic> n, Color color, bool isUnread) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isUnread
            ? Border.all(color: color.withOpacity(0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        // Row ki jagah Column use karein taake buttons ko space mile
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upper Part: Icon, Title aur Body
          GestureDetector(
            onTap: () => _markRead(
              n['id'],
            ), // Sirf upper part par click se read mark hoga
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _getIcon(n['type'] ?? 'default'),
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n['title'] ?? "Alert",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n['subtitle'] ?? n['body'] ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.isGuardian &&
              n['type']?.toString().toLowerCase() == 'sos') ...[
            const SizedBox(height: 12),
            const Divider(height: 1), // Thori visual separation
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint("Navigation Triggered!"); // check in console
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map_sharp, size: 14),
                  label: const Text("Track Live"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    elevation:
                        2, // Elevation thori barha dein taake click asaan ho
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => _makePhoneCall(
                    n['phone'],
                  ), // Firebase se phone number uthaya
                  icon: const Icon(Icons.call, size: 14),
                  label: const Text("Call"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 14),
          const Text(
            "No notifications",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
