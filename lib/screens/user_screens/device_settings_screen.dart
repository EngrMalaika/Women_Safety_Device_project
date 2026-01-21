import 'package:flutter/material.dart';

class DeviceSettingsScreen extends StatefulWidget {
  final String userName;
  const DeviceSettingsScreen({required this.userName, super.key});

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  // Emergency Contacts
  TextEditingController number1Controller = TextEditingController(text: "03001234567");
  TextEditingController number2Controller = TextEditingController(text: "03007654321");
  TextEditingController number3Controller = TextEditingController(text: "1122");

  // Device Settings
  bool _enableLocationTracking = true;
  bool _enableAutoAlert = false;
  bool _enableSoundAlerts = true;
  bool _enableVibrationAlerts = true;
  bool _enableNightMode = false;
  bool _enableBatterySaver = false;
  bool _enableDataBackup = true;
  
  // Safety Settings
  bool _enableShakeToAlert = true;
  bool _enablePowerButtonAlert = true;
  bool _enableVoiceRecording = true;
  
  // Notification Settings
  bool _enablePushNotifications = true;
  bool _enableEmailNotifications = false;
  bool _enableSMSNotifications = true;
  
  // Alert Settings
  double _alertRadius = 500.0; // Changed from int to double
  double _sosCountdown = 5.0; // Changed from int to double
  
  // Privacy Settings
  bool _shareLocationWithGuardian = true;
  bool _shareLocationWithEmergency = true;
  bool _showOnMap = true;
  
