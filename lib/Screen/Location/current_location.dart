import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';  // Import for loading animation
import 'package:geolocator/geolocator.dart';
import 'package:main_evcharge/Screen/Stations_screen.dart';
import 'package:main_evcharge/data/current_lacation_store.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _isLoading = true;  // Track loading state

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetLocation();  // Start location fetch on launch
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    while (true) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await _showLocationServicesDialog();
        continue;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await _showPermissionDialog();
        continue;
      }

      await _getCurrentLocation();  // Fetch location if everything is set
      break;
    }
  }

  Future<void> _showLocationServicesDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Location Services'),
        content: const Text(
            'Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,  // Prevent dismissal without action
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location access to function properly. Please allow location permission.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();  // Close the dialog
              LocationPermission permission =
                  await Geolocator.requestPermission();

              if (permission == LocationPermission.deniedForever) {
                await Geolocator.openAppSettings();
              }
            },
            child: const Text('Allow Permission'),
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

      // Store the latitude and longitude in LocationStorage
      LocationStorage().setLocation(position.latitude, position.longitude);
      print("User Lat: ${position.latitude}");
      print("User Long: ${position.longitude}");

      // Navigate to the next page (StationsScreen)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StationsScreen()),
      );
    } catch (e) {
      print('Failed to get location: $e');
    } finally {
      setState(() {
        _isLoading = false;  // Stop the loading animation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Transparent background loading screen
          if (_isLoading)
            Positioned.fill(
              child: Container(
              //  color: Colors.black.withOpacity(0.5),  // Transparent background
                child: const Center(
                  child: SpinKitFadingFour(  // Dotted loading indicator
                    color: Color.fromARGB(255, 134, 92, 206),
                    size: 50.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
