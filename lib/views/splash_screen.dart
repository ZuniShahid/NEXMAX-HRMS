import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/gradeinet_background.dart';
import '../controllers/auth_controller.dart';
import '../preferences/auth_prefrence.dart';
import 'auth_screens/login_screen.dart';
import 'home/bottombar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    bool isLoggedIn = await AuthPrefrence.instance.getUserLoggedIn();

    if (isLoggedIn) {
      Future.delayed(const Duration(milliseconds: 4000), () {
        Get.offAll(() => const BottomBar());
      });
    } else {
      Future.delayed(const Duration(milliseconds: 4000), () {
        Get.offAll(() => const LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your logo here
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              // Your app title here
              const Text(
                'NEXMAX HRMS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
