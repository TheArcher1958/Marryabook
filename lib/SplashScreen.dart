import 'package:flutter/material.dart';
import 'package:marryabook/global.dart';
import 'package:marryabook/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home');
    });

    return Container(
      color: Colors.indigoAccent,
      child: const Center(child: Icon(Icons.compass_calibration_outlined, color: Colors.white,)),
    );
  }
}
