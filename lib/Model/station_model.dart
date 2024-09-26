class StationModel {
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

  StationModel({
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
}