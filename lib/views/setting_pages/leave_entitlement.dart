import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import 'components/setting_list_tile.dart';

class LeaveEntitlement extends StatefulWidget {
  const LeaveEntitlement({super.key});

  @override
  State<LeaveEntitlement> createState() => _LeaveEntitlementState();
}

class _LeaveEntitlementState extends State<LeaveEntitlement> {
  final LeaveData _leaveData =
  Get.find<AuthController>().userData.value.leaveData!;
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Leave Entitlement',
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
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),
                  child: Text(
                    'Leave',
                    style: CustomTextStyles.bodyTextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
               SettingListTile(text: 'Rest Day', trailing: _leaveData.restDay),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 2),
                  child: Text(
                    'Allowance',
                    style: CustomTextStyles.bodyTextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
               SettingListTile(text: 'Meals', trailing:"${_leaveData.mealsAllowanceCurrency!} ${_leaveData.mealsAllowance!}"),
               SettingListTile(text: 'Flight', trailing:"${_leaveData.flightAllowanceCurrency!} ${_leaveData.flightAllowance!}"),
               SettingListTile(text: 'Medical', trailing: "${_leaveData.medicalAllowanceCurrency!} ${_leaveData.medicalAllowance!}"),
            ],
          ),
        ),
      ),
    );
  }
}


