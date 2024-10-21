class LocationStorage {
  // Singleton instance
  static final LocationStorage _instance = LocationStorage._internal();

  // Private constructor
  LocationStorage._internal();

  // Factory constructor to return the same instance
  factory LocationStorage() => _instance;

  // Variables to store latitude and longitude
  double? latitude;
  double? longitude;

  // Method to set location
  void setLocation(double lat, double lon) {
    latitude = lat;
    longitude = lon;
  }

  // Method to get latitude
  double? getLatitude() => latitude;

  // Method to get longitude
  double? getLongitude() => longitude;
}
