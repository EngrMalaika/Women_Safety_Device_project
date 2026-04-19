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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────
          _buildHeader(userName),

          // ── MENU ITEMS ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _menuItem(
                    context,
                    Icons.home_rounded,
                    "Home",
                    "home",
                    const Color(0xFF7B4F8E),
                  ),
                  _menuItem(
                    context,
                    Icons.person_rounded,
                    "Profile",
                    "profile",
                    const Color(0xFF1565C0),
                  ),

                  _divider("Settings"),

                  _menuItem(
                    context,
                    Icons.settings_rounded,
                    "Settings",
                    "settings",
                    const Color(0xFF546E7A),
                  ),
                  _menuItem(
                    context,
                    Icons.info_rounded,
                    "About App",
                    "about_app",
                    const Color(0xFF00897B),
                  ),

                  _divider("Support"),

                  _menuItem(
                    context,
                    Icons.star_rounded,
                    "Rate App",
                    "rate_app",
                    const Color(0xFFF9A825),
                  ),
                  _menuItem(
                    context,
                    Icons.share_rounded,
                    "Share App",
                    "share_app",
                    const Color(0xFF6A1B9A),
                  ),
                  _divider("Legal"),

                  _menuItem(
                    context,
                    Icons.privacy_tip_rounded,
                    "Privacy Policy",
                    "privacy_policy",
                    const Color(0xFF283593),
                  ),
                  _menuItem(
                    context,
                    Icons.description_rounded,
                    "Terms of Service",
                    "terms_of_service",
                    const Color(0xFF4E342E),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── LOGOUT BUTTON ────────────────────────────────────
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // ── PROFILE HEADER ───────────────────────────────────────────
  Widget _buildHeader(String name) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 38),
            ),
          ),
          const SizedBox(height: 14),
          // Name
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "guardian@example.com",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Online badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38, width: 1),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                    SizedBox(width: 5),
                    Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── SECTION DIVIDER LABEL ────────────────────────────────────
  Widget _divider(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade400,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // ── MENU ITEM ────────────────────────────────────────────────
  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String label,
    String key,
    Color color,
  ) {
    return InkWell(
      onTap: () => onMenuItemSelected(key),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ── LOGOUT BUTTON ────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onLogout();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD32F2F), Color(0xFFEF5350)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
