import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to extract email, name, and mobile number from authenticated user
  Future<Map<String, String>> getUserDetails() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    // Get email from Firebase Authentication
    String email = user.email ?? 'No email';

    try {
      // Retrieve additional details (name and mobile) from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid) // Assumes the user's UID is used as the document ID
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        String name = data['name'] ?? 'No name';
        String mobile = data['mobile'] ?? 'No mobile';

        return {
          'email': email,
          'name': name,
          'mobile': mobile,
        };
      } else {
        throw Exception('User details not found in Firestore.');
      }
    } catch (e) {
      throw Exception('Error retrieving user details: $e');
    }
  }
}
