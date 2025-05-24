import 'dart:async';
import 'package:flutter/material.dart';
//import 'onboarding_screen.dart'; // pastikan path-nya benar
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer selama 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // atau warna utama aplikasimu
      body: Center(
        child: Image.asset(
          'assets/images/logo_bantoo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
