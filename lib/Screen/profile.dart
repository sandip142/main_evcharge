import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _Background(),
            _ProfileInfo(),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _ProfileImage(),
          const SizedBox(height: 20),
          _ProfileDetails(),
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
        'assets/image/profile.jpg', // Replace with profile image URL
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'John Doe', // Replace with profile name
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'johndoe@example.com', // Replace with profile email
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          '+1 123 456 7890', // Replace with profile phone number
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          'This is a description about John Doe.', // Replace with profile description
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ProfilScreenState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          AnimatedOpacity(
            opacity: _animation.value,
            duration: const Duration(milliseconds: 500),
            child: _ProfileInfo(),
          ),
        ],
      ),
    );
  }
}


// class _ProfileImages extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.blue,
//       ),
//       child: const Center(
//         child: Text(
//           'JD', // Replace with logo text
//           style: TextStyle(fontSize: 40, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }


