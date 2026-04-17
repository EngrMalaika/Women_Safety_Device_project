import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinesScreen extends StatefulWidget {
  const HelplinesScreen({super.key});

  @override
  State<HelplinesScreen> createState() => _HelplinesScreenState();
}

class _HelplinesScreenState extends State<HelplinesScreen> {
  final List<Map<String, dynamic>> helplines = [
    {
      "name": "Punjab Police Women Cell",
      "number": "15",
      "location": "Punjab",
      "type": "Police",
      "available": "24/7",
      "emergency": true,
    },
    {
      "name": "Sindh Police Women Cell",
      "number": "109",
      "location": "Sindh",
      "type": "Police",
      "available": "24/7",
      "emergency": true,
    },
    {
      "name": "National Helpline for Women",
      "number": "0800-26465",
      "location": "Nationwide",
      "type": "Government",
      "available": "9 AM - 5 PM",
      "emergency": true,
    },
    {
      "name": "Rape Crisis Center Islamabad",
      "number": "051-111-222-333",
      "location": "Islamabad",
      "type": "Crisis Center",
      "available": "24/7",
      "emergency": true,
    },
    {
      "name": "Karachi Women Helpline",
      "number": "021-34567890",
      "location": "Karachi",
      "type": "Helpline",
      "available": "8 AM - 8 PM",
      "emergency": true,
    },
    {
      "name": "Domestic Violence Helpline",
      "number": "1122",
      "location": "Nationwide",
      "type": "Emergency",
      "available": "24/7",
      "emergency": true,
    },
    {
      "name": "Child Protection Helpline",
      "number": "1121",
      "location": "Nationwide",
      "type": "Child Protection",
      "available": "24/7",
      "emergency": true,
    },
    {
      "name": "Legal Aid Organization",
      "number": "051-9876543",
      "location": "Islamabad",
      "type": "Legal Aid",
      "available": "10 AM - 4 PM",
      "emergency": false,
    },
    {
      "name": "Women Shelter Home Lahore",
      "number": "042-7654321",
      "location": "Lahore",
      "type": "Shelter",
      "available": "24/7",
      "emergency": false,
    },
    {
      "name": "Psychological Support Helpline",
      "number": "0300-1234567",
      "location": "Nationwide",
      "type": "Counseling",
      "available": "8 AM - 10 PM",
      "emergency": false,
    },
  ];

  String _selectedFilter = "All";
  final List<String> _filters = [
    "All",
    "Emergency",
    "Police",
    "Crisis Center",
    "Legal Aid",
    "Shelter",
  ];
  String _searchQuery = "";
  bool _showEmergencyOnly = false;

  List<Map<String, dynamic>> get _filteredHelplines {
    List<Map<String, dynamic>> filtered = List.from(helplines);
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((h) {
        return h['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            h['location'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            h['number'].contains(_searchQuery);
      }).toList();
    }
    if (_selectedFilter != "All") {
      filtered = filtered.where((h) {
        if (_selectedFilter == "Emergency") return h['emergency'] == true;
        return h['type'] == _selectedFilter;
      }).toList();
    }
    if (_showEmergencyOnly) {
      filtered = filtered.where((h) => h['emergency'] == true).toList();
    }
    return filtered;
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendSMS(String number) async {
    final Uri url = Uri(scheme: 'sms', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // ── TYPE CONFIG ────────────────────────────────────────────────
  Map<String, dynamic> _typeConfig(String type) {
    switch (type) {
      case "Police":
        return {'icon': Icons.local_police_rounded, 'color': Colors.blue};
      case "Emergency":
        return {'icon': Icons.emergency_rounded, 'color': Colors.red};
      case "Crisis Center":
        return {'icon': Icons.medical_services_rounded, 'color': Colors.orange};
      case "Legal Aid":
        return {'icon': Icons.gavel_rounded, 'color': Colors.purple};
      case "Shelter":
        return {'icon': Icons.home_rounded, 'color': Colors.green};
      case "Counseling":
        return {'icon': Icons.psychology_rounded, 'color': Colors.teal};
      case "Government":
        return {'icon': Icons.account_balance_rounded, 'color': Colors.indigo};
      default:
        return {'icon': Icons.help_rounded, 'color': const Color(0xFF7B4F8E)};
    }
  }

  void _showDetails(Map<String, dynamic> h) {
    final config = _typeConfig(h['type']);
    final Color color = config['color'] as Color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    config['icon'] as IconData,
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            h['location'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (h['emergency'])
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      "URGENT",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            _detailRow(
              Icons.phone_rounded,
              "Number",
              h['number'],
              Colors.green,
            ),
            const SizedBox(height: 10),
            _detailRow(
              Icons.access_time_rounded,
              "Available",
              h['available'],
              Colors.blue,
            ),
            const SizedBox(height: 10),
            _detailRow(Icons.category_rounded, "Type", h['type'], color),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _makePhoneCall(h['number']);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Call Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _sendSMS(h['number']);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_rounded,
                            color: Colors.blue.shade400,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Send SMS",
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
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
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── APP BAR ───────────────────────────────────
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
                        "Emergency Helplines",
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
                        border: Border.all(color: Colors.white38, width: 1),
                      ),
                      child: Text(
                        "${_filteredHelplines.length} found",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ── SEARCH BAR ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search helplines...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── FILTER CHIPS ──────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Emergency toggle pill
                    GestureDetector(
                      onTap: () => setState(
                        () => _showEmergencyOnly = !_showEmergencyOnly,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _showEmergencyOnly
                              ? Colors.red
                              : Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _showEmergencyOnly
                                ? Colors.red
                                : Colors.white54,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.emergency_rounded,
                              size: 14,
                              color: _showEmergencyOnly
                                  ? Colors.white
                                  : Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Urgent Only",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Category filters
                    ..._filters.map((f) {
                      final isSelected = _selectedFilter == f;
                      return GestureDetector(
                        onTap: () => setState(
                          () => _selectedFilter = isSelected ? "All" : f,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.white54,
                              width: 1.2,
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF7B4F8E)
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── LIST ──────────────────────────────────────
              Expanded(
                child: _filteredHelplines.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 56,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No helplines found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => setState(() {
                                _selectedFilter = "All";
                                _searchQuery = "";
                                _showEmergencyOnly = false;
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Reset Filters",
                                  style: TextStyle(
                                    color: Color(0xFF7B4F8E),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: _filteredHelplines.length,
                        itemBuilder: (context, index) {
                          final h = _filteredHelplines[index];
                          final config = _typeConfig(h['type']);
                          final Color color = config['color'] as Color;

                          return GestureDetector(
                            onTap: () => _showDetails(h),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
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
                                children: [
                                  // Icon
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      config['icon'] as IconData,
                                      color: color,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                h['name'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            if (h['emergency'])
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 7,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.red.shade200,
                                                  ),
                                                ),
                                                child: Text(
                                                  "URGENT",
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.red.shade700,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              size: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              h['location'],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              h['available'],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          h['number'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action buttons
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _makePhoneCall(h['number']),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.call_rounded,
                                            color: Colors.green.shade600,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: () => _sendSMS(h['number']),
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.message_rounded,
                                            color: Colors.blue.shade600,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
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
}
