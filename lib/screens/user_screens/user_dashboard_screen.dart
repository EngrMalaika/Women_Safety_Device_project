import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safety_app/screens/common_screens/voice_recordings_screen.dart';
import 'package:safety_app/screens/user_screens/alerts_screen.dart';
import 'package:safety_app/screens/user_screens/device_settings_screen.dart';
import 'package:safety_app/screens/common_screens/helplines_screen.dart';
import 'package:safety_app/screens/common_screens/high_alert_screen.dart';
import 'package:safety_app/screens/common_screens/map_screen.dart';
import 'package:safety_app/screens/common_screens/nearbyPolice_screen.dart';
import 'package:safety_app/screens/user_screens/settings_screen.dart';
import 'package:safety_app/screens/user_screens/track_guardian_screen.dart';
import 'package:safety_app/screens/common_screens/profile_screen.dart';
import 'package:safety_app/screens/common_screens/notifications_screen.dart';
import 'package:safety_app/screens/common_screens/about_app_screen.dart';
import 'package:safety_app/screens/common_screens/privacy_policy_screen.dart';
import 'package:safety_app/screens/common_screens/terms_of_service_screen.dart';
import 'package:safety_app/screens/common_screens/send_feedback_screen.dart';
import 'package:safety_app/screens/common_screens/rate_app_screen.dart';
import 'package:safety_app/screens/common_screens/share_app_screen.dart';
import 'package:safety_app/widgets/app_drawer.dart';

class UserDashboardScreen extends StatefulWidget {
  final String role;
  const UserDashboardScreen({required this.role, super.key});

  @override
  State<UserDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<UserDashboardScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final LatLng _userLocation = const LatLng(31.582045, 74.329376);

  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── DRAWER ──────────────────────────────────────────────
      drawer: AppDrawer(
        userName: "Malaika",
        onLogout: () => Navigator.pushReplacementNamed(context, '/welcome'),
        onMenuItemSelected: (menuItem) {
          Navigator.pop(context);
          switch (menuItem) {
            case "home":
              break;
            case "profile":
              _go(const ProfileScreen());
              break;
            case "notifications":
              _go(const NotificationsScreen());
              break;
            case "settings":
              _go(const SettingsScreen());
              break;
            case "about_app":
              _go(const AboutAppScreen());
              break;
            case "rate_app":
              _go(const RateAppScreen());
              break;
            case "share_app":
              _go(const ShareAppScreen());
              break;
            case "send_feedback":
              _go(const SendFeedbackScreen());
              break;
            case "privacy_policy":
              _go(const PrivacyPolicyScreen());
              break;
            case "terms_of_service":
              _go(const TermsOfServiceScreen());
              break;
            default:
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$menuItem coming soon!')));
          }
        },
      ),

      // ── GRADIENT APPBAR ─────────────────────────────────────
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                    SizedBox(width: 5),
                    Text(
                      "SAFE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── BODY ────────────────────────────────────────────────
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEBDBF0), const Color(0xFFF3F3F3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // ── MINI MAP ──────────────────────────────────
                _buildMiniMap(),
                const SizedBox(height: 10),

                // ── SOS + DEVICE CARDS ────────────────────────
                _buildTopCards(),
                const SizedBox(height: 12),

                // ── GRID ──────────────────────────────────────
                Expanded(child: _buildGrid()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── MINI MAP ────────────────────────────────────────────────
  Widget _buildMiniMap() {
    return GestureDetector(
      onTap: () => _go(const MapScreen()),
      child: Container(
        height: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF7B4F8E).withOpacity(0.22),
              offset: const Offset(0, 6),
              blurRadius: 18,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _userLocation,
                  initialZoom: 15,
                  interactiveFlags: InteractiveFlag.none,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
              // gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.18),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Top location chip
              Positioned(
                top: 10,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF7B4F8E),
                        size: 13,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Lahore, PK",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom tap hint
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, color: Colors.white, size: 15),
                        SizedBox(width: 6),
                        Text(
                          'Tap for Live Map',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
    );
  }

  // ── SOS + DEVICE CARDS ───────────────────────────────────────
  Widget _buildTopCards() {
    return Row(
      children: [
        // SOS Card
        Expanded(
          child: GestureDetector(
            onTap: () => _showSOSDialog(),
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                height: 95,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.35),
                      offset: const Offset(0, 5),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.white, size: 30),
                    SizedBox(height: 6),
                    Text(
                      "SOS Alert",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Tap to Send",
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Device Status Card
        Expanded(
          child: Container(
            height: 95,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  offset: const Offset(0, 5),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.devices_rounded,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Device",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 9),
                    const SizedBox(width: 5),
                    const Text(
                      "Connected",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.battery_charging_full,
                      color: Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Battery: 82%",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── GRID ────────────────────────────────────────────────────
  Widget _buildGrid() {
    final items = [
      _GridItem(
        Icons.map_rounded,
        "Map",
        const Color(0xFF1565C0),
        () => _go(const MapScreen()),
      ),
      _GridItem(
        Icons.notifications_active_rounded,
        "Alerts",
        const Color(0xFFE53935),
        () => _go(AlertsScreen()),
      ),
      _GridItem(
        Icons.settings_remote_rounded,
        "Device Settings",
        const Color(0xFFE65100),
        () => _go(DeviceSettingsScreen(userName: widget.role)),
      ),
      _GridItem(
        Icons.local_police_rounded,
        "Nearby Police",
        const Color(0xFF283593),
        () => _go(NearbyPoliceScreen()),
      ),
      _GridItem(
        Icons.mic_rounded,
        "Recordings",
        const Color(0xFF6A1B9A),
        () => _go(VoiceRecordingsScreen()),
      ),
      _GridItem(
        Icons.location_searching_rounded,
        "Track Guardian",
        const Color(0xFF00695C),
        () => _go(TrackGuardianScreen()),
      ),
      _GridItem(
        Icons.support_agent_rounded,
        "Helplines",
        const Color(0xFF2E7D32),
        () => _go(HelplinesScreen()),
      ),
      _GridItem(
        Icons.warning_amber_rounded,
        "High Alert",
        const Color(0xFFF57F17),
        () => _go(HighAlertAreasScreen()),
      ),
      _GridItem(
        Icons.settings_rounded,
        "Settings",
        const Color(0xFF546E7A),
        () => _go(SettingsScreen()),
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildBtn(items[i]),
    );
  }

  Widget _buildBtn(_GridItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    item.color.withOpacity(0.18),
                    item.color.withOpacity(0.07),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: item.color.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Icon(item.icon, size: 27, color: item.color),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SOS DIALOG ──────────────────────────────────────────────
  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'Emergency SOS',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to send an emergency alert to your guardian?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency alert sent to guardian!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Send SOS',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _go(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _GridItem(this.icon, this.label, this.color, this.onTap);
}
