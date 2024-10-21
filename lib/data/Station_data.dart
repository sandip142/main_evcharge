import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_evcharge/Model/station_model.dart';

class StationData {
  List<StationModel> chargingStations = [];

  // Fetch data from Firebase Firestore
  Future<void> fetchStationsFromFirebase() async {
    try {
      // Get all documents from the 'stations' collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('stations').get();

      // Clear the existing list before updating
      chargingStations.clear();

      // Map the documents to the StationModel
      chargingStations = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StationModel(
          id: doc.id,  // using doc id as the station id
          stationName: data['stationName'],
          stationAddress: data['stationAddress'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          ownerName: data['ownerName'],
          contactNumber: data['contactNumber'],
          chargerType: data['chargerType'],
          numberOfChargers: data['numberOfChargers'],
          powerOutput: data['powerOutput'],
          isBook: data['isBook'],
          category: data['category'],
        );
      }).toList();

        print("Stations fetched successfully: ${chargingStations.length}");
      //print("Stations fetched successfully!");
    } catch (e) {
      print("Error fetching stations: $e");
    }
  }

  // Get station by ID
  StationModel getStationById(String id) {
    return chargingStations.firstWhere((station) => station.id == id);
  }
}




// import 'package:main_evcharge/Model/station_model.dart';

// class StationData {
                       
// StationModel getStationById(String id){
//  return chargingStations.firstWhere((station) => station.id == id);
// } 

//   List<StationModel> chargingStations = [
//     StationModel(
//       id: '1',
//       stationName: 'FastCharge Hub',
//       stationAddress: '123 Green Road, EV City',
//       latitude: 19.1234,
//       longitude: 72.4567,
//       ownerName: 'John Smith',
//       contactNumber: '9876543210',
//       chargerType: 'AC Charging',
//       numberOfChargers: 4,
//       powerOutput: 22.0,
//       isBook:true,
//       category:"two wheeler",
//     ),
//     StationModel(
//       id: '2',
//       stationName: 'EcoCharge Station',
//       stationAddress: '456 Blue Drive, Energy Town',
//       latitude: 18.5678,
//       longitude: 73.6789,
//       ownerName: 'Jane Doe',
//       contactNumber: '9988776655',
//       chargerType: 'DC Fast Charging',
//       numberOfChargers: 3,
//       powerOutput: 50.0,
//       isBook:true,
//       category:"four wheeler",
//     ),
//     StationModel(
//       id: '3',
//       stationName: 'EV Express',
//       stationAddress: '789 Charging Lane, Power City',
//       latitude: 19.8765,
//       longitude: 72.1234,
//       ownerName: 'Robert Johnson',
//       contactNumber: '9123456789',
//       chargerType: 'Fast Charging',
//       numberOfChargers: 5,
//       powerOutput: 60.0,
//       isBook:true,
//       category:"two wheeler",
//     ),
//     StationModel(
//       id: '4',
//       stationName: 'QuickCharge Point',
//       stationAddress: '102 Red Street, Volt Village',
//       latitude: 20.4567,
//       longitude: 73.3456,
//       ownerName: 'Alice Cooper',
//       contactNumber: '9012345678',
//       chargerType: 'AC Charging',
//       numberOfChargers: 6,
//       powerOutput: 30.0,
//       isBook:true,
//       category:"two wheeler",
//     ),
//     StationModel(
//       id: '5',
//       stationName: 'ChargeIt Pro',
//       stationAddress: '345 Power Road, Spark Town',
//       latitude: 21.3456,
//       longitude: 74.4567,
//       ownerName: 'Steve Rogers',
//       contactNumber: '8901234567',
//       chargerType: 'DC Fast Charging',
//       numberOfChargers: 2,
//       powerOutput: 100.0,
//       isBook:true,
//       category:"four wheeler",
//     ),
//     StationModel(
//       id: '6',
//       stationName: 'GreenCharge Station',
//       stationAddress: '678 Electric Avenue, Battery City',
//       latitude: 22.1234,
//       longitude: 75.5678,
//       ownerName: 'Natasha Romanoff',
//       contactNumber: '8098765432',
//       chargerType: 'AC Charging',
//       numberOfChargers: 3,
//       powerOutput: 22.0,
//       isBook:true,
//       category:"four wheeler",
//     ),
//     StationModel(
//       id: '7',
//       stationName: 'VoltCharge Point',
//       stationAddress: '910 Current Street, Tesla Town',
//       latitude: 23.4567,
//       longitude: 76.6789,
//       ownerName: 'Tony Stark',
//       contactNumber: '7987654321',
//       chargerType: 'DC Fast Charging',
//       numberOfChargers: 4,
//       powerOutput: 120.0,
//       isBook:true,
//       category:"two wheeler",
//     ),
//   ];
// }