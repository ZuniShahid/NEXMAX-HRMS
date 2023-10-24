import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexmax_hrms/constants/time_date_functions.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import 'components/setting_list_tile.dart';

class CorporateInformation extends StatefulWidget {
  const CorporateInformation({super.key});

  @override
  State<CorporateInformation> createState() => _CorporateInformationState();
}

class _CorporateInformationState extends State<CorporateInformation> {
  final EmployementData _employementData = Get.find<AuthController>().userData.value.employementData!;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Corporate Information',
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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
               SettingListTile(text: 'Position', trailing: _employementData.positionGrade),
              const SizedBox(height: 20),
               SettingListTile(text: 'Report To', trailing: _employementData.reportTo.toString()),
               SettingListTile(text: 'Work Location', trailing: _employementData.workLocation),
              const SizedBox(height: 20),
               SettingListTile(text: 'Job Type', trailing: _employementData.jobType),
               SettingListTile(text: 'Start Date', trailing: TimeDateFunctions.dateTimeInDigitsWithForwardDash(_employementData.dateJoined!)),
               SettingListTile(text: 'End Date', trailing: TimeDateFunctions.dateTimeInDigitsWithForwardDash(_employementData.jobTypeEnd)),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),
                  child: Text(
                    'Referral',
                    style: CustomTextStyles.bodyTextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
               SettingListTile(text: 'Name', trailing: _employementData.referralName),
               SettingListTile(
                  text: 'Contact Number', trailing: _employementData.referralContact),
            ],
          ),
        ),
      ),
    );
  }
}
