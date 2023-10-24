import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/gradeinet_background.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import 'components/setting_list_tile.dart';

class FinanceInformation extends StatefulWidget {
  const FinanceInformation({super.key});

  @override
  State<FinanceInformation> createState() => _FinanceInformationState();
}

class _FinanceInformationState extends State<FinanceInformation> {
  final FinanceData _financeData =
      Get.find<AuthController>().userData.value.financeData!;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Finance Information',
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
              SettingListTile(
                  text: 'Base Currency', trailing: _financeData.currency),
              SettingListTile(text: 'Bank', trailing: _financeData.bank),
              SettingListTile(
                  text: 'Account Number', trailing: _financeData.accountNumber),
              const SizedBox(height: 20),
              SettingListTile(
                  text: 'Basic Salary', trailing: _financeData.basicSalary),
            ],
          ),
        ),
      ),
    );
  }
}
