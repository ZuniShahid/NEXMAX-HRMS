import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/no_data_widget.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../controllers/payslip_controller.dart';
import '../../models/payroll_model.dart';
import '../../utilities/shimmer.dart';
import 'pay_slip_detail.dart';

class PaySlipPage extends StatefulWidget {
  const PaySlipPage({super.key});

  @override
  State<PaySlipPage> createState() => _PaySlipPageState();
}

class _PaySlipPageState extends State<PaySlipPage> {
  int primaryPercent = 7;
  int secondaryPercentage = 3;
  int selectedYear = DateTime.now().year;
  List<int> years =
      List.generate(20, (int index) => DateTime.now().year - index);

  final ScrollController _customController = ScrollController();
  final PaySlipController _paySlipController = Get.put(PaySlipController());

  @override
  void initState() {
    _paySlipController.callApi();
    _paySlipController.selectedYear.value = selectedYear;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Pay Slip',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () {
          PaySlipModelList? filteredPaySlip =
              _paySlipController.getFilteredPaySlip();

          return Container(
            // padding: const EdgeInsets.all(16),
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          width: 100.w,
                          height: 190,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'January 2023',
                                    style: CustomTextStyles.titleStyle(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              ListTile(
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  'Hold Basic Salary',
                                  style: CustomTextStyles.bodyTextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    filteredPaySlip == null
                                        ? ""
                                        : filteredPaySlip.basicSalary! ?? '',
                                    style: CustomTextStyles.bodyTextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              ListTile(
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  'Hold Bonus',
                                  style: CustomTextStyles.bodyTextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    filteredPaySlip == null
                                        ? ""
                                        : filteredPaySlip.kpiBonus! ?? '',
                                    style: CustomTextStyles.bodyTextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              ListTile(
                                visualDensity: VisualDensity.compact,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  'Hold Leader Bonus',
                                  style: CustomTextStyles.bodyTextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'USD 500.0',
                                    style: CustomTextStyles.bodyTextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: AppColors.secondary,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'History',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Select Year',
                                style: CustomTextStyles.bodyTextStyle(
                                    color: AppColors.primaryDull),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  border: Border.all(
                                    color: AppColors.secondary,
                                  ),
                                ),
                                child: DropdownButton<int>(
                                  isDense: true,
                                  menuMaxHeight: 200.0,
                                  value: selectedYear,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedYear = newValue!;
                                      _paySlipController.selectedYear.value =
                                          selectedYear;
                                      _paySlipController.callApi();
                                    });
                                  },
                                  items: years.map((int year) {
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                  underline: Container(height: 0),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.secondary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (_paySlipController.isLoading.value &&
                        _paySlipController.paySlipList.isEmpty) {
                      return const ShimmerAnnouncementCard();
                    }
                    else if (!_paySlipController
                        .isLoading.value &&
                        _paySlipController
                            .paySlipList.isEmpty) {
                      return const SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: NoDataWidget());
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: DraggableScrollbar(
                        controller: _customController,
                        alwaysVisibleScrollThumb: true,
                        heightScrollThumb: 90.0,
                        backgroundColor: Colors.yellow,
                        scrollThumbBuilder: (
                          Color backgroundColor,
                          Animation<double> thumbAnimation,
                          Animation<double> labelAnimation,
                          double height, {
                          Text? labelText,
                          BoxConstraints? labelConstraints,
                        }) {
                          const alwaysVisibleThumbAnimation =
                              AlwaysStoppedAnimation(1.0);

                          return FadeTransition(
                            opacity: alwaysVisibleThumbAnimation,
                            child: GradientBackground(
                                child: SizedBox(
                              width: 3,
                              height: height,
                            )),
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          controller: _customController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _paySlipController.filteredPaySlips.length,
                          itemBuilder: (BuildContext context, int index) {
                            var model =
                                _paySlipController.filteredPaySlips[index];
                            return GestureDetector(
                              onTap: () {
                                Go.to(() => PaySlipDetailPage(
                                      model: model,
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                child: PaySlipTimeLine(
                                  amount: _paySlipController
                                      .filteredPaySlips[index].basicSalary!,
                                  startDate: DateFormat('dd-MMM-yyyy').format(
                                      _paySlipController
                                          .filteredPaySlips[index].firstDate!),
                                  endDate: DateFormat('dd-MMM-yyyy').format(
                                      _paySlipController
                                          .filteredPaySlips[index].lastDate!),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaySlipTimeLine extends StatelessWidget {
  const PaySlipTimeLine({
    super.key,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  final String amount;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.secondary,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        tileColor: Colors.transparent,
        dense: true,
        visualDensity: VisualDensity.compact,
        minVerticalPadding: 0,
        title: Text(
          amount,
          style: CustomTextStyles.titleStyle(color: AppColors.secondary),
        ),
        subtitle: Text(
          '$startDate to $endDate',
          style: CustomTextStyles.bodyTextStyle(
              color: AppColors.primary, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
