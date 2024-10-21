import 'package:flutter/material.dart';
import 'package:main_evcharge/data/Station_data.dart';
import 'package:main_evcharge/widget/station_detail.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final StationData stationData = StationData();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStationData(); // Fetch station data when the page is initialized
  }

  Future<void> fetchStationData() async {
    await stationData.fetchStationsFromFirebase(); // Fetch all stations
    setState(() {
      isLoading = false; // Stop loading once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loader while data loads
      );
    }

    // Retrieve the station by ID after data is loaded
    final stationModel = stationData.getStationById(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(stationModel.stationName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StationDetailsScreen(
          isBook: stationModel.isBook,
          id: stationModel.id,
          stationName: stationModel.stationName,
          stationAddress: stationModel.stationAddress,
          latitude: stationModel.latitude,
          longitude: stationModel.longitude,
          ownerName: stationModel.ownerName,
          contactNumber: stationModel.contactNumber,
          chargerType: stationModel.chargerType,
          numberOfChargers: stationModel.numberOfChargers,
          powerOutput: stationModel.powerOutput,
        ),
      ),
    );
  }
}
