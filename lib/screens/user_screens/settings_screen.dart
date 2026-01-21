import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- ACCOUNT SECTION --------
            const Text(
              "Account",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.pink,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "John Doe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "john.doe@example.com",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "User ID: UID-12345",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.pink),
                      onPressed: () => _editProfile(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // -------- GENERAL SETTINGS --------
            const Text(
              "General Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.notifications,
                    title: "Notifications",
                    subtitle: "Manage notification preferences",
                    onTap: () => _openNotificationsSettings(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.security,
                    title: "Privacy & Security",
                    subtitle: "Privacy settings and permissions",
                    onTap: () => _openPrivacySettings(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.language,
                    title: "Language",
                    subtitle: "English (US)",
                    onTap: () => _changeLanguage(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.palette,
                    title: "Theme",
                    subtitle: "Light theme",
                    onTap: () => _changeTheme(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- APP SETTINGS --------
            const Text(
              "App Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.phone,
                    title: "Emergency Contacts",
                    subtitle: "Manage emergency numbers",
                    onTap: () => _openEmergencyContacts(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.devices,
                    title: "Device Settings",
                    subtitle: "Configure device preferences",
                    onTap: () => _openDeviceSettings(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.location_on,
                    title: "Location Settings",
                    subtitle: "Location tracking preferences",
                    onTap: () => _openLocationSettings(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.volume_up,
                    title: "Sound & Vibration",
                    subtitle: "Alert sounds and vibrations",
                    onTap: () => _openSoundSettings(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- SAFETY SETTINGS --------
            const Text(
              "Safety Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSwitchSetting(
                  icon: Icons.vibration,
                    title: "Shake to Alert",
                    subtitle: "Shake phone to send emergency alert",
                    value: true,
                    onChanged: (value) {},
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSwitchSetting(
                    icon: Icons.power_settings_new,
                    title: "Power Button SOS",
                    subtitle: "Press power button 3 times for SOS",
                    value: true,
                    onChanged: (value) {},
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.timer,
                    title: "SOS Timer",
                    subtitle: "Set countdown duration",
                    onTap: () => _setSOSTimer(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.warning,
                    title: "Alert Preferences",
                    subtitle: "Customize alert types",
                    onTap: () => _openAlertPreferences(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- ACCOUNT MANAGEMENT --------
            const Text(
              "Account Management",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.lock_reset,
                    title: "Change Password",
                    subtitle: "Update your password",
                    onTap: () => _changePassword(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.email,
                    title: "Change Email",
                    subtitle: "Update your email address",
                    onTap: () => _changeEmail(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.phone_iphone,
                    title: "Change Phone Number",
                    subtitle: "Update your phone number",
                    onTap: () => _changePhoneNumber(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.delete,
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    color: Colors.red,
                    onTap: () => _deleteAccount(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- SUPPORT --------
            const Text(
              "Support",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.help,
                    title: "Help & Support",
                    subtitle: "Get help and contact support",
                    onTap: () => _openHelpSupport(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.feedback,
                    title: "Send Feedback",
                    subtitle: "Share your feedback with us",
                    onTap: () => _sendFeedback(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.star,
                    title: "Rate App",
                    subtitle: "Rate us on app store",
                    onTap: () => _rateApp(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.share,
                    title: "Share App",
                    subtitle: "Share with friends and family",
                    onTap: () => _shareApp(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // -------- ABOUT --------
            const Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.info,
                    title: "App Information",
                    subtitle: "Version 1.0.0 • Build 2024.01",
                    onTap: () => _showAppInfo(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.privacy_tip,
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy",
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.description,
                    title: "Terms of Service",
                    subtitle: "Read our terms and conditions",
                    onTap: () => _openTermsOfService(context),
                  ),
                  const Divider(height: 1, indent: 16),
                  _buildSettingItem(
                    icon: Icons.update,
                    title: "Check for Updates",
                    subtitle: "Check for latest version",
                    onTap: () => _checkForUpdates(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // -------- LOGOUT BUTTON --------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => _logout(context),
              ),
            ),
            const SizedBox(height: 20),

            // -------- VERSION INFO --------
            Center(
              child: Text(
                "Women Safety App v1.0.0",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "© 2024 Safety Tech Inc. All rights reserved.",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.pink),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.pink,
      ),
    );
  }

  // -------- ACTION METHODS --------
  
  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Edit Profile"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Edit Profile Page")),
        ),
      ),
    );
  }

  void _openNotificationsSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Notification Settings"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Notification Settings Page")),
        ),
      ),
    );
  }

  void _openPrivacySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Privacy & Security"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Privacy Settings Page")),
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              trailing: const Icon(Icons.check, color: Colors.pink),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("Spanish"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("French"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Light Theme"),
              trailing: const Icon(Icons.check, color: Colors.pink),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("Dark Theme"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text("System Default"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openEmergencyContacts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Emergency Contacts"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Emergency Contacts Page")),
        ),
      ),
    );
  }

  void _openDeviceSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Device Settings"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Device Settings Page")),
        ),
      ),
    );
  }

  void _openLocationSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Location Settings"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Location Settings Page")),
        ),
      ),
    );
  }

  void _openSoundSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Sound & Vibration"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Sound Settings Page")),
        ),
      ),
    );
  }

  void _setSOSTimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("SOS Timer"),
        content: const Text("Set countdown duration before sending alert"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _openAlertPreferences(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Alert Preferences"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Alert Preferences Page")),
        ),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Change Password"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Change Password Page")),
        ),
      ),
    );
  }

  void _changeEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Change Email"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Change Email Page")),
        ),
      ),
    );
  }

  void _changePhoneNumber(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Change Phone Number"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Change Phone Number Page")),
        ),
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Delete account logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account deletion requested"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Help & Support"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Help & Support Page")),
        ),
      ),
    );
  }

  void _sendFeedback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Send Feedback"),
            backgroundColor: Colors.pink,
          ),
          body: const Center(child: Text("Feedback Page")),
        ),
      ),
    );
  }

  void _rateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Opening app store for rating"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sharing app..."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Women Safety App",
      applicationVersion: "1.0.0",
      applicationIcon: const Icon(Icons.security, color: Colors.pink),
      applicationLegalese: "© 2024 Safety Tech Inc.",
      children: [
        const SizedBox(height: 10),
        const Text("A comprehensive safety app for women"),
        const SizedBox(height: 10),
        const Text("Features:"),
        const Text("• Emergency Alert System"),
        const Text("• Real-time Location Tracking"),
        const Text("• Guardian Connection"),
        const Text("• Police Station Locator"),
      ],
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Privacy Policy"),
            backgroundColor: Colors.pink,
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Text("Privacy Policy content..."),
          ),
        ),
      ),
    );
  }

  void _openTermsOfService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text("Terms of Service"),
            backgroundColor: Colors.pink,
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Text("Terms of Service content..."),
          ),
        ),
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Check for Updates"),
        content: const Text("You are using the latest version of the app."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Perform logout
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              // In real app, navigate to login screen
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}