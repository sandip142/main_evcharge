import 'package:flutter/material.dart';

class ChargingStationCard extends StatelessWidget {
  final String stationName;
  final String location;
  final double distance;
  final String imagePath;
  final double rating;

  const ChargingStationCard({
    super.key,
    required this.stationName,
    required this.location,
    required this.distance,
     required this.imagePath,
    required this.rating
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Station Information
            Text(
              stationName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${distance.toString()} km away',
                  style: const TextStyle(fontSize: 14),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.yellow),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Additional Information
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Power'),
                    Text('50 kW', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type'),
                    Text('DC Fast', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment'),
                    Text('Credit Card', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



