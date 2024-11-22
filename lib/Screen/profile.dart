import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  String? description;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _saveUserProfile({
    required String name,
    required String phone,
    required String description,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': name,
          'email': user.email, // Save the email from FirebaseAuth
          'phone': phone,
          'description': description,
        });

        print('User profile saved successfully.');
      }
    } catch (e) {
      print('Error saving user profile: $e');
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (snapshot.exists) {
          setState(() {
            name = snapshot.data()?['name'] ?? 'Name not available';
            email = user.email;
            phone = snapshot.data()?['phone'] ?? 'Phone not available';
            description =
                snapshot.data()?['description'] ?? 'No description provided';
          });
        } else {
          print('User profile not found. Please complete your profile.');
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _Background(),
            _ProfileInfo(
              name: name ?? 'Loading...',
              email: email ?? 'Loading...',
              phone: phone ?? 'Loading...',
              description: description ?? 'Loading...',
              onSaveProfile: (name, phone, description) {
                _saveUserProfile(
                  name: name,
                  phone: phone,
                  description: description,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String description;
  final void Function(String, String, String) onSaveProfile;

  const _ProfileInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.onSaveProfile,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController phoneController =
        TextEditingController(text: phone);
    final TextEditingController descriptionController =
        TextEditingController(text: description);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ProfileImage(),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onSaveProfile(
                nameController.text,
                phoneController.text,
                descriptionController.text,
              );
            },
            child: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/image/profile.jpg',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
