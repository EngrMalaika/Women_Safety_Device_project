import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safety_app/screens/common_screens/map_screen.dart';
import 'package:safety_app/screens/common_screens/helplines_screen.dart';
import 'package:safety_app/screens/common_screens/high_alert_screen.dart';
import 'package:safety_app/screens/common_screens/nearbyPolice_screen.dart';
import 'package:safety_app/screens/common_screens/voice_recordings_screen.dart';
import 'package:safety_app/screens/guardian_screens/alerts_screen.dart';
import 'package:safety_app/screens/guardian_screens/device_status_screen.dart';
import 'package:safety_app/screens/guardian_screens/settings_screen.dart';
import 'package:safety_app/screens/guardian_screens/user_health_screen.dart';
import 'package:safety_app/screens/common_screens/profile_screen.dart';
import 'package:safety_app/screens/common_screens/notifications_screen.dart';
import 'package:safety_app/screens/common_screens/about_app_screen.dart';
import 'package:safety_app/screens/common_screens/privacy_policy_screen.dart';
import 'package:safety_app/screens/common_screens/terms_of_service_screen.dart';
import 'package:safety_app/screens/common_screens/send_feedback_screen.dart';
import 'package:safety_app/screens/common_screens/rate_app_screen.dart';
import 'package:safety_app/screens/common_screens/share_app_screen.dart';
import 'package:safety_app/widgets/app_drawer.dart';

class GuardianDashboardScreen extends StatefulWidget {
  final String role;
  const GuardianDashboardScreen({required this.role, super.key});

  @override
  State<GuardianDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<GuardianDashboardScreen>
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
      duration: const Duration(milliseconds: 1200),
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
      drawer: AppDrawer(
        userName: "Guardian",
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

      // ── GRADIENT APPBAR ───────────────────────────────────────
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
          "Guardian Dashboard",
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
                      "LIVE",
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

      // ── BODY ─────────────────────────────────────────────────
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
                _buildMiniMap(),
                const SizedBox(height: 10),
                _buildTrackingCard(),
                const SizedBox(height: 12),
                Expanded(child: _buildGrid()),
              ],
            ),
          ),
        ),
      ),

      // ── SOS FAB ──────────────────────────────────────────────
      floatingActionButton: ScaleTransition(
        scale: _pulseAnimation,
        child: FloatingActionButton.extended(
          onPressed: () => _showSOSDialog(),
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.warning_rounded, size: 24),
          label: const Text(
            'SOS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ── MINI MAP ──────────────────────────────────────────────────
  Widget _buildMiniMap() {
    return GestureDetector(
      onTap: () => _go(const MapScreen()),
      child: Container(
        height: 168,
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
                          'Tap for Live Tracking',
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

  // ── TRACKING CARD ─────────────────────────────────────────────
  Widget _buildTrackingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7B4F8E).withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pulsing avatar
          Stack(
            alignment: Alignment.center,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7B4F8E).withOpacity(0.25),
                      width: 3,
                    ),
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF7B4F8E),
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tracking: Sarah Khan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.shield_rounded,
                      color: Colors.green,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Safe  •  Updated 2 min ago',
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
          // Active badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'ACTIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── GRID ──────────────────────────────────────────────────────
  Widget _buildGrid() {
    final items = [
      _GridItem(
        Icons.notifications_active_rounded,
        "Alerts",
        const Color(0xFFE53935),
        () => _go(AlertsScreen()),
      ),
      _GridItem(
        Icons.health_and_safety_rounded,
        "User Health",
        const Color(0xFF2E7D32),
        () => _go(const UserHealthScreen()),
      ),
      _GridItem(
        Icons.map_rounded,
        "Live Map",
        const Color(0xFF1565C0),
        () => _go(const MapScreen()),
      ),
      _GridItem(
        Icons.settings_remote_rounded,
        "Device",
        const Color(0xFFE65100),
        () => _go(DeviceStatusScreen()),
      ),
      _GridItem(
        Icons.mic_rounded,
        "Recordings",
        const Color(0xFF6A1B9A),
        () => _go(VoiceRecordingsScreen()),
      ),
      _GridItem(
        Icons.support_agent_rounded,
        "Helplines",
        const Color(0xFF00695C),
        () => _go(HelplinesScreen()),
      ),
      _GridItem(
        Icons.warning_amber_rounded,
        "High Alert",
        const Color(0xFFF57F17),
        () => _go(HighAlertAreasScreen()),
      ),
      _GridItem(
        Icons.local_police_rounded,
        "Police",
        const Color(0xFF283593),
        () => _go(NearbyPoliceScreen()),
      ),
      _GridItem(
        Icons.settings_rounded,
        "Settings",
        const Color(0xFF546E7A),
        () => _go(SettingsScreen()),
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 80),
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

  // ── SOS DIALOG ────────────────────────────────────────────────
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
              'Emergency Alert',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text('Send emergency alert to emergency contacts?'),
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
                  content: Text('Emergency alert sent to contacts!'),
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
              'Send Alert',
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
