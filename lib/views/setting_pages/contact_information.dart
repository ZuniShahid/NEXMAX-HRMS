import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexmax_hrms/controllers/auth_controller.dart';

import '../../constants/gradeinet_background.dart';
import '../../models/user_model.dart';
import 'components/setting_list_tile.dart';

class ContactInformation extends StatefulWidget {
  const ContactInformation({super.key});

  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final UserModel _userData = Get.find<AuthController>().userData.value;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Contact Information',
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
              SettingListTile(text: 'Mobile Number', trailing: _userData.contactData!.mobileNumber),
              SettingListTile(
                  text: 'Address', trailing: _userData.contactData!.address),
              const SizedBox(height: 20),
              SettingListTile(
                  text: 'Email', trailing: _userData.contactData!.email),
            ],
          ),
        ),
      ),
    );
  }
}
