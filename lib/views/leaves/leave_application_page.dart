import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nexmax_hrms/controllers/leaves_controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../utilities/widgets/custom_dialog.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({Key? key}) : super(key: key);

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  final LeaveController _leaveController = Get.find<LeaveController>();
  bool isLeaveDropdownOpen = false;
  bool isTimeDropdownOpen = false;
  List<String> leaveTypes = [
    "Drop down selection", // Default value
    "Annual Leave",
    "Unpaid Leave",
    "Rest Day",
    "Emergency Leave",
    "Medical Leave",
  ];

  DateTime? selectedFromDate;
  String selectedLeaveType = "Drop down selection"; // Default value
  String selectedTimeType = "Drop down selection"; // Default value
  DateTime? selectedToDate;
  List<String> timeTypes = [
    "Drop down selection", // Default value
    "Full day",
    "Morning",
    "Evening",
  ];

  final TextEditingController _controller = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
        padding: EdgeInsets.only(top: isLeaveDropdownOpen ? 57 : 205),
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
                    isLeaveDropdownOpen = false;
                    isTimeDropdownOpen = false;
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
        if (isFrom) {
          selectedFromDate = picked;
        } else {
          selectedToDate = picked;
        }
      });
    }
  }

  void _onLeaveTypeChanged(String? newValue) {
    setState(() {
      selectedLeaveType = newValue!;
    });
  }

  void _onTimeTypeChanged(String? newValue) {
    setState(() {
      selectedTimeType = newValue!;
    });
  }

  void _toggleLeaveDropdown() {
    setState(() {
      isLeaveDropdownOpen = !isLeaveDropdownOpen;
      isTimeDropdownOpen = false; // Close the other dropdown
    });
  }

  void _toggleTimeDropdown() {
    setState(() {
      isTimeDropdownOpen = !isTimeDropdownOpen;
      isLeaveDropdownOpen = false; // Close the other dropdown
    });
  }

  Future<void> _onSubmit() async {
    CustomDialogBox.showLoading('Applying for Leave');
    var result = await _leaveController.applyLeave(
      fromTime: selectedFromDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedFromDate!)
          : "",
      toTime: selectedToDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedToDate!)
          : "",
      nationality: 'PK',
      reason: _controller.text,
      leaveType:
          selectedLeaveType == "Drop down selection" ? '' : selectedLeaveType,
      imageFile: _imageFile,
    );
    CustomDialogBox.hideLoading();

    if (result != null) {
      if (result['status'] == 'success') {
        CustomDialogBox.showSuccessDialog(
            description: 'Leave applied successfully');
      } else if (result['status'] == 'error' && result['errors'] != null) {
        var errorMessages = result['errors'];
        String aggregatedErrors = '';

        if (errorMessages.containsKey('from_time')) {
          aggregatedErrors += errorMessages['from_time'] + '\n';
        }
        if (errorMessages.containsKey('to_time')) {
          aggregatedErrors += errorMessages['to_time'] + '\n';
        }
        if (errorMessages.containsKey('reason')) {
          aggregatedErrors += errorMessages['reason'] + '\n';
        }
        if (errorMessages.containsKey('leave_type')) {
          aggregatedErrors += errorMessages['leave_type'] + '\n';
        }

        if (aggregatedErrors.isNotEmpty) {
          CustomDialogBox.showErrorDialog(description: aggregatedErrors);
        }
      } else {
        CustomDialogBox.showErrorDialog(
            description: 'Failed to apply leave. Please try again later.');
      }
    } else {
      CustomDialogBox.showErrorDialog(
          description: 'Failed to apply leave. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: GestureDetector(
        onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          isLeaveDropdownOpen = false;
          isTimeDropdownOpen = false;
          setState(() {});
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              'Apply Leave'.toUpperCase(),
              style: const TextStyle(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Type of',
                          style: CustomTextStyles.bodyTextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      buildDropdownButton(leaveTypes, selectedLeaveType,
                          _onLeaveTypeChanged, _toggleLeaveDropdown),
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
                                    'From',
                                    style: CustomTextStyles.bodyTextStyle(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () => _selectDate(context, true),
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.secondary),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedFromDate != null
                                              ? DateFormat('MM/dd/yyyy')
                                                  .format(selectedFromDate!)
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
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    'To',
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
                                      border: Border.all(
                                          color: AppColors.secondary),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedToDate != null
                                              ? DateFormat('MM/dd/yyyy')
                                                  .format(selectedToDate!)
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
                          ),
                        ],
                      ),

                      const SizedBox(height: 16), // Add spacing
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Leave Period',
                          style: CustomTextStyles.bodyTextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      buildDropdownButton(timeTypes, selectedTimeType,
                          _onTimeTypeChanged, _toggleTimeDropdown),
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
                        controller: _controller,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: "Max 200 characters",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: AppColors.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     SizedBox(width: 8.w),
                      //     Column(
                      //       children: [
                      //         Text(
                      //           'Upload',
                      //           style: CustomTextStyles.bodyTextStyle(
                      //             color: AppColors.primary,
                      //           ),
                      //         ),
                      //         Text(
                      //           'Image',
                      //           style: CustomTextStyles.bodyTextStyle(
                      //             color: AppColors.primary,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     SizedBox(width: 8.w),
                      //     GestureDetector(
                      //       onTap: _pickImage,
                      //       child: Container(
                      //         width: 120.0,
                      //         height: 120.0,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Colors.grey,
                      //             width: 2.0,
                      //           ),
                      //         ),
                      //         child: _imageFile == null
                      //             ? const Center(
                      //                 child: Icon(
                      //                   Icons.photo_library_rounded,
                      //                   size: 70,
                      //                   color: AppColors.primary,
                      //                 ),
                      //               )
                      //             : Image.file(
                      //                 _imageFile!,
                      //                 fit: BoxFit.cover,
                      //               ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: _onSubmit,
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
                  buildDropdownMenu(leaveTypes, selectedLeaveType,
                      _onLeaveTypeChanged, isLeaveDropdownOpen),
                  buildDropdownMenu(timeTypes, selectedTimeType,
                      _onTimeTypeChanged, isTimeDropdownOpen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
