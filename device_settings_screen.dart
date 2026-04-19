import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // ── Firebase import

class DeviceSettingsScreen extends StatefulWidget {
  final String userName;
  const DeviceSettingsScreen({required this.userName, super.key});

  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Firebase reference ─────────────────────────────────────────
  late final DatabaseReference _settingsRef;

  // Emergency Contacts
  final TextEditingController _num1 = TextEditingController(
    text: "03001234567",
  );
  final TextEditingController _num2 = TextEditingController(
    text: "03007654321",
  );
  final TextEditingController _num3 = TextEditingController(text: "1122");

  // Device Settings
  bool _locationTracking = true;
  bool _autoAlert = false;
  bool _soundAlerts = true;
  bool _vibrationAlerts = true;
  bool _nightMode = false;
  bool _batterySaver = false;
  bool _dataBackup = true;

  // Safety Features
  bool _shakeToAlert = true;
  bool _powerButtonAlert = true;
  bool _voiceRecording = true;
  double _alertRadius = 500.0;
  double _sosCountdown = 5.0;

  // Notifications
  bool _pushNotifs = true;
  bool _emailNotifs = false;
  bool _smsNotifs = true;

  // Privacy
  bool _shareWithGuardian = true;
  bool _shareInEmergency = true;
  bool _showOnMap = true;

  // Battery
  double _batteryWarning = 20.0;
  bool _lowBatteryMode = true;

  // ── initState: Firebase reference banao + settings load karo ───
  @override
  void initState() {
    super.initState();
    _settingsRef = FirebaseDatabase.instance
        .ref("users/${widget.userName}/device_settings");
    _loadSettings();
  }

