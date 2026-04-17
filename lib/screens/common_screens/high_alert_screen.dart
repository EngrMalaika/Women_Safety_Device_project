import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HighAlertAreasScreen extends StatefulWidget {
  const HighAlertAreasScreen({super.key});

  @override
  State<HighAlertAreasScreen> createState() => _HighAlertAreasScreenState();
}

class _HighAlertAreasScreenState extends State<HighAlertAreasScreen>
    with TickerProviderStateMixin {
  final MapController mapController = MapController();
  LatLng _currentPosition = const LatLng(31.582045, 74.329376);
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];
  bool _isLoading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Alert zone data
  final List<Map<String, dynamic>> _alertZones = [
    {
      'label': 'High Risk',
      'color': Colors.red,
      'offset': [0.005, 0.005],
      'radius': 500.0,
    },
    {
      'label': 'Medium Risk',
      'color': Colors.orange,
      'offset': [-0.004, 0.003],
      'radius': 400.0,
    },
    {
      'label': 'Low Risk',
      'color': Colors.amber,
      'offset': [0.003, -0.004],
      'radius': 300.0,
    },
  ];

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
    _getUserLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(
        () => _currentPosition = LatLng(position.latitude, position.longitude),
      );
    } catch (_) {}

    _buildMarkersAndCircles();
    setState(() => _isLoading = false);
  }

  void _buildMarkersAndCircles() {
    // User marker
    _markers.add(
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

    // Alert zone markers & circles
    for (final zone in _alertZones) {
      final Color color = zone['color'] as Color;
      final List offset = zone['offset'] as List;
      final LatLng point = LatLng(
        _currentPosition.latitude + (offset[0] as double),
        _currentPosition.longitude + (offset[1] as double),
      );

      _markers.add(
        Marker(
          point: point,
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(Icons.warning_rounded, color: color, size: 22),
          ),
        ),
      );

      _circles.add(
        CircleMarker(
          point: point,
          color: color.withOpacity(0.18),
          borderColor: color.withOpacity(0.7),
          borderStrokeWidth: 2,
          radius: zone['radius'] as double,
        ),
      );
    }
  }

  void _centerMapOnUser() {
    mapController.move(_currentPosition, 14);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── MAP ───────────────────────────────────────────
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
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    CircleLayer(circles: _circles),
                    MarkerLayer(markers: _markers),
                  ],
                ),

          // ── GRADIENT HEADER OVERLAY ───────────────────────
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
                      // Live badge
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
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

          // ── LEGEND CARD ───────────────────────────────────
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
                      offset: const Offset(0, 4),
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

          // ── ALERT COUNT CARD ──────────────────────────────
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.red.shade600,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Alert Zones Nearby",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${_alertZones.length} zones detected",
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

          // ── FAB ───────────────────────────────────────────
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
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B4F8E).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
