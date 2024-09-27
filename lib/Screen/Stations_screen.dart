import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:main_evcharge/Screen/Auth/login.dart';
import 'package:main_evcharge/Screen/detail_screen.dart';
import 'package:main_evcharge/Screen/profile.dart';
import 'package:main_evcharge/Utils.dart/const.dart';
import 'package:main_evcharge/calc.dart/Distance_calcutator.dart';
import 'package:main_evcharge/data/Image_data.dart';
import 'package:main_evcharge/data/Station_data.dart';
import 'package:main_evcharge/widget/station_card.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({super.key});

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  StationData st = StationData();
  ImagePathData img = ImagePathData();

  

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Update Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.update),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "FingerPrint",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.fingerprint_rounded),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Setting",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.settings),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Payment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.payment),
            ),
            ListTile(
              onTap: () {},
              title: const Text(
                "Detail",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.details_rounded),
            ),
            ListTile(
              onTap: () => logout(context),
              title: const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              leading: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: st.chargingStations.length,
        itemBuilder: (context, index) {
          //function to calculate the distance between all station with your curent location
          double dis = DistanceCalcutator.calculateDistance(
            Const.userLatitude,
            Const.userLongitude,
            st.chargingStations[index].latitude,
            st.chargingStations[index].longitude,
          );
          //that is widget for card with detail
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
                distance: dis.toInt().toDouble(),
                imagePath: img.imagepaths[index],
                rating: 4.5,
              ),
            ),
          );
        },
      ),
    );
  }
}