  // ── Firebase se settings load karo ────────────────────────────
  Future<void> _loadSettings() async {
    final snapshot = await _settingsRef.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _num1.text = data['num1'] ?? "03001234567";
        _num2.text = data['num2'] ?? "03007654321";
        _num3.text = data['num3'] ?? "1122";
        _locationTracking  = data['locationTracking']  ?? true;
        _autoAlert         = data['autoAlert']         ?? false;
        _soundAlerts       = data['soundAlerts']       ?? true;
        _vibrationAlerts   = data['vibrationAlerts']   ?? true;
        _nightMode         = data['nightMode']         ?? false;
        _batterySaver      = data['batterySaver']      ?? false;
        _dataBackup        = data['dataBackup']        ?? true;
        _shakeToAlert      = data['shakeToAlert']      ?? true;
        _powerButtonAlert  = data['powerButtonAlert']  ?? true;
        _voiceRecording    = data['voiceRecording']    ?? true;
        _alertRadius       = (data['alertRadius']      ?? 500.0).toDouble();
        _sosCountdown      = (data['sosCountdown']     ?? 5.0).toDouble();
        _pushNotifs        = data['pushNotifs']        ?? true;
        _emailNotifs       = data['emailNotifs']       ?? false;
        _smsNotifs         = data['smsNotifs']         ?? true;
        _shareWithGuardian = data['shareWithGuardian'] ?? true;
        _shareInEmergency  = data['shareInEmergency']  ?? true;
        _showOnMap         = data['showOnMap']         ?? true;
        _batteryWarning    = (data['batteryWarning']   ?? 20.0).toDouble();
        _lowBatteryMode    = data['lowBatteryMode']    ?? true;
      });
    }
  }

  void _snack(String msg, {Color color = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Save: Firebase mein settings store karo ───────────────────
  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      _settingsRef.set({
        'num1': _num1.text,
        'num2': _num2.text,
        'num3': _num3.text,
        'locationTracking':  _locationTracking,
        'autoAlert':         _autoAlert,
        'soundAlerts':       _soundAlerts,
        'vibrationAlerts':   _vibrationAlerts,
        'nightMode':         _nightMode,
        'batterySaver':      _batterySaver,
        'dataBackup':        _dataBackup,
        'shakeToAlert':      _shakeToAlert,
        'powerButtonAlert':  _powerButtonAlert,
        'voiceRecording':    _voiceRecording,
        'alertRadius':       _alertRadius,
        'sosCountdown':      _sosCountdown,
        'pushNotifs':        _pushNotifs,
        'emailNotifs':       _emailNotifs,
        'smsNotifs':         _smsNotifs,
        'shareWithGuardian': _shareWithGuardian,
        'shareInEmergency':  _shareInEmergency,
        'showOnMap':         _showOnMap,
        'batteryWarning':    _batteryWarning,
        'lowBatteryMode':    _lowBatteryMode,
      }).then((_) {
        _snack("All settings saved successfully! ✅");
      }).catchError((e) {
        _snack("Save failed: $e", color: Colors.red);
      });
    }
  }

  void _resetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.refresh_rounded, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text("Reset Settings", style: TextStyle(fontSize: 17)),
          ],
        ),
        content: const Text("Reset all settings to default values?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _num1.text = "03001234567";
                _num2.text = "03007654321";
                _num3.text = "1122";
                _locationTracking = true;
                _autoAlert = false;
                _soundAlerts = true;
                _vibrationAlerts = true;
                _nightMode = false;
                _batterySaver = false;
                _dataBackup = true;
                _shakeToAlert = true;
                _powerButtonAlert = true;
                _voiceRecording = true;
                _alertRadius = 500.0;
                _sosCountdown = 5.0;
                _pushNotifs = true;
                _emailNotifs = false;
                _smsNotifs = true;
                _shareWithGuardian = true;
                _shareInEmergency = true;
                _showOnMap = true;
                _batteryWarning = 20.0;
                _lowBatteryMode = true;
              });
              // ── Reset values Firebase mein bhi save karo ──────
              _settingsRef.set({
                'num1': "03001234567",
                'num2': "03007654321",
                'num3': "1122",
                'locationTracking':  true,
                'autoAlert':         false,
                'soundAlerts':       true,
                'vibrationAlerts':   true,
                'nightMode':         false,
                'batterySaver':      false,
                'dataBackup':        true,
                'shakeToAlert':      true,
                'powerButtonAlert':  true,
                'voiceRecording':    true,
                'alertRadius':       500.0,
                'sosCountdown':      5.0,
                'pushNotifs':        true,
                'emailNotifs':       false,
                'smsNotifs':         true,
                'shareWithGuardian': true,
                'shareInEmergency':  true,
                'showOnMap':         true,
                'batteryWarning':    20.0,
                'lowBatteryMode':    true,
              });
              Navigator.pop(ctx);
              _snack("Settings reset to defaults", color: Colors.blue);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Reset",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearDataDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_rounded, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text("Clear All Data", style: TextStyle(fontSize: 17)),
          ],
        ),
        content: const Text(
          "This will delete all settings and contacts. This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          GestureDetector(
            onTap: () {
              // ── Firebase se data delete karo ──────────────────
              _settingsRef.remove();
              Navigator.pop(ctx);
              _snack("All data cleared", color: Colors.red);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Clear",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _appInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("App Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Women Safety Device App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              "Version: 1.0.0",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              "Build: 2025.01",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Features:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            ...[
              "Emergency Alert System",
              "Real-time GPS Tracking",
              "Guardian Connection",
              "Police Station Locator",
              "Voice Recording",
            ].map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(f, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _num1.dispose();
    _num2.dispose();
    _num3.dispose();
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
            stops: [0.0, 0.30, 1.0],
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
                        "Device Settings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Text(
                        "ESP32",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── USER CARD ────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white38, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.25),
                                border: Border.all(
                                  color: Colors.white60,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "ESP32 Safety Device",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.wifi_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "ON",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── EMERGENCY CONTACTS ───────────────
                      _sectionLabel("Emergency Contacts"),
                      _card(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _contactField(
                                _num1,
                                "Primary Emergency Number",
                                Icons.emergency_rounded,
                                Colors.red,
                                required: true,
                              ),
                              const SizedBox(height: 12),
                              _contactField(
                                _num2,
                                "Secondary Emergency Number",
                                Icons.phone_rounded,
                                Colors.green,
                              ),
                              const SizedBox(height: 12),
                              _contactField(
                                _num3,
                                "Police Emergency (1122)",
                                Icons.local_police_rounded,
                                Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── DEVICE SETTINGS ──────────────────
                      _sectionLabel("Device Settings"),
                      _card(
                        child: Column(
                          children: [
                            _toggle(
                              "Location Tracking",
                              "Real-time GPS tracking",
                              _locationTracking,
                              Icons.location_on_rounded,
                              Colors.green,
                              (v) => setState(() => _locationTracking = v),
                            ),
                            _divider(),
                            _toggle(
                              "Auto Alert in Danger Zones",
                              "Send alerts in high-risk areas",
                              _autoAlert,
                              Icons.warning_rounded,
                              Colors.orange,
                              (v) => setState(() => _autoAlert = v),
                            ),
                            _divider(),
                            _toggle(
                              "Sound Alerts",
                              "Play sound for notifications",
                              _soundAlerts,
                              Icons.volume_up_rounded,
                              Colors.purple,
                              (v) => setState(() => _soundAlerts = v),
                            ),
                            _divider(),
                            _toggle(
                              "Vibration Alerts",
                              "Vibrate for notifications",
                              _vibrationAlerts,
                              Icons.vibration_rounded,
                              Colors.teal,
                              (v) => setState(() => _vibrationAlerts = v),
                            ),
                            _divider(),
                            _toggle(
                              "Night Mode",
                              "Dark theme for night visibility",
                              _nightMode,
                              Icons.nights_stay_rounded,
                              Colors.indigo,
                              (v) => setState(() => _nightMode = v),
                            ),
                            _divider(),
                            _toggle(
                              "Battery Saver Mode",
                              "Reduce power consumption",
                              _batterySaver,
                              Icons.battery_saver_rounded,
                              Colors.amber,
                              (v) => setState(() => _batterySaver = v),
                            ),
                            _divider(),
                            _toggle(
                              "Auto Data Backup",
                              "Backup settings to cloud",
                              _dataBackup,
                              Icons.cloud_upload_rounded,
                              Colors.blue,
                              (v) => setState(() => _dataBackup = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── SAFETY FEATURES ──────────────────
                      _sectionLabel("Safety Features"),
                      _card(
                        child: Column(
                          children: [
                            _toggle(
                              "Shake to Send Alert",
                              "Shake phone 3× for emergency",
                              _shakeToAlert,
                              Icons.screen_rotation_rounded,
                              Colors.red,
                              (v) => setState(() => _shakeToAlert = v),
                            ),
                            _divider(),
                            _toggle(
                              "Power Button Emergency",
                              "Press 3× power button for SOS",
                              _powerButtonAlert,
                              Icons.power_settings_new_rounded,
                              Colors.deepOrange,
                              (v) => setState(() => _powerButtonAlert = v),
                            ),
                            _divider(),
                            _toggle(
                              "Auto Voice Recording",
                              "Record audio on alert trigger",
                              _voiceRecording,
                              Icons.mic_rounded,
                              const Color(0xFF7B4F8E),
                              (v) => setState(() => _voiceRecording = v),
                            ),
                            _divider(),
                            _slider(
                              "Alert Radius",
                              "Area to search for nearby help",
                              _alertRadius,
                              100,
                              2000,
                              "m",
                              (v) => setState(() => _alertRadius = v),
                              Colors.blue,
                            ),
                            _divider(),
                            _slider(
                              "SOS Countdown",
                              "Time before sending emergency alert",
                              _sosCountdown,
                              3,
                              10,
                              "s",
                              (v) => setState(() => _sosCountdown = v),
                              Colors.red,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── NOTIFICATIONS ─────────────────────
                      _sectionLabel("Notifications"),
                      _card(
                        child: Column(
                          children: [
                            _toggle(
                              "Push Notifications",
                              "Receive app notifications",
                              _pushNotifs,
                              Icons.notifications_rounded,
                              Colors.blue,
                              (v) => setState(() => _pushNotifs = v),
                            ),
                            _divider(),
                            _toggle(
                              "Email Notifications",
                              "Send alerts via email",
                              _emailNotifs,
                              Icons.email_rounded,
                              Colors.teal,
                              (v) => setState(() => _emailNotifs = v),
                            ),
                            _divider(),
                            _toggle(
                              "SMS Notifications",
                              "Send alerts via SMS",
                              _smsNotifs,
                              Icons.sms_rounded,
                              Colors.green,
                              (v) => setState(() => _smsNotifs = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── PRIVACY ───────────────────────────
                      _sectionLabel("Privacy Settings"),
                      _card(
                        child: Column(
                          children: [
                            _toggle(
                              "Share Location with Guardian",
                              "Guardian can track your location",
                              _shareWithGuardian,
                              Icons.people_rounded,
                              Colors.purple,
                              (v) => setState(() => _shareWithGuardian = v),
                            ),
                            _divider(),
                            _toggle(
                              "Share in Emergency",
                              "Share location with emergency services",
                              _shareInEmergency,
                              Icons.emergency_rounded,
                              Colors.red,
                              (v) => setState(() => _shareInEmergency = v),
                            ),
                            _divider(),
                            _toggle(
                              "Show on Safety Map",
                              "Appear on community safety map",
                              _showOnMap,
                              Icons.map_rounded,
                              Colors.green,
                              (v) => setState(() => _showOnMap = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── BATTERY ───────────────────────────
                      _sectionLabel("Battery & Power"),
                      _card(
                        child: Column(
                          children: [
                            _slider(
                              "Low Battery Warning",
                              "Notify when battery reaches this level",
                              _batteryWarning,
                              10,
                              40,
                              "%",
                              (v) => setState(() => _batteryWarning = v),
                              Colors.orange,
                            ),
                            _divider(),
                            _toggle(
                              "Low Battery Mode",
                              "Reduce features when battery is low",
                              _lowBatteryMode,
                              Icons.battery_alert_rounded,
                              Colors.amber,
                              (v) => setState(() => _lowBatteryMode = v),
                            ),
                            _divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.battery_full_rounded,
                                      color: Colors.green.shade600,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Battery Status: Good",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            "Estimated life: 12 hours",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "85%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── SAVE BUTTON ───────────────────────
                      GestureDetector(
                        onTap: _saveSettings,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B4F8E).withOpacity(0.4),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Save All Settings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── ADVANCED ──────────────────────────
                      _sectionLabel("Advanced Options"),
                      _card(
                        child: Column(
                          children: [
                            _advancedRow(
                              Icons.refresh_rounded,
                              "Reset to Default Settings",
                              Colors.blue,
                              _resetDialog,
                            ),
                            _divider(),
                            _advancedRow(
                              Icons.delete_rounded,
                              "Clear All Data",
                              Colors.red,
                              _clearDataDialog,
                            ),
                            _divider(),
                            _advancedRow(
                              Icons.info_rounded,
                              "App Information",
                              Colors.green,
                              _appInfoDialog,
                              subtitle: "Version 1.0.0 · Build 2025.01",
                            ),
                          ],
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

  // ── HELPERS ──────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: child,
    ),
  );

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Colors.white70,
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _divider() => const Divider(height: 1, indent: 16, endIndent: 16);

  Widget _toggle(
    String title,
    String subtitle,
    bool value,
    IconData icon,
    Color color,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7B4F8E),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _slider(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    String unit,
    Function(double) onChanged,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${value.round()}$unit",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.15),
              thumbColor: color,
              overlayColor: color.withOpacity(0.15),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    Color color, {
    bool required = false,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF7B4F8E), width: 1.8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? "Please enter a number" : null
          : null,
    );
  }

  Widget _advancedRow(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap, {
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}