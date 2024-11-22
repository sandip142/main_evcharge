import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:main_evcharge/Screen/Auth/login.dart';
import 'package:main_evcharge/Screen/detail_screen.dart';
import 'package:main_evcharge/Screen/profile.dart';
import 'package:main_evcharge/Utils.dart/const.dart';
import 'package:main_evcharge/calc.dart/Distance_calcutator.dart';
import 'package:main_evcharge/data/Image_data.dart';
import 'package:main_evcharge/data/Station_data.dart';
import 'package:main_evcharge/data/current_lacation_store.dart';
import 'package:main_evcharge/services/firebase_email.dart';
import 'package:main_evcharge/widget/station_card.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  StationData st = StationData();
  ImagePathData img = ImagePathData();
  bool isLoading = true;
  double? latitude = LocationStorage().getLatitude();
  double? longitude = LocationStorage().getLongitude();

  // To track loading state

  @override
  void initState() {
    super.initState();
    fetchStations(); // Fetch station data when the screen loads
  }

  // Fetch stations and update the state
  Future<void> fetchStations() async {
    try {
      await st.fetchStationsFromFirebase(); // Fetch data from Firebase
      setState(() {
        isLoading = false; // Stop loading after data is fetched
      });
    } catch (e) {
      print('Error fetching stations: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void getUserData() async {
    FirebaseService firebaseService = FirebaseService();
    try {
      Map<String, String> userDetails = await firebaseService.getUserDetails();
      print('Email: ${userDetails['email']}');
      print('Name: ${userDetails['name']}');
      print('Mobile: ${userDetails['mobile']}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charging Station"),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            icon: const Icon(Icons.face_retouching_natural),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 100),
            ListTile(
              onTap: getUserData,
              title:
                  const Text("Update Profile", style: TextStyle(fontSize: 20)),
              leading: const Icon(Icons.update),
            ),
            ListTile(
              onTap: () => logout(context),
              title: const Text("Logout", style: TextStyle(fontSize: 20)),
              leading: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingFour(
                // Dotted loading indicator
                color:Color.fromARGB(255, 134, 92, 206),
                size: 50.0,
              ),
            ) // Show loader while fetching data
          : ListView.builder(
              itemCount: st.chargingStations.length,
              itemBuilder: (context, index) {
                // Calculate the distance between current location and the station
                double distance = DistanceCalcutator.calculateDistance(
                  latitude ?? Const.userLatitude,
                  longitude ?? Const.userLongitude,
                  st.chargingStations[index].latitude,
                  st.chargingStations[index].longitude,
                );

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(id: st.chargingStations[index].id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChargingStationCard(
                      stationName: st.chargingStations[index].stationName,
                      location: st.chargingStations[index].stationAddress,
                      distance: distance.toDouble(),
                      imagePath: img.imagepaths[index %
                          img.imagepaths.length], // Prevent index overflow
                      rating: 4.5,
                      powerOutput: st.chargingStations[index].powerOutput,
                      chargerType: st.chargingStations[index].chargerType,
                      isBook: st.chargingStations[index].isBook,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
