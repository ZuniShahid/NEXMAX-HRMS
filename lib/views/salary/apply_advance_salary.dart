import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nexmax_hrms/controllers/announcement_controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../controllers/advance_salary_controller.dart';

class ApplyAdvanceSalary extends StatefulWidget {
  const ApplyAdvanceSalary({Key? key}) : super(key: key);

  @override
  State<ApplyAdvanceSalary> createState() => _ApplyAdvanceSalaryState();
}

class _ApplyAdvanceSalaryState extends State<ApplyAdvanceSalary> {
  final AdvanceSalaryController _advanceSalaryController =
      Get.find<AdvanceSalaryController>();
  bool _isLeaveDropdownOpen = false;
  List<String> leaveTypes = Get.find<AnnouncementController>()
      .currencyList
      .map((currencyModel) => currencyModel.code)
      .where((code) => code != null) // Filter out null values
      .map((code) => code!) // Convert nullable strings to non-nullable
      .toList();

  late String _selectedLeaveType;
  DateTime? selectedDate;

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _selectedLeaveType = leaveTypes[0];

    super.initState();
  }

  Widget buildDropdownButton(List<String> items, String selectedValue,
      void Function(String?) onChangedCallback, void Function() onTapCallback) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
          onTap: onTapCallback,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  selectedValue,
                  style: const TextStyle(
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.secondary),
            ],
          )),
    );
  }

  Widget buildDropdownMenu(List<String> items, String selectedValue,
      void Function(String?) onChangedCallback, bool isDropdownOpen) {
    return Visibility(
      visible: isDropdownOpen,
      child: Padding(
        padding: const EdgeInsets.only(top: 145),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((String item) {
              return Container(
                color: selectedValue == item
                    ? AppColors.secondary
                    : Colors.transparent,
                child: ListTile(
                  title: Text(
                    item,
                    style: const TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                  onTap: () {
                    onChangedCallback(item);
                    _isLeaveDropdownOpen = false;
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime currentDate = DateTime.now();
    DateTime initialDate = currentDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _onLeaveTypeChanged(String? newValue) {
    setState(() {
      _selectedLeaveType = newValue!;
    });
  }

  void _toggleLeaveDropdown() {
    setState(() {
      _isLeaveDropdownOpen = !_isLeaveDropdownOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          _isLeaveDropdownOpen = false;
          setState(() {});
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Apply Advance',
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
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              'Date',
                              style: CustomTextStyles.bodyTextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.secondary),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedDate != null
                                        ? DateFormat('MM/dd/yyyy')
                                            .format(selectedDate!)
                                        : "",
                                    style: const TextStyle(
                                        color: AppColors.secondary),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: AppColors.secondary,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Currency',
                                      style: CustomTextStyles.bodyTextStyle(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  buildDropdownButton(
                                      leaveTypes,
                                      _selectedLeaveType,
                                      _onLeaveTypeChanged,
                                      _toggleLeaveDropdown),
                                ]),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    'Request Amount',
                                    style: CustomTextStyles.bodyTextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 40.0,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "",
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: AppColors
                                              .secondary, // Secondary color for enabled state
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: AppColors
                                              .secondary, // Secondary color for focused state
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          color: AppColors
                                              .secondary, // Secondary color for error state
                                        ),
                                      ),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16), // Add spacing

                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Reason',
                          style: CustomTextStyles.bodyTextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _reasonController,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: "Max 200 characters",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: AppColors.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: AppColors.secondary,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () async {
                              final date = DateFormat('MM/dd/yyyy')
                                  .format(selectedDate!);
                              final currency = _selectedLeaveType;
                              final amount = _amountController.text;
                              final reason = _reasonController.text;

                              await _advanceSalaryController
                                  .applyForAdvanceSalary(
                                date: date,
                                currency: currency,
                                amount: amount,
                                reason: reason,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: const Text('Submit',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  buildDropdownMenu(leaveTypes, _selectedLeaveType,
                      _onLeaveTypeChanged, _isLeaveDropdownOpen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
