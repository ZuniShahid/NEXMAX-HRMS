import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/text_style.dart';

class SettingListTile extends StatelessWidget {
  const SettingListTile({
    super.key,
    required this.text,
    required this.trailing,
  });

  final String? text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Grey border color
          width: 0.3,
        ),
      ),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          text!,
          style: CustomTextStyles.bodyTextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: SizedBox(
          width: 120,
          child: Text(
            trailing!,
            textAlign: TextAlign.start,
            style: CustomTextStyles.bodyTextStyle(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
