import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/no_data_widget.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../constants/time_date_functions.dart';
import '../../controllers/advance_salary_controller.dart';
import '../../utilities/shimmer.dart';
import 'apply_advance_salary.dart';

class AdvanceSalaryPage extends StatefulWidget {
  const AdvanceSalaryPage({super.key});

  @override
  State<AdvanceSalaryPage> createState() => _AdvanceSalaryPageState();
}

class _AdvanceSalaryPageState extends State<AdvanceSalaryPage> {
  int primaryPerecent = 7;
  int secondaryPercentage = 3;
  int selectedYear = DateTime.now().year;
  List<int> years =
      List.generate(20, (int index) => DateTime.now().year - index);

  final ScrollController _customController = ScrollController();
  final AdvanceSalaryController _advanceSalaryController =
      Get.put(AdvanceSalaryController());

  @override
  void initState() {
    // TODO: implement initState
    _advanceSalaryController.callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Salary Advance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Go.to(() => const ApplyAdvanceSalary());
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
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
                      height: 170,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Salary Advance',
                            style: CustomTextStyles.titleStyle(
                                color: Colors.white),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'USD 500.0',
                              style: CustomTextStyles.bodyTextStyle(
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'January 2023',
                                style: CustomTextStyles.bodyTextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 130,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    'Current Date on ${TimeDateFunctions.dateInDigits(TimeDateFunctions.timestamp)}',
                                    style: CustomTextStyles.bodyTextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  _advanceSalaryController.selectedYear =
                                      selectedYear;
                                  _advanceSalaryController.callApi();
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
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    // Reached the end of the list, load the next page
                    _advanceSalaryController.loadNextPage();
                  }
                  return false;
                },
                child: Obx(
                  () {
                    if (_advanceSalaryController.isLoading.value &&
                        _advanceSalaryController
                            .filteredAdvanceSalaries.isEmpty) {
                      return const ShimmerAnnouncementCard();
                    } else if (!_advanceSalaryController.isLoading.value &&
                        _advanceSalaryController
                            .filteredAdvanceSalaries.isEmpty) {
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
                          itemCount: _advanceSalaryController
                              .filteredAdvanceSalaries.length,
                          itemBuilder: (BuildContext context, int index) {
                            var model = _advanceSalaryController
                                .filteredAdvanceSalaries[index];
                            String? amount = model.amount;
                            String? reason = model.reason;
                            String? status = model.status;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SalaryTimeLine(
                                amount: amount!,
                                reason: reason!,
                                status: status!,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalaryTimeLine extends StatelessWidget {
  const SalaryTimeLine({
    super.key,
    required this.amount,
    required this.reason,
    required this.status,
  });

  final String amount;
  final String status;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: status.contains('Pending')
                ? Colors.yellow
                : status.contains('Approved')
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        child: Column(
          children: [
            Container(
              color: status.contains('Pending')
                  ? Colors.yellow
                  : status.contains('Approved')
                      ? Colors.green
                      : Colors.red,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${TimeDateFunctions.formatIntValueToDateWitOutDay(TimeDateFunctions.timestamp)}',
                    style: CustomTextStyles.captionTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.cancel,
                      color: status.contains('rejected')
                          ? Colors.red
                          : Colors.transparent,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Amount',
                          style: CustomTextStyles.captionTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          ':',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$amount USD',
                          style: CustomTextStyles.captionTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 25,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Reason',
                          style: CustomTextStyles.captionTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          ':',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          reason,
                          style: CustomTextStyles.captionTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 25,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      status.contains('Pending')
                          ? 'in process'
                          : status.contains('Approved')
                              ? 'approved'
                              : 'rejected',
                      style: CustomTextStyles.captionTextStyle(
                        color: status.contains('Pending')
                            ? Colors.yellow
                            : status.contains('Approved')
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
