import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexmax_hrms/models/leaves_list_model.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/no_data_widget.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../constants/time_date_functions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/leaves_controller.dart';
import '../../models/user_model.dart';
import '../../utilities/shimmer.dart';
import 'leave_application_page.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {

  final LeaveController _leaveController = Get.put(LeaveController());
  List<int> years =
      List.generate(20, (int index) => DateTime.now().year - index);
  final ScrollController _customController = ScrollController();
  int primaryPercent = 7;
  int secondaryPercentage = 3;

  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    _leaveController.callApi();
    _leaveController.selectedYear.value = selectedYear;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Leaves'.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Go.to(() => const LeaveApplicationScreen());
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
      body: Obx(
        () => Container(
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
                    Text(
                      'Rest Days',
                      style: CustomTextStyles.bodyTextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _cardWidget(
                            heading: 'Total',
                            number: _leaveController.totalExpectDay.value),
                        _cardWidget(
                            heading: 'Taken',
                            number: _leaveController.totalRestDays.value),
                        _cardWidget(
                            heading: 'Balance',
                            number: _leaveController.totalBalance.value),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 4.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Row(
                          children: [
                            Expanded(
                              flex: primaryPercent, // 70% blue
                              child: Container(
                                color: AppColors.primary,
                              ),
                            ),
                            Container(
                              width: 4.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: secondaryPercentage,
                              child: Container(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Select Year',
                          style: CustomTextStyles.bodyTextStyle(
                              color: AppColors.primaryDull),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                _leaveController.selectedYear.value =
                                    selectedYear;
                                _leaveController.callApi();
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
                      _leaveController.loadNextPage();
                    }
                    return false;
                  },
                  child: Obx(
                    () {
                      if (_leaveController.isLoading.value &&
                          _leaveController.filteredLeaves.isEmpty) {
                        return const ShimmerAnnouncementCard();
                      } else if (!_leaveController.isLoading.value &&
                          _leaveController.filteredLeaves.isEmpty) {
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
                            itemCount: _leaveController.filteredLeaves.length,
                            itemBuilder: (BuildContext context, int index) {
                              LeaveListModel model =
                                  _leaveController.filteredLeaves[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: LeaveTimeLine(
                                  title: model.leaveType!,
                                  titleDate: '',
                                  durationDays: '1',
                                  startDate: model.fromTime!,
                                  endDate: model.toTime!,
                                  reason: model.reason!,
                                  status: model.status!,
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
      ),
    );
  }

  Widget _cardWidget({required String heading, required String number}) {
    return Expanded(
      child: Card(
        color: AppColors.primaryHintColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: CustomTextStyles.bodyTextStyle(
                      color: AppColors.secondary),
                ),
                Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LeaveTimeLine extends StatelessWidget {
  final String title;
  final String titleDate;
  final String durationDays;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  const LeaveTimeLine({
    super.key,
    required this.title,
    required this.titleDate,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

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
                    'Annual Leave',
                    style: CustomTextStyles.captionTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          'Duration',
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
                          '$durationDays Day(S)',
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
                          'Start date',
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
                          startDate,
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
                          'End date',
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
                          endDate,
                          style: CustomTextStyles.captionTextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: 25,
                      ),
                      Container(),
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
