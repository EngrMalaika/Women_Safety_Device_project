import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final List<Map<String, dynamic>> _sections = const [
    {
      'number': '01',
      'title': 'Information We Collect',
      'icon': Icons.info_rounded,
      'color': Colors.blue,
      'content':
          'We collect information you provide directly such as your name, email address, phone number, and location data. We also collect device information and usage data to improve the app experience.',
    },
    {
      'number': '02',
      'title': 'How We Use Your Information',
      'icon': Icons.settings_rounded,
      'color': Colors.purple,
      'content':
          'Your information is used to provide safety features including real-time location tracking, emergency SOS alerts, and guardian notifications. We do not sell your personal data to third parties.',
    },
    {
      'number': '03',
      'title': 'Location Data',
      'icon': Icons.location_on_rounded,
      'color': Colors.green,
      'content':
          'This app requires access to your device\'s GPS location to provide live tracking and nearby services. Location data is only shared with your designated guardians and emergency services when an SOS is triggered.',
    },
    {
      'number': '04',
      'title': 'Data Security',
      'icon': Icons.lock_rounded,
      'color': Colors.orange,
      'content':
          'We implement industry-standard security measures to protect your personal information. All data is encrypted during transmission and storage.',
    },
    {
      'number': '05',
      'title': 'Third-Party Services',
      'icon': Icons.map_rounded,
      'color': Colors.teal,
      'content':
          'We use OpenStreetMap for location services. These services have their own privacy policies and we encourage you to review them.',
    },
    {
      'number': '06',
      'title': 'Your Rights',
      'icon': Icons.verified_user_rounded,
      'color': Colors.indigo,
      'content':
          'You have the right to access, modify, or delete your personal data at any time through the app settings. You may also contact us directly for data-related requests.',
    },
    {
      'number': '07',
      'title': 'Contact Us',
      'icon': Icons.mail_rounded,
      'color': Color(0xFF7B4F8E),
      'content':
          'If you have any questions about this Privacy Policy, please contact us at support@womensafetyapp.com',
    },
  ];

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
              // ── APP BAR ──────────────────────────────────
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
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      // ── HEADER CARD ──────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.privacy_tip_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Privacy Matters",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Last updated: March 2025",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── SECTIONS ─────────────────────────
                      ..._sections.map((s) => _buildSection(s)),

                      // ── FOOTER ───────────────────────────
                      const SizedBox(height: 4),
                      Text(
                        "© 2025 Women Safety Device App",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(Map<String, dynamic> s) {
    final Color color = s['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(s['icon'] as IconData, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      s['number'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: color.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        s['title'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Text(
                  s['content'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.grey.shade700,
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
