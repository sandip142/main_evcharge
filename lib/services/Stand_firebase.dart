import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkPortStatus(String stationId, String standNumber) async {
  try {
    // Reference to the specific document in the nested structure
    final docRef = FirebaseFirestore.instance
        .collection('stations')
        .doc(stationId)
        .collection('ports')
        .doc(standNumber);

    // Fetch the document snapshot
    final docSnapshot = await docRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('busy')) {
        return data['busy'] as bool; // Return the boolean value of 'busy'
      }
    }
    // Default to false if the document or the 'busy' field is missing
    print('Document or busy field does not exist. Returning false.');
    return false;
  } catch (e) {
    print('Error fetching document: $e. Returning false.');
    return false; // Return false in case of an error
  }
}
