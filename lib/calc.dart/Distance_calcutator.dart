import 'dart:math';

class DistanceCalcutator {
  static double calculateDistance(double userLat, double userLon,double stlat,double stlon) {
    const double earthRadius = 6371; // Earth radius in kilometers

    double dLat = _degreesToRadians(stlat - userLat);
    double dLon = _degreesToRadians(stlon - userLon);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(userLat)) *
            cos(_degreesToRadians(stlat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Distance in kilometers
  }

  // Helper function to convert degrees to radians
 static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}