import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<Map<String, dynamic>> _alerts = [
    {
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red,
      'title': 'SOS Alert — Sarah Khan',
      'subtitle': 'User triggered emergency SOS near Gulshan Iqbal, Lahore',
      'time': '5 min ago',
      'isNew': true,
      'urgent': true,
    },
    {
      'icon': Icons.location_on_rounded,
      'color': Colors.orange,
      'title': 'High Alert Zone — Sarah Khan',
      'subtitle': 'User entered a high risk area near Railway Station',
      'time': '30 min ago',
      'isNew': true,
      'urgent': false,
    },
    {
      'icon': Icons.battery_alert_rounded,
      'color': Colors.amber,
      'title': 'Low Battery — Sarah\'s Device',
      'subtitle': 'Safety device battery dropped below 15%',
      'time': '2 hours ago',
      'isNew': false,
      'urgent': false,
    },
    {
      'icon': Icons.phonelink_off_rounded,
      'color': Colors.grey,
      'title': 'Device Disconnected',
      'subtitle': 'Safety device went offline for 10 minutes',
      'time': 'Yesterday',
      'isNew': false,
      'urgent': false,
    },
    {
      'icon': Icons.check_circle_rounded,
      'color': Colors.green,
      'title': 'User Reached Home Safely',
      'subtitle': 'Sarah Khan reached her designated safe location',
      'time': 'Yesterday',
      'isNew': false,
      'urgent': false,
    },
  ];

  int get _urgentCount => _alerts.where((a) => a['urgent'] == true).length;
  int get _newCount => _alerts.where((a) => a['isNew'] == true).length;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() => _alerts.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All alerts cleared'),
        backgroundColor: Color(0xFF8A5F9A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    if (_urgentCount > 0)
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.warning_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$_urgentCount URGENT",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_alerts.isNotEmpty)
                      GestureDetector(
                        onTap: _clearAll,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white38, width: 1),
                          ),
                          child: const Text(
                            "Clear All",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── SUMMARY ROW ───────────────────────────────
              if (_alerts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Row(
                    children: [
                      _summaryChip(
                        Icons.notifications_active_rounded,
                        "$_newCount New",
                        Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      _summaryChip(
                        Icons.warning_rounded,
                        "$_urgentCount Urgent",
                        Colors.red,
                      ),
                      const SizedBox(width: 8),
                      _summaryChip(
                        Icons.list_rounded,
                        "${_alerts.length} Total",
                        Colors.white54,
                      ),
                    ],
                  ),
                ),

              // ── LIST ─────────────────────────────────────
              Expanded(
                child: _alerts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_rounded,
                              size: 64,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "No alerts",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Sarah Khan is safe 💚",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: _alerts.length,
                        itemBuilder: (context, index) {
                          final alert = _alerts[index];
                          final Color color = alert['color'] as Color;
                          final bool isUrgent = alert['urgent'] as bool;
                          final bool isNew = alert['isNew'] as bool;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: isUrgent
                                  ? Border.all(
                                      color: Colors.red.withOpacity(0.5),
                                      width: 1.5,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: isUrgent
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.07),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      alert['icon'] as IconData,
                                      color: color,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                alert['title'] as String,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: isNew
                                                      ? FontWeight.w800
                                                      : FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            if (isNew || isUrgent)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 3,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isUrgent
                                                      ? Colors.red
                                                      : Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  isUrgent ? "URGENT" : "NEW",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          alert['subtitle'] as String,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 11,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              alert['time'] as String,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

  Widget _summaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
