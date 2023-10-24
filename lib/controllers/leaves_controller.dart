import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/leaves_list_model.dart';
import '../utilities/widgets/custom_dialog.dart';
import 'auth_controller.dart';
import 'base_controller.dart';

class LeaveController extends GetxController {
  final BaseController _baseController = BaseController.instance;
  AuthController authController = Get.find<AuthController>();

  RxList<LeaveListModel> leaveList = <LeaveListModel>[].obs;
  int currentPage = 1; // Current page for pagination
  int totalItemCount = 0; // Total count from the response
  int loadedItemCount = 0; // Loaded count from the response
  Rx<int> selectedYear = DateTime.now().year.obs; // Use Rx to make it reactive
  RxString totalExpectDay = '0'.obs;
  RxString totalRestDays = '0'.obs;
  RxString totalBalance = '0'.obs;
  RxBool isLoading = false.obs; // Loading indicator

  void callApi() {
    currentPage = 1; // Reset to the first page
    isLoading.value = true; // Show loading indicator
    fetchingLeaveList();
  }

  Future fetchingLeaveList() async {
    await authController.refreshToken();
    await fetchingRestDaysData();
    var body = {
      'user_id': authController.userData.value.userId.toString(),
      'year': selectedYear.value.toString(),
      'perPage': '15', // Items per page
      'page': currentPage.toString(), // Use the current page
    };

    try {
      var response = await DataApiService.instance.post('/leaves', body);
      var result = json.decode(response);
      print("result");
      print(result);

      if (response == null) return;

      totalItemCount = int.parse(result['totalCount'].toString());
      loadedItemCount += int.parse(result['loadedCount'].toString());

      if (loadedItemCount < totalItemCount) {
        currentPage++; // Increment the current page
      }

      leaveList.addAll(RxList<LeaveListModel>.from(
        result['data'].map((x) => LeaveListModel.fromJson(x)).where(
                (newAnnouncement) =>
                leaveList.every((existingAnnouncement) =>
                newAnnouncement.id != existingAnnouncement.id)),
      ));
    } catch (error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialogBox.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  void loadNextPage() {
    if (loadedItemCount < totalItemCount) {
      fetchingLeaveList();
    }
  }

  RxList<LeaveListModel> get filteredLeaves {
    return RxList<LeaveListModel>.from(leaveList.where((leave) {
      final createdAt = leave.createdAt;
      if (createdAt == null) return false;

      final year = createdAt.year;
      return year == selectedYear.value;
    }));
  }


  applyLeave({
    required String fromTime,
    required String toTime,
    required String nationality,
    required String reason,
    required String leaveType,
    File? imageFile,
  }) async {
    await authController.refreshToken();

    final Map<String, dynamic> requestBody = {
      'user_id': authController.userData.value.userId.toString(),
      'from_time': fromTime,
      'to_time': toTime,
      'nationality': nationality,
      'reason': reason,
      'leave_type': leaveType,
    };
    print("requestBody");
    print(requestBody);
    try {
      final response =
          await DataApiService.instance.post('/leaves-create', requestBody);
      if (response != null) {
        var result = json.decode(response);
        return result;

      } else {
        // Show an error message
        CustomDialogBox.showErrorDialog(
            description: 'Failed to apply leave. Please try again later.');
      }
    } catch (error) {
      if (error is BadRequestException) {
        // Handle specific API error if needed
        var apiError = json.decode(error.message!);
        CustomDialogBox.showErrorDialog(description: apiError["reason"]);
      } else {
        // Handle other errors, e.g., network errors
        _baseController.handleError(error);
      }
    }
  }

  Future fetchingRestDaysData() async {
    try {
      var response = await DataApiService.instance.get('/leaves-entitlement');
      if (response == null) return;

      var result = json.decode(response);
      print(result);
      final Map<String, dynamic>? leaveData = result['leaveData'];
      if (leaveData != null) {
        // You can now work with the leaveData
        totalExpectDay.value = leaveData['total_expect_day'];
        totalRestDays.value = leaveData['total_rest_days'].toString();
        totalBalance.value = leaveData['total_balance'].toString();

        // Use these values as needed
      }
    } catch (error) {
      if (error is BadRequestException) {
        print("error");
        print(error);
        var apiError = json.decode(error.message!);
        print("apiError");
        print(apiError);
        CustomDialogBox.showErrorDialog(description: apiError["error"]);
      } else {
        _baseController.handleError(error);
      }
    }
  }
}
