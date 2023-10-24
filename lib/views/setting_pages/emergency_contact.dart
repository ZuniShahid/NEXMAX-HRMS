import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/gradeinet_background.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import 'components/setting_list_tile.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});

  @override
  State<EmergencyContact> createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  final UserModel _userData = Get.find<AuthController>().userData.value;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Emergency Contact',
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
          child:  Column(
            children: [
              SettingListTile(text: 'Name', trailing: _userData.contactData!.emergencyPerson),
              SettingListTile(text: 'Mobile Number', trailing: _userData.contactData!.emergencyContact),
             const SizedBox(height: 20),
              SettingListTile(text: 'Relationship', trailing: _userData.contactData!.emergencyRelation),
            ],
          ),
        ),
      ),
    );
  }
}
