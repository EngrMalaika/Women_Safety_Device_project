import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareAppScreen extends StatelessWidget {
  const ShareAppScreen({super.key});

  static const String _appLink =
      "https://drive.google.com/file/d/your_link_here";
  static const String _shareMessage =
      "🛡️ Stay Safe with our Women Safety App!\n"
      "Get real-time tracking and SOS alerts.\n\n"
      "📲 Download here: $_appLink";

  // ── FIX: WhatsApp, SMS & Email Methods ──────────────────

  static Future<void> _shareWhatsApp(BuildContext context) async {
    // Official API link use ki hai jo installed app ko behtar handle karta hai
    final Uri url = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(_shareMessage)}",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      _showSnack(context, "Could not launch WhatsApp", Colors.orange);
    }
  }

  static Future<void> _shareSMS(BuildContext context) async {
    final Uri url = Uri.parse(
      "sms:?body=${Uri.encodeComponent(_shareMessage)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Agar canLaunchUrl fail ho jaye toh direct launch try karein
      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        _showSnack(context, "SMS app not found", Colors.orange);
      }
    }
  }

  static Future<void> _shareNative() async {
    await Share.share(_shareMessage, subject: "Women Safety Device App");
  }

  static Future<void> _shareEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      query:
          'subject=${Uri.encodeComponent("Women Safety App")}&body=${Uri.encodeComponent(_shareMessage)}',
    );

    try {
      // try launching with external application mode for Android 11+
      bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showSnack(context, "No email app found", Colors.orange);
      }
    } catch (e) {
      // Agar external fail ho jaye toh normal launch try karein
      try {
        await launchUrl(emailUri);
      } catch (err) {
        _showSnack(context, "Error opening email: $err", Colors.red);
      }
    }
  }

  static void _copyLink(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: _appLink));
    _showSnack(context, "Link copied to clipboard! 📋", Colors.green);
  }

  static void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      _buildHeaderCard(),
                      const SizedBox(height: 20),
                      _buildMainShareCard(context),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "Share App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white38),
      ),
      child: Column(
        children: [
          const Icon(Icons.share_rounded, color: Colors.white, size: 50),
          const SizedBox(height: 15),
          const Text(
            "Share with Loved Ones",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            "Help keep your friends and family safe",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainShareCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(Icons.link_rounded, "App Link", Colors.blue),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    _appLink,
                    style: TextStyle(fontSize: 12, color: Color(0xFF1976D2)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: () => _copyLink(context),
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: Colors.white,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4F8E),
                ),
              ),
            ],
          ),
          const Divider(height: 40),
          _sectionLabel(
            Icons.send_rounded,
            "Quick Share",
            const Color(0xFF7B4F8E),
          ),
          const SizedBox(height: 20),
          // ── UPDATED: Row with Email and SMS logic ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _shareOption(
                Icons.message_rounded,
                "SMS",
                Colors.green,
                onTap: () => _shareSMS(context),
              ),
              _shareOption(
                Icons.email_rounded,
                "Email",
                Colors.blue,
                onTap: () => _shareEmail(context),
              ),
              _shareOption(
                Icons.chat_rounded,
                "WhatsApp",
                Colors.teal,
                onTap: () => _shareWhatsApp(context),
              ),
              _shareOption(
                Icons.more_horiz_rounded,
                "More",
                Colors.purple,
                onTap: () => _shareNative(),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: () => Share.share(_shareMessage),
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "Share Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Widget _shareOption(
    IconData icon,
    String label,
    Color color, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
