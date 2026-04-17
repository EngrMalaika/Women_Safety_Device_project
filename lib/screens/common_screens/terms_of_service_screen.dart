import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  final List<Map<String, dynamic>> _sections = const [
    {
      'number': '01',
      'title': 'Acceptance of Terms',
      'icon': Icons.check_circle_rounded,
      'color': Colors.green,
      'content':
          'By using the Women Safety Device app, you agree to these Terms of Service. If you do not agree, please do not use the app.',
    },
    {
      'number': '02',
      'title': 'App Usage',
      'icon': Icons.phone_android_rounded,
      'color': Colors.blue,
      'content':
          'This app is designed for personal safety purposes only. You agree not to misuse the app or use it for any unlawful purposes.',
    },
    {
      'number': '03',
      'title': 'SOS & Emergency Features',
      'icon': Icons.warning_rounded,
      'color': Colors.red,
      'content':
          'The SOS feature is for genuine emergencies only. Misuse of emergency alerts may result in account suspension. We are not responsible for response times of emergency services.',
    },
    {
      'number': '04',
      'title': 'Guardian Consent',
      'icon': Icons.people_rounded,
      'color': Colors.purple,
      'content':
          'By registering as a Guardian, you consent to receiving emergency notifications and location updates from the users you are linked to.',
    },
    {
      'number': '05',
      'title': 'Account Responsibility',
      'icon': Icons.lock_rounded,
      'color': Colors.orange,
      'content':
          'You are responsible for maintaining the confidentiality of your account credentials. Notify us immediately of any unauthorized use of your account.',
    },
    {
      'number': '06',
      'title': 'Limitation of Liability',
      'icon': Icons.gavel_rounded,
      'color': Colors.teal,
      'content':
          'We strive to provide reliable service but cannot guarantee 100% uptime. We are not liable for any damages arising from service interruptions or failures.',
    },
    {
      'number': '07',
      'title': 'Changes to Terms',
      'icon': Icons.edit_note_rounded,
      'color': Colors.indigo,
      'content':
          'We may update these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
    },
    {
      'number': '08',
      'title': 'Contact',
      'icon': Icons.mail_rounded,
      'color': Color(0xFF7B4F8E),
      'content':
          'For questions regarding these terms, contact us at support@womensafetyapp.com',
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
                        "Terms of Service",
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
                                Icons.description_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Terms of Service",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Effective: March 2025",
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
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(s['icon'] as IconData, color: color, size: 20),
          ),
          const SizedBox(width: 12),
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
