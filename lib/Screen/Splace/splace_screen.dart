import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Import Lottie package
import 'package:main_evcharge/Screen/Auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Start the animation and navigate to the next screen after 3 seconds
    _controller.forward();
    Timer(const Duration(seconds: 7), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background fade-in
          FadeTransition(
            opacity: _animation,
            child: Container(
              color: const Color.fromARGB(255, 227, 219, 219),  // Background color
            ),
          ),
          // Lottie animation in the center
          Center(
            child: Lottie.asset(
              'assets/animation/vehicle_station_animation.json', // Path to Lottie JSON file
              width: 400,
              height: 400,
              fit: BoxFit.fill,
            ),
          ),
          // Text at the bottom with animation
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animation,
              child: const Text(
                'Welcome to EV Charging',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 86, 84, 84),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


