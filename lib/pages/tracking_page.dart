import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final List<LatLng> stations = [
    LatLng(13.0771, 80.2602), // Chennai Egmore
    LatLng(12.9223, 80.1278), // Tambaram
    LatLng(12.6871, 79.9773), // Chengalpattu
    LatLng(11.9402, 79.4878), // Villupuram
    LatLng(10.7870, 78.6965), // Tiruchirapalli
    LatLng(10.3564, 77.9627), // Dindigul
    LatLng(9.9197, 78.1195),  // Madurai
  ];

  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle the case when location services are not enabled
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case when permission is denied
        return;
      }
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Update location periodically
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Route'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _currentPosition ?? LatLng(11.1271, 78.6569), // Default center if current location is not available
          zoom: 7.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _generateCurvedPolyline(stations),
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              for (var station in stations)
                Marker(
                  point: station,
                  builder: (context) => Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 30.0,
                  ),
                ),
              if (_currentPosition != null)
                Marker(
                  point: _currentPosition!,
                  builder: (context) => Icon(
                    Icons.my_location,
                    color: Colors.green,
                    size: 30.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Generates a curved polyline
  List<LatLng> _generateCurvedPolyline(List<LatLng> points) {
    final List<LatLng> curvedPoints = [];
    final LatLng controlOffset = LatLng(0.1, 0.1); // Adjust this for smoother curves
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final midPoint = LatLng(
        (p1.latitude + p2.latitude) / 2,
        (p1.longitude + p2.longitude) / 2,
      );
      final controlPoint = LatLng(
        (p1.latitude + p2.latitude) / 2 + controlOffset.latitude,
        (p1.longitude + p2.longitude) / 2 + controlOffset.longitude,
      );
      curvedPoints.add(p1);
      curvedPoints.add(controlPoint);
      curvedPoints.add(p2);
    }
    return curvedPoints;
  }
}
