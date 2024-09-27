import 'package:flutter/material.dart';
import 'package:main_evcharge/Function/get_first_model.dart';
import 'package:main_evcharge/data/Station_data.dart';
import 'package:main_evcharge/widget/station_detail.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    StationData st = StationData();
    final stationModel = st.getStationById(id);
    return Scaffold(
      body: StationDetailsScreen(
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
    );
  }
}
