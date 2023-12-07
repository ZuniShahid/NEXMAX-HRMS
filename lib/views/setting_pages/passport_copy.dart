import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/gradeinet_background.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class PassportCopy extends StatefulWidget {
  const PassportCopy({super.key});

  @override
  State<PassportCopy> createState() => _PassportCopyState();
}

class _PassportCopyState extends State<PassportCopy> {
  final UserModel _userData = Get.find<AuthController>().userData.value;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Passport Copy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Image.network(
              _userData.passportCopy!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
