import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class TrackGuardianScreen extends StatefulWidget {
  const TrackGuardianScreen({super.key});

  @override
  State<TrackGuardianScreen> createState() => _TrackGuardianScreenState();
}

class _TrackGuardianScreenState extends State<TrackGuardianScreen> {
  final MapController _controller = MapController();
  LatLng _userPosition = const LatLng(0, 0);
  LatLng? _guardianPosition;
  final List<Marker> _markers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocations();
  }

  Future<void> _getLocations() async {
    // Get user location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // In a real app, you would fetch guardian location from Firestore/API
    // For demo, we'll create a simulated guardian position
    Position guardianPosition = Position(
      latitude: userPosition.latitude + 0.01,
      longitude: userPosition.longitude + 0.01,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    setState(() {
      _userPosition = LatLng(userPosition.latitude, userPosition.longitude);
      _guardianPosition = LatLng(guardianPosition.latitude, guardianPosition.longitude);

      // Add markers
      _markers.addAll([
        // User marker
        Marker(
          point: _userPosition,
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 40,
          ),
        ),
        // Guardian marker
        Marker(
          point: _guardianPosition!,
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.supervisor_account,
            color: Colors.green,
            size: 40,
          ),
        ),
      ]);
      
      _isLoading = false;
    });
  }

  void _centerMap() {
    if (_userPosition.latitude != 0 && _userPosition.longitude != 0) {
      _controller.move(_userPosition, 14);
    }
  }

  void _refreshLocations() {
    setState(() {
      _isLoading = true;
    });
    _getLocations();
  }

  double _calculateDistance() {
    if (_guardianPosition == null) return 0;
    
    const Distance distance = Distance();
    return distance(_userPosition, _guardianPosition!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track Guardian",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: _refreshLocations,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Distance Info Card
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Distance to Guardian',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_calculateDistance().toStringAsFixed(2)} meters',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('You'),
                            SizedBox(width: 32),
                            Icon(Icons.supervisor_account, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Guardian'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Map
                Expanded(
                  child: FlutterMap(
                    mapController: _controller,
                    options: MapOptions(
                      initialCenter: _userPosition,
                      initialZoom: 14,
                      onMapReady: () {
                        _centerMap();
                      },
                    ),
                    children: [
                      // OpenStreetMap tile layer
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.safety_app',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      // Marker layer
                      MarkerLayer(markers: _markers),
                      // Polyline layer for showing path/distance
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [_userPosition, _guardianPosition!],
                            color: const Color.fromRGBO(128, 0, 128, 0.5), // Fixed withOpacity deprecation
                            strokeWidth: 3,
                            isDotted: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMap,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}