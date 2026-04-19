import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("tracking");
  LatLng _currentPosition = const LatLng(30.1575, 71.5249);
  final MapController _mapController = MapController();
  bool _isLoading = true;
  String _errorMessage = '';
  double _currentZoom = 16.0;
  bool _isMapReady = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Animation setup (Don't change this, it keeps the pulse effect)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 2. Mobile GPS ki bajaye Firebase sun-na shuru karein
    _listenToFirebaseTracking();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // Purane _determinePosition aur _startLocationUpdates ki jagah ye aik function:
  void _listenToFirebaseTracking() {
    setState(() => _isLoading = true);

    // Database ke 'tracking' node ko listen karna
    _dbRef.onValue.listen(
      (DatabaseEvent event) {
        final data = event.snapshot.value as Map?;

        if (data != null && mounted) {
          setState(() {
            // Hardware coordinates: 'latitude' aur 'longitude' keys database mein honi chahiye
            double lat = data['latitude']?.toDouble() ?? 30.1575;
            double lng = data['longitude']?.toDouble() ?? 71.5249;

            _currentPosition = LatLng(lat, lng);
            _isLoading = false;
          });

          // Map ko hardware ki live location par move karna
          if (_isMapReady) {
            _mapController.move(_currentPosition, _currentZoom);
          }
        }
      },
      onError: (error) {
        setState(() {
          _errorMessage = "Firebase Sync Error: $error";
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── MAP / LOADING / ERROR ──────────────────────────
          if (_isLoading)
            _buildLoadingScreen()
          else if (_errorMessage.isNotEmpty)
            _buildErrorScreen()
          else
            _buildMap(),

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
                          "Live Safety Map",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      // Live badge
                      if (!_isLoading && _errorMessage.isEmpty)
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
                      // Refresh button
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _listenToFirebaseTracking,
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

          // ── LOCATION INFO CARD ────────────────────────────
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              bottom: 110,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
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
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "GPS Active",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Lat: ${_currentPosition.latitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      'Lng: ${_currentPosition.longitude.toStringAsFixed(5)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── ZOOM + LOCATION FABs ──────────────────────────
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              right: 16,
              bottom: 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _mapButton(
                    Icons.add_rounded,
                    () {
                      setState(
                        () =>
                            _currentZoom = (_currentZoom + 1).clamp(3.0, 19.0),
                      );
                      _mapController.move(_currentPosition, _currentZoom);
                    },
                    color: Colors.white,
                    iconColor: Colors.black87,
                  ),
                  const SizedBox(height: 8),
                  _mapButton(
                    Icons.remove_rounded,
                    () {
                      setState(
                        () =>
                            _currentZoom = (_currentZoom - 1).clamp(3.0, 19.0),
                      );
                      _mapController.move(_currentPosition, _currentZoom);
                    },
                    color: Colors.white,
                    iconColor: Colors.black87,
                  ),
                  const SizedBox(height: 8),
                  _mapButton(
                    Icons.my_location_rounded,
                    () {
                      _mapController.move(_currentPosition, _currentZoom);
                    },
                    color: const Color(0xFF7B4F8E),
                    iconColor: Colors.white,
                    size: 52,
                  ),
                ],
              ),
            ),

          // ── OSM ATTRIBUTION ───────────────────────────────
          if (!_isLoading && _errorMessage.isEmpty)
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

  // ── MAP WIDGET ───────────────────────────────────────────────
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition,
        initialZoom: _currentZoom,
        onMapReady: () {
          setState(() {
            _isMapReady = true; // State update karein taake UI refresh ho
          });
          // Map ready hotay hi hardware ki current location par jump karein
          _mapController.move(_currentPosition, _currentZoom);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.womensafety.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition,
              width: 80,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7B4F8E).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF7B4F8E),
                          width: 2.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_pin_circle_rounded,
                        color: Color(0xFF7B4F8E),
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── LOADING SCREEN ───────────────────────────────────────────
  Widget _buildLoadingScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Fetching your location...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Connecting to Safety Device...",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── ERROR SCREEN ─────────────────────────────────────────────
  Widget _buildErrorScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B4F8E), Color(0xFF9B6FA3), Color(0xFFD4B8DA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Location Required",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _listenToFirebaseTracking,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.gps_fixed_rounded,
                              color: Color(0xFF7B4F8E),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Retry",
                              style: TextStyle(
                                color: Color(0xFF7B4F8E),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── MAP BUTTON HELPER ────────────────────────────────────────
  Widget _mapButton(
    IconData icon,
    VoidCallback onTap, {
    required Color color,
    required Color iconColor,
    double size = 44,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size == 52 ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: color == Colors.white
                  ? Colors.black.withOpacity(0.15)
                  : const Color(0xFF7B4F8E).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size == 52 ? 24 : 20),
      ),
    );
  }
}
