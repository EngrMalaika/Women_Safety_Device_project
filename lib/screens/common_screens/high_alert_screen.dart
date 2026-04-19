import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class HighAlertAreasScreen extends StatefulWidget {
  const HighAlertAreasScreen({super.key});

  @override
  State<HighAlertAreasScreen> createState() => _HighAlertAreasScreenState();
}

class _HighAlertAreasScreenState extends State<HighAlertAreasScreen>
    with TickerProviderStateMixin {
  final DatabaseReference _alertRef = FirebaseDatabase.instance.ref(
    "high_alert_zones",
  );
  List<Map<String, dynamic>> _alertZones = [];
  final MapController mapController = MapController();

  LatLng _currentPosition = const LatLng(31.582045, 74.329376);
  List<Marker> _markers = [];
  List<CircleMarker> _circles = [];
  bool _isLoading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initializeData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _getUserLocation();
    _listenToAlertZones();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("Location error: $e");
    }
  }

  // Map ko wapas user ki location par laane ke liye logic
  void _centerMapOnUser() {
    mapController.move(_currentPosition, 14.0);
  }

  void _listenToAlertZones() {
    _alertRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null && mounted) {
        List<Map<String, dynamic>> tempZones = [];
        data.forEach((key, value) {
          // Safe casting for Firebase Numbers (int/double)
          double lat = double.tryParse(value['latitude'].toString()) ?? 0.0;
          double lng = double.tryParse(value['longitude'].toString()) ?? 0.0;
          double rad = double.tryParse(value['radius'].toString()) ?? 500.0;

          tempZones.add({
            'label': value['name'] ?? 'Alert Zone',
            'color': _getRiskColor(value['riskLevel']?.toString()),
            'lat': lat,
            'lng': lng,
            'radius': rad,
          });
        });

        setState(() {
          _alertZones = tempZones;
          _buildMarkersAndCircles();
          _isLoading = false;
        });
      }
    });
  }

  Color _getRiskColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.amber;
      default:
        return Colors.blue; // Default color agar data missing ho
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              : FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition,
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.womensafety.app',
                    ),
                    CircleLayer(
                      circles: _alertZones
                          .map(
                            (zone) => CircleMarker(
                              point: LatLng(zone['lat'], zone['lng']),
                              radius: zone['radius'],
                              useRadiusInMeter: true,
                              color: zone['color'].withOpacity(0.3),
                              borderColor: zone['color'],
                              borderStrokeWidth: 3,
                            ),
                          )
                          .toList(),
                    ),
                    MarkerLayer(markers: List.from(_markers)),
                  ],
                ),

          // Header with Title and LIVE Badge
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B4F8E), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 6, 16, 16),
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
                          "High Alert Areas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.circle, color: Colors.white, size: 8),
                              SizedBox(width: 5),
                              Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
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
            ),
          ),

          // Risk Zones Legend (Top Right)
          if (!_isLoading)
            Positioned(
              top: 90 + MediaQuery.of(context).padding.top,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Risk Zones",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _legendItem(Colors.red, "High Risk"),
                    const SizedBox(height: 6),
                    _legendItem(Colors.orange, "Medium Risk"),
                    const SizedBox(height: 6),
                    _legendItem(Colors.amber, "Low Risk"),
                    const SizedBox(height: 6),
                    _legendItem(Colors.blue, "You"),
                  ],
                ),
              ),
            ),

          // Alert Count Card (Bottom Left)
          if (!_isLoading)
            Positioned(
              bottom: 100,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.red.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Alert Zones Nearby",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          "${_markers.length > 0 ? _markers.length - 1 : 0} zones detected",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // FAB for Re-centering
          if (!_isLoading)
            Positioned(
              bottom: 30,
              right: 16,
              child: GestureDetector(
                onTap: _centerMapOnUser,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B4F8E).withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _buildMarkersAndCircles() {
    List<Marker> tempMarkers = [];
    List<CircleMarker> tempCircles = [];
    tempMarkers.add(
      Marker(
        point: _currentPosition,
        width: 60,
        height: 60,
        child: const Icon(
          Icons.my_location_rounded,
          color: Colors.blue,
          size: 36,
        ),
      ),
    );
    for (final zone in _alertZones) {
      final LatLng point = LatLng(zone['lat'], zone['lng']);
      final Color color = zone['color'];
      tempMarkers.add(
        Marker(
          point: point,
          width: 44,
          height: 44,
          child: Icon(Icons.warning_rounded, color: color, size: 22),
        ),
      );
      tempCircles.add(
        CircleMarker(
          point: point,
          color: color.withOpacity(0.3), // Transparency thori barha di
          borderColor: color,
          borderStrokeWidth: 2,
          useRadiusInMeter: true, // YE SABSE ZAROORI HAI
          radius: zone['radius'], // Meters mein (e.g., 500.0)
        ),
      );
    }
    setState(() {
      _markers = tempMarkers;
      _circles = tempCircles;
    });
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
