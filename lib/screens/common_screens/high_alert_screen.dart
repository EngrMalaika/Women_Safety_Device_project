import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HighAlertAreasScreen extends StatefulWidget {
  const HighAlertAreasScreen({super.key});

  @override
  State<HighAlertAreasScreen> createState() => _HighAlertAreasScreenState();
}

class _HighAlertAreasScreenState extends State<HighAlertAreasScreen> {
  MapController mapController = MapController();
  LatLng _currentPosition = const LatLng(0, 0);
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];
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
          child: const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 40,
          ),
        ),
      );

      // Example high-alert areas (in a real app, this would come from an API)
      _markers.addAll([
        Marker(
          point: LatLng(
            position.latitude + 0.005,
            position.longitude + 0.005,
          ),
          width: 80,
          height: 80,
          child: const Icon(
            Icons.warning,
            color: Colors.red,
            size: 40,
          ),
        ),
        Marker(
          point: LatLng(
            position.latitude - 0.004,
            position.longitude + 0.003,
          ),
          width: 80,
          height: 80,
          child: const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 40,
          ),
        ),
        Marker(
          point: LatLng(
            position.latitude + 0.003,
            position.longitude - 0.004,
          ),
          width: 80,
          height: 80,
          child: const Icon(
            Icons.warning,
            color: Colors.yellow,
            size: 40,
          ),
        ),
      ]);

      // Add circles around high-alert areas
      _circles.addAll([
        CircleMarker(
          point: LatLng(
            position.latitude + 0.005,
            position.longitude + 0.005,
          ),
          color: Colors.red.withOpacity(0.3),
          borderColor: Colors.red,
          borderStrokeWidth: 2,
          radius: 500, // 500 meters
        ),
        CircleMarker(
          point: LatLng(
            position.latitude - 0.004,
            position.longitude + 0.003,
          ),
          color: Colors.orange.withOpacity(0.3),
          borderColor: Colors.orange,
          borderStrokeWidth: 2,
          radius: 400,
        ),
        CircleMarker(
          point: LatLng(
            position.latitude + 0.003,
            position.longitude - 0.004,
          ),
          color: Colors.yellow.withOpacity(0.3),
          borderColor: Colors.yellow,
          borderStrokeWidth: 2,
          radius: 300,
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
          "High Alert Areas",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        elevation: 5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 14,
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
                // Circle layer for high-alert areas
                CircleLayer(circles: _circles),
                // Marker layer
                MarkerLayer(markers: _markers),
                // Legend
                const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red),
                                SizedBox(width: 8),
                                Text('High Risk'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.orange),
                                SizedBox(width: 8),
                                Text('Medium Risk'),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.warning, color: Colors.yellow),
                                SizedBox(width: 8),
                                Text('Low Risk'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _centerMapOnUser,
        backgroundColor: Colors.red,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}