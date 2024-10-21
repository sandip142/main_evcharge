import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:main_evcharge/Screen/Stations_screen.dart';
import 'package:main_evcharge/data/current_lacation_store.dart';
  // Import the StationScreen

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String locationMessage = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetLocation(); // Request location on app start
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    while (true) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationMessage = 'Please enable location services.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          await _showPermissionDialog();
          continue; // Keep asking for permission
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage = 'Location permission is permanently denied.';
        });
        return;
      }

      _getCurrentLocation(); // Fetch location if permission is granted
      break;
    }
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location access to function properly. Please allow location permission.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Store latitude and longitude using LocationStorage
      LocationStorage().setLocation(position.latitude, position.longitude);

      // Navigate to the next page (StationScreen)
     Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StationsScreen(),
        ));
    } catch (e) {
      setState(() {
        locationMessage = 'Failed to get location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location on App Load'),
      ),
      body: Center(
        child: Text(
          locationMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
