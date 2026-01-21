import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplinesScreen extends StatefulWidget {
  const HelplinesScreen({super.key});

  @override
  State<HelplinesScreen> createState() => _HelplinesScreenState();
}

class _HelplinesScreenState extends State<HelplinesScreen> {
  // ---------------- LIST OF HELPLINES ----------------
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

  // Filter options
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Emergency", "Police", "Crisis Center", "Legal Aid", "Shelter"];

  // Search functionality
  String _searchQuery = "";
  bool _showEmergencyOnly = false;

  // ---------------- GET FILTERED HELPLINES ----------------
  List<Map<String, dynamic>> get _filteredHelplines {
    List<Map<String, dynamic>> filtered = List.from(helplines);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((helpline) {
        return helpline['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            helpline['location'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            helpline['number'].contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != "All") {
      filtered = filtered.where((helpline) {
        if (_selectedFilter == "Emergency") {
          return helpline['emergency'] == true;
        }
        return helpline['type'] == _selectedFilter;
      }).toList();
    }

    // Apply emergency only filter
    if (_showEmergencyOnly) {
      filtered = filtered.where((helpline) => helpline['emergency'] == true).toList();
    }

    return filtered;
  }

  // ---------------- MAKE PHONE CALL ----------------
  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorDialog("Could not call $number");
    }
  }

  // ---------------- SEND SMS ----------------
  Future<void> _sendSMS(String number) async {
    final Uri url = Uri(scheme: 'sms', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorDialog("Could not send SMS to $number");
    }
  }

  // ---------------- SHOW HELPLINE DETAILS ----------------
  void _showHelplineDetails(Map<String, dynamic> helpline) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _getIconForType(helpline['type']),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          helpline['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              helpline['location'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailRow(Icons.phone, "Phone Number", helpline['number']),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.access_time, "Available", helpline['available']),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.category, "Service Type", helpline['type']),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.warning,
                "Emergency Service",
                helpline['emergency'] ? "Yes - 24/7 Available" : "No - Working Hours",
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: const Icon(Icons.call, color: Colors.white),
                      label: const Text("Call Now", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        _makePhoneCall(helpline['number']);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      icon: const Icon(Icons.message, color: Colors.blue),
                      label: const Text("Send SMS", style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        Navigator.pop(context);
                        _sendSMS(helpline['number']);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.pink),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getIconForType(String type) {
    switch (type) {
      case "Police":
        return CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: const Icon(Icons.local_police, color: Colors.blue),
        );
      case "Emergency":
        return CircleAvatar(
          backgroundColor: Colors.red[50],
          child: const Icon(Icons.emergency, color: Colors.red),
        );
      case "Crisis Center":
        return CircleAvatar(
          backgroundColor: Colors.orange[50],
          child: const Icon(Icons.medical_services, color: Colors.orange),
        );
      case "Legal Aid":
        return CircleAvatar(
          backgroundColor: Colors.purple[50],
          child: const Icon(Icons.gavel, color: Colors.purple),
        );
      case "Shelter":
        return CircleAvatar(
          backgroundColor: Colors.green[50],
          child: const Icon(Icons.home, color: Colors.green),
        );
      case "Counseling":
        return CircleAvatar(
          backgroundColor: Colors.teal[50],
          child: const Icon(Icons.psychology, color: Colors.teal),
        );
      default:
        return CircleAvatar(
          backgroundColor: Colors.pink[50],
          child: const Icon(Icons.help, color: Colors.pink),
        );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showAddHelplineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Custom Helpline"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Helpline Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Add custom helpline logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Helpline added successfully")),
              );
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Emergency Helplines",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHelplineDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search helplines...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    selectedColor: Colors.pink,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : "All";
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Emergency Only Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Checkbox(
                  value: _showEmergencyOnly,
                  onChanged: (value) {
                    setState(() {
                      _showEmergencyOnly = value ?? false;
                    });
                  },
                  activeColor: Colors.pink,
                ),
                const Text("Show Emergency Services Only"),
              ],
            ),
          ),

          // Helplines Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Helplines (${_filteredHelplines.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (_filteredHelplines.isEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset Filters"),
                    onPressed: () {
                      setState(() {
                        _selectedFilter = "All";
                        _searchQuery = "";
                        _showEmergencyOnly = false;
                      });
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Helplines List
          Expanded(
            child: _filteredHelplines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          "No helplines found",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Try changing your search or filters",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedFilter = "All";
                              _searchQuery = "";
                              _showEmergencyOnly = false;
                            });
                          },
                          child: const Text("Reset All Filters"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredHelplines.length,
                    itemBuilder: (context, index) {
                      final helpline = _filteredHelplines[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _showHelplineDetails(helpline),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                _getIconForType(helpline['type']),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              helpline['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (helpline['emergency'])
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.red[50],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "EMERGENCY",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red[700],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: 14, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            helpline['location'],
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(Icons.access_time,
                                              size: 14, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            helpline['available'],
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            helpline['number'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.message,
                                                    color: Colors.blue),
                                                onPressed: () =>
                                                    _sendSMS(helpline['number']),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.call,
                                                    color: Colors.green),
                                                onPressed: () =>
                                                    _makePhoneCall(helpline['number']),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}