  // Battery Settings
  double _batteryWarningLevel = 20.0; // Changed from int to double
  bool _enableLowBatteryMode = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Device Settings",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Card(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Device: ${_getDeviceInfo()}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Emergency Contacts Section
            _buildSectionTitle("Emergency Contacts"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: number1Controller,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Primary Emergency Number",
                          prefixIcon: Icon(Icons.emergency, color: Colors.red),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: number2Controller,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Secondary Emergency Number",
                          prefixIcon: Icon(Icons.phone, color: Colors.green),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: number3Controller,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Police Emergency (1122)",
                          prefixIcon: Icon(Icons.local_police, color: Colors.blue),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Device Settings Section
            _buildSectionTitle("Device Settings"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSwitchSetting(
                      "Enable Location Tracking",
                      "Track your location in real-time",
                      _enableLocationTracking,
                      (value) => setState(() => _enableLocationTracking = value),
                    ),
                    _buildSwitchSetting(
                      "Auto Alert in Danger Zones",
                      "Send alerts automatically in high-risk areas",
                      _enableAutoAlert,
                      (value) => setState(() => _enableAutoAlert = value),
                    ),
                    _buildSwitchSetting(
                      "Sound Alerts",
                      "Play sound for notifications",
                      _enableSoundAlerts,
                      (value) => setState(() => _enableSoundAlerts = value),
                    ),
                    _buildSwitchSetting(
                      "Vibration Alerts",
                      "Vibrate for notifications",
                      _enableVibrationAlerts,
                      (value) => setState(() => _enableVibrationAlerts = value),
                    ),
                    _buildSwitchSetting(
                      "Night Mode",
                      "Dark theme for better visibility at night",
                      _enableNightMode,
                      (value) => setState(() => _enableNightMode = value),
                    ),
                    _buildSwitchSetting(
                      "Battery Saver Mode",
                      "Reduce power consumption",
                      _enableBatterySaver,
                      (value) => setState(() => _enableBatterySaver = value),
                    ),
                    _buildSwitchSetting(
                      "Auto Data Backup",
                      "Backup settings to cloud",
                      _enableDataBackup,
                      (value) => setState(() => _enableDataBackup = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Safety Features Section
            _buildSectionTitle("Safety Features"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSwitchSetting(
                      "Shake to Send Alert",
                      "Shake phone 3 times to send emergency alert",
                      _enableShakeToAlert,
                      (value) => setState(() => _enableShakeToAlert = value),
                    ),
                    _buildSwitchSetting(
                      "Power Button Emergency",
                      "Press power button 3 times for SOS",
                      _enablePowerButtonAlert,
                      (value) => setState(() => _enablePowerButtonAlert = value),
                    ),
                    _buildSwitchSetting(
                      "Auto Voice Recording",
                      "Record audio when alert is triggered",
                      _enableVoiceRecording,
                      (value) => setState(() => _enableVoiceRecording = value),
                    ),
                    const SizedBox(height: 12),
                    _buildSliderSetting(
                      "Alert Radius",
                      "Area to search for nearby help",
                      _alertRadius,
                      100.0,
                      2000.0,
                      (value) => setState(() => _alertRadius = value),
                      unit: "meters",
                    ),
                    _buildSliderSetting(
                      "SOS Countdown",
                      "Time before sending emergency alert",
                      _sosCountdown,
                      3.0,
                      10.0,
                      (value) => setState(() => _sosCountdown = value),
                      unit: "seconds",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Notification Settings
            _buildSectionTitle("Notification Settings"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSwitchSetting(
                      "Push Notifications",
                      "Receive app notifications",
                      _enablePushNotifications,
                      (value) => setState(() => _enablePushNotifications = value),
                    ),
                    _buildSwitchSetting(
                      "Email Notifications",
                      "Send alerts via email",
                      _enableEmailNotifications,
                      (value) => setState(() => _enableEmailNotifications = value),
                    ),
                    _buildSwitchSetting(
                      "SMS Notifications",
                      "Send alerts via SMS",
                      _enableSMSNotifications,
                      (value) => setState(() => _enableSMSNotifications = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Privacy Settings
            _buildSectionTitle("Privacy Settings"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSwitchSetting(
                      "Share Location with Guardian",
                      "Allow guardian to track your location",
                      _shareLocationWithGuardian,
                      (value) => setState(() => _shareLocationWithGuardian = value),
                    ),
                    _buildSwitchSetting(
                      "Share Location in Emergency",
                      "Share location with emergency services",
                      _shareLocationWithEmergency,
                      (value) => setState(() => _shareLocationWithEmergency = value),
                    ),
                    _buildSwitchSetting(
                      "Show on Public Safety Map",
                      "Appear on community safety map",
                      _showOnMap,
                      (value) => setState(() => _showOnMap = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Battery Settings
            _buildSectionTitle("Battery & Power"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSliderSetting(
                      "Low Battery Warning",
                      "Get notified when battery reaches this level",
                      _batteryWarningLevel,
                      10.0,
                      40.0,
                      (value) => setState(() => _batteryWarningLevel = value),
                      unit: "%",
                    ),
                    _buildSwitchSetting(
                      "Low Battery Mode",
                      "Reduce features when battery is low",
                      _enableLowBatteryMode,
                      (value) => setState(() => _enableLowBatteryMode = value),
                    ),
                    const SizedBox(height: 12),
                    _buildBatteryInfo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _saveSettings,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Save All Settings",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Advanced Options
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Advanced Options",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.refresh, color: Colors.blue),
                      title: const Text("Reset to Default Settings"),
                      onTap: _resetToDefaults,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text("Clear All Data"),
                      onTap: _clearAllData,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.green),
                      title: const Text("App Information"),
                      subtitle: const Text("Version 1.0.0 • Build 2024.01"),
                      onTap: _showAppInfo,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      )
    );
  }

  Widget _buildSwitchSetting(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.pink, // This is deprecated but still works
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(String title, String subtitle, double value, double min, double max, Function(double) onChanged, {String unit = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "${value.round()}$unit",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
              ),
            ],
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
            activeColor: Colors.pink,
            inactiveColor: Colors.pink.shade100,
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.battery_full, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Battery Status: Good",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Estimated battery life: 12 hours",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text("85%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  String _getDeviceInfo() {
    // In a real app, you would get actual device info
    return "Android • Samsung Galaxy S21";
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // Save all settings logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("All settings saved successfully!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
      
      // For debugging - in production, use a proper logging library
      debugPrint("Emergency Numbers: ${number1Controller.text}, ${number2Controller.text}, ${number3Controller.text}");
      debugPrint("Location Tracking: $_enableLocationTracking");
      debugPrint("Shake to Alert: $_enableShakeToAlert");
      debugPrint("Alert Radius: $_alertRadius meters");
      debugPrint("Battery Warning: $_batteryWarningLevel%");
    }
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Settings"),
        content: const Text("Are you sure you want to reset all settings to default?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Reset all settings to defaults
              setState(() {
                number1Controller.text = "03001234567";
                number2Controller.text = "03007654321";
                number3Controller.text = "1122";
                _enableLocationTracking = true;
                _enableAutoAlert = false;
                _enableSoundAlerts = true;
                _enableVibrationAlerts = true;
                _enableNightMode = false;
                _enableBatterySaver = false;
                _enableDataBackup = true;
                _enableShakeToAlert = true;
                _enablePowerButtonAlert = true;
                _enableVoiceRecording = true;
                _enablePushNotifications = true;
                _enableEmailNotifications = false;
                _enableSMSNotifications = true;
                _alertRadius = 500.0;
                _sosCountdown = 5.0;
                _shareLocationWithGuardian = true;
                _shareLocationWithEmergency = true;
                _showOnMap = true;
                _batteryWarningLevel = 20.0;
                _enableLowBatteryMode = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings reset to defaults")),
              );
            },
            child: const Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data"),
        content: const Text("This will delete all your settings and emergency contacts. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Clear all data logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All data cleared"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("App Information"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Women Safety App", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Version: 1.0.0"),
            Text("Build: 2024.01"),
            Text("Developer: Safety Tech Inc."),
            SizedBox(height: 12),
            Text("Features:"),
            Text("• Emergency Alert System"),
            Text("• Real-time Location Tracking"),
            Text("• Guardian Connection"),
            Text("• Police Station Locator"),
            Text("• Voice Recording"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    number1Controller.dispose();
    number2Controller.dispose();
    number3Controller.dispose();
    super.dispose();
  }
}