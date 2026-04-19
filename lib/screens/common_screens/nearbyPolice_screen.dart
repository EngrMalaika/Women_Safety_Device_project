import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safety_app/screens/common_screens/helplines_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPoliceScreen extends StatefulWidget {
  const NearbyPoliceScreen({super.key});

  @override
  State<NearbyPoliceScreen> createState() => _NearbyPoliceScreenState();
}

class _NearbyPoliceScreenState extends State<NearbyPoliceScreen>
    with TickerProviderStateMixin {
  void _navigateToHelplines() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelplinesScreen()),
    );
    print("Navigating to Helplines..."); // Filhal testing ke liye
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _policeStations = [];

  final MapController mapController = MapController();
  LatLng _currentPosition = const LatLng(30.1575, 71.5249); // Multan Default
  final List<Marker> _markers = [];
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
    _getUserLocation().then((_) => _listenToPoliceStations());
  }

  void _listenToPoliceStations() {
    _dbRef.child("police_stations").onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<Map<String, dynamic>> tempStations = [];
        data.forEach((key, value) {
          // Safe casting: int or double both work
          double lat = (value['latitude'] as num).toDouble();
          double lng = (value['longitude'] as num).toDouble();

          double distance =
              Geolocator.distanceBetween(
                _currentPosition.latitude,
                _currentPosition.longitude,
                lat,
                lng,
              ) /
              1000;

          tempStations.add({
            'name': value['name'],
            'lat': lat,
            'lng': lng,
            'distance': distance.toStringAsFixed(1),
            'address': value['address'] ?? '',
          });
        });

        // Kareeb tareen stations ko top par laayein
        tempStations.sort(
          (a, b) => double.parse(
            a['distance'],
          ).compareTo(double.parse(b['distance'])),
        );

        if (mounted) {
          setState(() {
            _policeStations = tempStations;
            _buildMarkers();
          });
        }
      }
    });
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

    _buildMarkers();
    setState(() => _isLoading = false);
  }

  void _buildMarkers() {
    _markers.clear(); // Clear existing markers before rebuilding

    // 1. User marker (Purple Pulse)
    _markers.add(
      Marker(
        point: _currentPosition,
        width: 60,
        height: 60,
        child: ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF7B4F8E).withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF7B4F8E), width: 2.5),
            ),
            child: const Icon(
              Icons.person_pin_circle_rounded,
              color: Color(0xFF7B4F8E),
              size: 28,
            ),
          ),
        ),
      ),
    );

    // 2. Police station markers (Live from Firebase)
    // Police station markers loop update
    for (final station in _policeStations) {
      _markers.add(
        Marker(
          point: LatLng(station['lat'], station['lng']),
          width: 52,
          height: 52,
          child: GestureDetector(
            onTap: () =>
                _showStationDetails(station), // Click par details dikhayega
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue.shade400, width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 6),
                ],
              ),
              child: Icon(
                Icons.local_police_rounded,
                color: Colors.blue.shade700,
                size: 24,
              ),
            ),
          ),
        ),
      );
    }
  }

  void _showStationDetails(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station Name
            Text(
              station['name'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF7B4F8E),
              ),
            ),
            const SizedBox(height: 10),

            // Address Row
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    station['address'],
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Distance Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${station['distance']} km away",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // Popup band karein
                _launchNavigation(
                  station['lat'],
                  station['lng'],
                ); // Navigation start karein
              },
              icon: const Icon(Icons.directions_rounded),
              label: const Text(
                "Get Directions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B4F8E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Google Maps navigation ke liye
  Future<void> _launchNavigation(double lat, double lng) async {
    // Google Maps URL scheme for navigation
    final String googleMapsUrl = "google.navigation:q=$lat,$lng&mode=d";
    // Apple Maps alternative for iOS
    final String appleMapsUrl = "http://maps.apple.com/?daddr=$lat,$lng";

    try {
      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
        await launchUrl(Uri.parse(googleMapsUrl));
      } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
        await launchUrl(Uri.parse(appleMapsUrl));
      } else {
        // Agar koi app na ho toh browser mein open karein
        final String browserUrl =
            "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
        await launchUrl(
          Uri.parse(browserUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint("Could not launch maps: $e");
    }
  }

  void _centerMapOnUser() {
    mapController.move(_currentPosition, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── MAP ─────────────────────────────────────────────
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
                    initialZoom: 15,
                    onMapReady: () => _centerMapOnUser(),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.womensafety.app',
                    ),
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
                          "Nearby Police Stations",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      // Count badge
                      if (!_isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_police_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${_policeStations.length} Nearby",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
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
                      color: Colors.black.withOpacity(0.1),
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
                      "Legend",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _legendItem(
                      const Color(0xFF7B4F8E),
                      Icons.person_pin_circle_rounded,
                      "You",
                    ),
                    const SizedBox(height: 6),
                    _legendItem(
                      Colors.blue,
                      Icons.local_police_rounded,
                      "Police",
                    ),
                  ],
                ),
              ),
            ),

          // ── BOTTOM INFO & ACTION ROW ──────────────────────────────
          if (!_isLoading)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16, // Screen ki puri width use karein
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Dono ko sides par rakhega
                children: [
                  // Info Card (Stations Found)
                  Flexible(
                    // Text lambi hone par app crash nahi hogi
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_police_rounded,
                            color: Colors.blue.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_policeStations.length} Nearby",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── NEAREST STATION QUICK WIDGET & CALL BUTTON ──────────
                  if (!_isLoading && _policeStations.isNotEmpty)
                    Positioned(
                      bottom: 100, // Bottom se 100 pixels upar
                      right: 16, // Right side se 16 pixels ka gap
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // Taake widget aur button right side par barabar hon
                        children: [
                          // 1. NEAREST STATION SMALL WIDGET (NEW)
                          GestureDetector(
                            onTap: () {
                              // Nearest station ke coordinates
                              final lat = _policeStations[0]['lat'];
                              final lng = _policeStations[0]['lng'];

                              // Map ko us location par move karein
                              mapController.move(LatLng(lat, lng), 17.0);

                              // Popup details bhi show karein (agar function banaya hai)
                              _showStationDetails(_policeStations[0]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 12,
                              ), // Button se thoda gap
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.near_me_rounded,
                                    color: Colors.blue,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Nearest: ${_policeStations[0]['name']}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "(${_policeStations[0]['distance']} km)",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 2. EXISTING CALL HELPLINES BUTTON
                          GestureDetector(
                            onTap: _navigateToHelplines,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7B4F8E),
                                    Color(0xFF9B6FA3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7B4F8E,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.phone_in_talk_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Call Helplines",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
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
                ],
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

          // ── OSM ATTRIBUTION ───────────────────────────────
          if (!_isLoading)
            Positioned(
              bottom: 10,
              left: 10,
              child: GestureDetector(
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 14),
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
