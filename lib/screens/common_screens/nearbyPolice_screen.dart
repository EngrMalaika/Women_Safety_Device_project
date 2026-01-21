import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPoliceScreen extends StatefulWidget {
  const NearbyPoliceScreen({super.key});

  @override
  State<NearbyPoliceScreen> createState() => _NearbyPoliceScreenState();
}

class _NearbyPoliceScreenState extends State<NearbyPoliceScreen> {
  MapController mapController = MapController();
  LatLng _currentPosition = const LatLng(0, 0);
  final List<Marker> _markers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);

      // Add marker for user's location
      _markers.add(
        Marker(
          point: _currentPosition,
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.location_on,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );

      // Add some nearby police stations (example coordinates)
      _markers.addAll([
        Marker(
          point: LatLng(
            position.latitude + 0.002,
            position.longitude + 0.002,
          ),
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.local_police,
            color: Colors.red,
            size: 40,
          ),
        ),
        Marker(
          point: LatLng(
            position.latitude - 0.003,
            position.longitude + 0.001,
          ),
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.local_police,
            color: Colors.red,
            size: 40,
          ),
        ),
        Marker(
          point: LatLng(
            position.latitude + 0.001,
            position.longitude - 0.003,
          ),
          width: 80,
          height: 80,
          child: const Icon(  // Changed from builder to child
            Icons.local_police,
            color: Colors.red,
            size: 40,
          ),
        ),
      ]);
      
      _isLoading = false;
    });
  }

  void _centerMapOnUser() {
    if (_currentPosition.latitude != 0 && _currentPosition.longitude != 0) {
      mapController.move(_currentPosition, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nearby Police Stations",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.pink,
        elevation: 5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 15,
                onMapReady: () {
                  _centerMapOnUser();
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
                // Attribution
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMapOnUser,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}