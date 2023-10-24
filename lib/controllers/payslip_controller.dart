import 'dart:convert';
import 'package:get/get.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/payroll_model.dart';
import '../utilities/widgets/custom_dialog.dart';
import 'auth_controller.dart';
import 'base_controller.dart';

class PaySlipController extends GetxController {
  final BaseController _baseController = BaseController.instance;

  RxList<PaySlipModelList> totalPaySlipList = <PaySlipModelList>[].obs;
  RxList<PaySlipModelList> paySlipList = <PaySlipModelList>[].obs;

  Rx<String> selectedValue = 'All'.obs;

  AuthController authController = Get.find<AuthController>();

  Rx<int> selectedYear = DateTime.now().year.obs;

  RxBool isLoading = false.obs; // Loading indicator for fetching data

  void callApi() {
    fetchingPaySlipList();
  }

  /*<---------------------Fetch Pay Slip List--------------------->*/

  Future fetchingPaySlipList() async {
    try {
      isLoading.value = true; // Show loading indicator
      await authController.refreshToken();

      var body = {
        'user_id': authController.userData.value.userId.toString(),
        'year': selectedYear.value.toString(),
      };
      print(body);
      var response = await DataApiService.instance
          .post('/payrolls', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialogBox.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      if (response == null) return;

      var result = json.decode(response);
      print(result);

      paySlipList.value = RxList<PaySlipModelList>.from(
          result['data'].map((x) => PaySlipModelList.fromJson(x)));
      totalPaySlipList.value = RxList<PaySlipModelList>.from(
          result['data'].map((x) => PaySlipModelList.fromJson(x)));

    } catch (error) {
      if (error is Exception) {
        // Handle exceptions
      }
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  RxList<PaySlipModelList> get filteredPaySlips {
    return RxList<PaySlipModelList>.from(
      paySlipList.where((paySlip) {
        if (paySlip.createdAt == null) return false;
        final year = paySlip.createdAt?.year;
        return year == selectedYear.value;
      }),
    );
  }

  PaySlipModelList? getFilteredPaySlip() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    final filteredPaySlips = paySlipList.where((paySlip) {
      if (paySlip.createdAt == null) return false;
      final year = paySlip.createdAt!.year!;
      final month = paySlip.createdAt!.month!;

      // Filter pay slips for the current year and month
      return year == currentYear && month == currentMonth;
    }).toList();

    if (filteredPaySlips.isEmpty) {
      return null; // Return null if no matching pay slip is found
    }

    return filteredPaySlips[0]; // Return the first matching pay slip
  }
}
