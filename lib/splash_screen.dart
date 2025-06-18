import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart'; // sesuai dengan struktur folder kamu
//import '../core/constant/color.dart'; // sesuaikan jika kamu pakai AppColor

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // atau pakai Colors.black jika belum punya AppColor
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/Lottie/Animation - 1750233356347.json', // pastikan path ini sesuai
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            
          ],
        ),
      ),
    );
  }
}
