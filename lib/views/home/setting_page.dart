import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/assets.dart';
import '../../constants/circle_image.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../auth_screens/login_screen.dart';
import '../setting_pages/contact_information.dart';
import '../setting_pages/corporate_information.dart';
import '../setting_pages/emergency_contact.dart';
import '../setting_pages/finance_information.dart';
import '../setting_pages/leave_entitlement.dart';
import '../setting_pages/personal_information.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final UserModel _userData = Get.find<AuthController>().userData.value;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        body: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.purpleBackground,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SizedBox(
                height: 20.h,
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        leading:  CircleImage(
                          imageUrl:_userData.profilePicture!,
                          placeHolderColor: AppColors.secondary,
                        ),
                        title: Text(
                          _userData.fullName!,
                          style: CustomTextStyles.bodyTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _userData.shortName!,
                          style: CustomTextStyles.bodyTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppColors.secondary,
              height: 2,
              thickness: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      listTile(
                          text: 'Personal Information',
                          onTap: () {
                            Go.to(() => const PersonalInformationScreen());
                          }),
                      listTile(
                          text: 'Contact Information',
                          onTap: () {
                            Go.to(() => const ContactInformation());
                          }),
                      const SizedBox(height: 20),
                      listTile(
                          text: 'Emergency Contact',
                          onTap: () {
                            Go.to(() => const EmergencyContact());
                          }),
                      listTile(
                          text: 'Coroportaion Information',
                          onTap: () {
                            Go.to(() => const CorporateInformation());
                          }),
                      const SizedBox(height: 20),
                      listTile(
                          text: 'Finance Information',
                          onTap: () {
                            Go.to(() => const FinanceInformation());
                          }),
                      listTile(
                          text: 'Leave and Allownace Entitlement',
                          onTap: () {
                            Go.to(() => const LeaveEntitlement());
                          }),
                      const SizedBox(height: 50),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 0.3,
                          ),
                        ),
                        child: ListTile(
                          tileColor: Colors.white,
                          onTap: () {
                            Get.find<AuthController>().signOut();
                            Get.off(const LoginScreen());
                          },
                          title: const Center(child: Text('Logout')),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 0.3,
                          ),
                        ),
                        child: ListTile(
                          tileColor: Colors.white,
                          onTap: () {
                           Get.back();
                          },
                          title: const Center(child: Text('Go Back')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container listTile({String? text, void Function()? onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Grey border color
          width: 0.3,
        ),
      ),
      child: ListTile(
        tileColor: Colors.white,
        onTap: onTap,
        title: Text(
          text!,
          style: CustomTextStyles.bodyTextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
