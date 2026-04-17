import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TrackGuardianScreen extends StatefulWidget {
  const TrackGuardianScreen({super.key});

  @override
  State<TrackGuardianScreen> createState() => _TrackGuardianScreenState();
}

class _TrackGuardianScreenState extends State<TrackGuardianScreen>
    with TickerProviderStateMixin {
  final MapController _controller = MapController();
  LatLng _userPosition = const LatLng(31.582045, 74.329376);
  LatLng? _guardianPosition;
  bool _isLoading = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.14).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _getLocations();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _getLocations() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userPosition = LatLng(pos.latitude, pos.longitude);
        _guardianPosition = LatLng(pos.latitude + 0.01, pos.longitude + 0.01);
      });
    } catch (_) {
      // fallback to default Lahore coords
      setState(() {
        _guardianPosition = LatLng(
          _userPosition.latitude + 0.01,
          _userPosition.longitude + 0.01,
        );
      });
    }
    setState(() => _isLoading = false);
    if (mounted) _controller.move(_userPosition, 14);
  }

  double _calculateDistance() {
    if (_guardianPosition == null) return 0;
    const Distance d = Distance();
    return d(_userPosition, _guardianPosition!);
  }

  String _distanceLabel() {
    final double m = _calculateDistance();
    if (m >= 1000) return "${(m / 1000).toStringAsFixed(2)} km";
    return "${m.toStringAsFixed(0)} m";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── MAP / LOADING ──────────────────────────────
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
                  mapController: _controller,
                  options: MapOptions(
                    initialCenter: _userPosition,
                    initialZoom: 14,
                    onMapReady: () => _controller.move(_userPosition, 14),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.womensafety.app',
                    ),
                    // Dotted polyline
                    if (_guardianPosition != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [_userPosition, _guardianPosition!],
                            color: const Color(0xFF7B4F8E).withOpacity(0.5),
                            strokeWidth: 3,
                            isDotted: true,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        // User marker
                        Marker(
                          point: _userPosition,
                          width: 60,
                          height: 60,
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF7B4F8E,
                                ).withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF7B4F8E),
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_pin_circle_rounded,
                                color: Color(0xFF7B4F8E),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        // Guardian marker
                        if (_guardianPosition != null)
                          Marker(
                            point: _guardianPosition!,
                            width: 60,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.teal,
                                  width: 2.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.supervisor_account_rounded,
                                color: Colors.teal,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

          // ── GRADIENT HEADER OVERLAY ───────────────────
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
                          "Track Guardian",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (!_isLoading)
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 8,
                                ),
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
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _getLocations,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── DISTANCE CARD ─────────────────────────────
          if (!_isLoading)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // You
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B4F8E).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_pin_circle_rounded,
                              color: Color(0xFF7B4F8E),
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "You",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7B4F8E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Distance
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            _distanceLabel(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 30,
                                height: 2,
                                color: const Color(0xFF7B4F8E).withOpacity(0.4),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 2,
                                color: Colors.teal.withOpacity(0.4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Distance",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Guardian
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.supervisor_account_rounded,
                              color: Colors.teal,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Guardian",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── LEGEND ────────────────────────────────────
          if (!_isLoading)
            Positioned(
              top: 90 + MediaQuery.of(context).padding.top,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(10),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Legend",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _legendItem(
                      const Color(0xFF7B4F8E),
                      Icons.person_pin_circle_rounded,
                      "You",
                    ),
                    const SizedBox(height: 4),
                    _legendItem(
                      Colors.teal,
                      Icons.supervisor_account_rounded,
                      "Guardian",
                    ),
                  ],
                ),
              ),
            ),

          // ── FAB ───────────────────────────────────────
          if (!_isLoading)
            Positioned(
              bottom: 30,
              right: 16,
              child: GestureDetector(
                onTap: () => _controller.move(_userPosition, 14),
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

          // ── OSM ATTRIBUTION ───────────────────────────
          if (!_isLoading)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '© OpenStreetMap',
                  style: TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
