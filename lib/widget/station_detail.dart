import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_evcharge/Screen/Map/Map_page.dart';
import 'package:main_evcharge/Screen/ask_detail_form.dart';
import 'package:main_evcharge/Utils.dart/const.dart';
import 'package:main_evcharge/calc.dart/Distance_calcutator.dart'; // For animation

class StationDetailsScreen extends StatefulWidget {
  final String id;
  final String stationName;
  final String stationAddress;
  final double latitude;
  final double longitude;
  final String ownerName;
  final String contactNumber;
  final String chargerType;
  final int numberOfChargers;
  final double powerOutput;

  const StationDetailsScreen({
    super.key,
    required this.id,
    required this.stationName,
    required this.stationAddress,
    required this.latitude,
    required this.longitude,
    required this.ownerName,
    required this.contactNumber,
    required this.chargerType,
    required this.numberOfChargers,
    required this.powerOutput,
  });

  @override
  _StationDetailsScreenState createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  double chargingCapacity = 20; // Default value
  double totalCost = 0;

  double pricePerKW = 5; // Assume price per KW

  @override
  Widget build(BuildContext context) {
    double dis = DistanceCalcutator.calculateDistance(Const.userLatitude,
        Const.userLongitude, widget.latitude, widget.longitude);

    totalCost = chargingCapacity * pricePerKW;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/image/station-second-iamge.jpg',
                ), // Sample image
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Station Details
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stationName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Text(widget.stationAddress,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Owner: ${widget.ownerName}'),
                  const SizedBox(height: 8),
                  Text('Contact: ${widget.contactNumber}'),
                  const SizedBox(height: 8),
                  Text('Charger Type: ${widget.chargerType}'),
                  const SizedBox(height: 8),
                  Text('Power Output: ${widget.powerOutput}kW'),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MapPage()),
                        );
                      },
                      child: Container(
                        height: 180,
                        child:
                            Lottie.asset("assets/animation/Map-animation.json"),
                      ),
                    ),
                    Text(
                      "${dis.toInt().toString()} Km away",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Charging Capacity Slider
          Text(
            'Set Charging Capacity (${chargingCapacity.round()}%)',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: chargingCapacity,
            min: 0,
            max: 100,
            divisions: 100,
            label: '${chargingCapacity.round()}%',
            onChanged: (value) {
              setState(() {
                chargingCapacity = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Total Cost
          Text(
            'Total Cost: ₹${totalCost.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const Spacer(),

          // Animated Payment Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 103, 208, 105),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle payment logic
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BookingForm(id: widget.id),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pay ₹${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  // const SizedBox(width: 8),
                  // Lottie.asset('assets/animation/payment-button.json',
                  //     width: 50, height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void main() => runApp(MaterialApp(
//   home: StationDetailsScreen(
//     station: StationModel(
//       id: '1',
//       stationName: 'Green Energy Charging Station',
//       stationAddress: '123 Clean Drive, Cityville',
//       latitude: 37.7749,
//       longitude: -122.4194,
//       ownerName: 'John Doe',
//       contactNumber: '123-456-7890',
//       chargerType: 'AC Fast Charger',
//       numberOfChargers: 5,
//       powerOutput: 50.0,
//     ),
//   ),
// ));
