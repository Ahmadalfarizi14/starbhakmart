import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState(); 

    // Timer untuk pindah ke FoodDeliveryScreen setelah beberapa detik
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodDeliveryScreen()),
      );
    });

    // Menginisialisasi controller dan animasi untuk animasi fade-in
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), 
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); 
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: FadeTransition(
          opacity: _animation, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.jpg',
                width: 350, 
                height: 400,
              ),
              SizedBox(height: 10), 
              Text(
                'Starbhakmart',
                style: TextStyle(
                  fontSize: 45, 
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 55, 54, 71),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
