import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nexmax_hrms/models/payroll_model.dart';

import '../../constants/app_colors.dart';
import '../../constants/circle_image.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../constants/time_date_functions.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class PaySlipDetailPage extends StatefulWidget {
  const PaySlipDetailPage({super.key, required this.model});

  final PaySlipModelList model;

  @override
  State<PaySlipDetailPage> createState() => _PaySlipDetailPageState();
}

class _PaySlipDetailPageState extends State<PaySlipDetailPage> {
  final ScrollController _customController = ScrollController();
  late PaySlipModelList _model;
  final UserModel _userData = Get.find<AuthController>().userData.value;
  final _textStyle = const TextStyle(
    fontSize: 10,
    color: AppColors.primary,
  );

  @override
  void initState() {
    // TODO: implement initState
    _model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            ''.toUpperCase(),
            style: const TextStyle(color: Colors.white),
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
          actions: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.download_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.print,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleImage(imageUrl: _model.user!.photo!),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData.fullName!,
                            style: CustomTextStyles.bodyTextStyle(
                                color: AppColors.primary),
                          ),
                          Text(
                            TimeDateFunctions.dateTimeInDigits(
                                _model.createdAt!),
                            style: CustomTextStyles.captionTextStyle(
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: AppColors.secondary,
                  thickness: 2.0,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salary Slip',
                      style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        Container(
                          color: Colors.grey.withOpacity(0.2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Short Name:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(_userData.shortName!,
                                    style: _textStyle),
                              ),
                              Expanded(
                                child: Text('Month:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(_model.month!, style: _textStyle),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Full Name:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(_userData.fullName!,
                                    style: _textStyle),
                              ),
                              Expanded(
                                child: Text('First Date:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('dd-MMM-yyyy')
                                      .format(_model.firstDate!),
                                  style: _textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey.withOpacity(0.2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Position:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(
                                    _userData.employementData!.positionGrade!,
                                    style: _textStyle),
                              ),
                              Expanded(
                                child: Text('Last Date:', style: _textStyle),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('dd-MMM-yyyy')
                                      .format(_model.lastDate!),
                                  style: _textStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))),
                            child: const Center(
                                child: Text(
                              'Income',
                              style: TextStyle(color: AppColors.secondary),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                buildRow(
                                  title: 'Basic Salary',
                                  firstBox: _model.currency,
                                  secondBox: _model.basicSalary!,
                                ),
                                buildRow(
                                  title: 'Over Time',
                                  firstBox: _model.overTimeRemark,
                                  secondBox: _model.overTime!,
                                ),
                                buildRow(
                                  title: 'Rest Day Over Time',
                                  firstBox: _model.restDayRemark,
                                  secondBox: _model.restDayOverTime!,
                                ),
                                buildRow(
                                  title: 'New Year Over Time',
                                  firstBox: _model.newYearRemark,
                                  secondBox: _model.newYearRemark!,
                                ),
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Allowance',
                                    style:
                                        TextStyle(color: AppColors.secondary),
                                  ),
                                ),
                                buildRow(
                                  title: 'Food Allowance',
                                  firstBox: _model.newYearRemark,
                                  secondBox: _model.foodAllowance!,
                                  isFirstBox: false,
                                ),
                                buildRow(
                                  title: 'Night Shift',
                                  firstBox: _model.newYearRemark,
                                  secondBox: _model.nightShift!,
                                  isFirstBox: false,
                                ),
                                buildRow(
                                  title: 'Insurance',
                                  firstBox: _model.newYearRemark,
                                  secondBox: _model.insurance!,
                                  isFirstBox: false,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Income',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                                Text(
                                  _model.totalIncome!,
                                  style:
                                      const TextStyle(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2))),
                            child: const Center(
                                child: Text(
                              'Deduction',
                              style: TextStyle(color: AppColors.secondary),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                buildRow(
                                  title: 'Hold Basic Salary',
                                  firstBox: _model.holdBasicSalaryRemark,
                                  secondBox: _model.holdBasicSalary!,
                                ),
                                buildRow(
                                  title: 'Unpaid Leave',
                                  firstBox: _model.unpaidLeaveRemark,
                                  secondBox: _model.unpaidLeave!,
                                ),
                                buildRow(
                                  title: 'Mistake',
                                  firstBox: _model.mistakeRemark,
                                  secondBox: _model.mistake!,
                                ),
                                buildRow(
                                  title: 'Penalty',
                                  firstBox: _model.penaltyRemark,
                                  secondBox: _model.penalty!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow({
    required String title,
    String? firstBox,
    required String secondBox,
    bool isFirstBox = true,
  }) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                title,
                style: CustomTextStyles.captionTextStyle(
                  color: AppColors.primary,
                ),
              ),
            ),
            Row(
              children: [
                isFirstBox
                    ? Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondary),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              firstBox!,
                              style: CustomTextStyles.captionTextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 5),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.secondary),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        secondBox,
                        style: CustomTextStyles.captionTextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  SizedBox pageSizedBox() => const SizedBox(height: 20);
}
