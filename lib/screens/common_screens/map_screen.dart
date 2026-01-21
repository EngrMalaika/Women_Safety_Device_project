import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentPosition = const LatLng(0, 0); // Initial 0,0
  final MapController _mapController = MapController();
  bool _isLoading = true;
  String _errorMessage = '';
  double _currentZoom = 16.0;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // REAL LOCATION FETCHING - No manual setting
  Future<void> _determinePosition() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // 1. Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. '
              'Please enable GPS on your device.';
          _isLoading = false;
        });
        return;
      }

      // 2. Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied. '
                'Please grant location access in app settings.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied. '
              'Please enable them in device settings.';
          _isLoading = false;
        });
        return;
      }

      // 3. Get current position with HIGH accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).timeout(const Duration(seconds: 15));

      // 4. Update UI with real location
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      // 5. Move map to real location
      if (_isMapReady) {
        _mapController.move(_currentPosition, _currentZoom);
      }

      // 6. Start listening for live updates
      _startLocationUpdates();

    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get location: ${e.toString()}'
            '\n\nMake sure:'
            '\n1. GPS is ON'
            '\n2. Location permission is granted'
            '\n3. You are outdoors for better signal'
            '\n4. Try on a physical device (emulator GPS may not work)';
        _isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentPosition, _currentZoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Safety Map"),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _determinePosition,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : _errorMessage.isNotEmpty
              ? _buildErrorScreen()
              : _buildMapScreen(),
      floatingActionButton: !_isLoading && _errorMessage.isEmpty
          ? _buildFloatingButtons()
          : null,
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            'Fetching your live location...',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Make sure GPS is enabled',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Location Access Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _determinePosition,
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text('Get My Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    // Open location settings
                    await Geolocator.openLocationSettings();
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapScreen() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: _currentZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onMapReady: () {
              _isMapReady = true;
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
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Location Info Card
        Positioned(
          top: 10,
          left: 10,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gps_fixed, size: 16, color: Colors.green),
                      const SizedBox(width: 5),
                      const Text(
                        'Live Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Active',
                        style: TextStyle(fontSize: 10, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lat: ${_currentPosition.latitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Lng: ${_currentPosition.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Zoom: ${_currentZoom.toStringAsFixed(1)}x',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Attribution
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              '© OpenStreetMap',
              style: TextStyle(fontSize: 9, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          heroTag: 'zoom_in',
          onPressed: () {
            setState(() {
              _currentZoom += 1;
            });
            _mapController.move(_currentPosition, _currentZoom);
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.small(
          heroTag: 'zoom_out',
          onPressed: () {
            setState(() {
              _currentZoom -= 1;
              if (_currentZoom < 3) _currentZoom = 3;
            });
            _mapController.move(_currentPosition, _currentZoom);
          },
          child: const Icon(Icons.remove),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'center_location',
          onPressed: () {
            _mapController.move(_currentPosition, _currentZoom);
          },
          backgroundColor: Colors.pink,
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'refresh_location',
          onPressed: _determinePosition,
          backgroundColor: Colors.blue,
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}