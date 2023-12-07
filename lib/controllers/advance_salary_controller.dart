import 'dart:convert';

import 'package:get/get.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/advance_salary_model.dart';
import '../utilities/widgets/custom_dialog.dart';
import 'auth_controller.dart';
import 'base_controller.dart';

class AdvanceSalaryController extends GetxController {
  final BaseController _baseController = BaseController.instance;

  RxList<AdvanceSalaryModel> advanceSalaryList = <AdvanceSalaryModel>[].obs;
  int currentPage = 1;
  int totalItemCount = 0;
  int loadedItemCount = 0;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  AuthController authController = Get.find<AuthController>();

  RxBool isLoading = false.obs; // Loading indicator for fetching data

  void callApi() {
    currentPage = 1;
    isLoading.value = true; // Show loading indicator
    fetchingAdvanceSalaryList();
  }

  Future fetchingAdvanceSalaryList() async {
    try {
      await authController.refreshToken();
      var body = {
        'user_id': authController.userData.value.userId.toString(),
        'perPage': '15',
        'page': currentPage.toString(),
        'filter_year': selectedYear.toString(),
      };

      var response =
          await DataApiService.instance.post('/salary-advances', body);

      if (response == null) return;

      var result = json.decode(response);
      totalItemCount = int.parse(result['totalCount'].toString());
      int loadedCount = int.parse(result['loadedCount'].toString());

      if (loadedCount < 0) {
        loadedItemCount = 0;
      } else {
        loadedItemCount += loadedCount;
      }

      if (loadedItemCount < totalItemCount) {
        currentPage++;
      }

      advanceSalaryList.addAll(
        RxList<AdvanceSalaryModel>.from(
          result['data'].map((x) => AdvanceSalaryModel.fromJson(x)).where(
                (newAdvanceSalary) => advanceSalaryList.every(
                    (existingAdvanceSalary) =>
                        newAdvanceSalary.id != existingAdvanceSalary.id),
              ),
        ),
      );
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
      fetchingAdvanceSalaryList();
    }
  }

  void setSelectedYear(int year) {
    selectedYear = year;
    callApi();
  }

  void setSelectedMonth(int month) {
    selectedMonth = month;
    callApi();
  }

  RxList<AdvanceSalaryModel> get filteredAdvanceSalaries {
    return RxList<AdvanceSalaryModel>.from(
      advanceSalaryList.where((salary) {
        if (salary.createdAt == null) return false;
        final year = salary.createdAt?.year;
        return year == selectedYear;
      }),
    );
  }

  Future applyForAdvanceSalary({
    required String date,
    required String currency,
    required String amount,
    required String reason,
  }) async {
    try {
      await authController.refreshToken();

      var body = {
        'user_id': authController.userData.value.userId.toString(),
        'date': date,
        'currency': currency,
        'amount': amount,
        'reason': reason,
      };

      var response =
          await DataApiService.instance.post('/salary-advances-create', body);
      if (response == null) return;

      var result = json.decode(response);
      final errors = result['errors'];
      final status = result['status'];

      if (status == 'success') {
        CustomDialogBox.showSuccessDialog(description: status);
      } else {
        final errorMessages = errors.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .join('\n ');

        CustomDialogBox.showErrorDialog(description: '$errorMessages');
      }
    } catch (error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialogBox.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    }
  }

  MapEntry<String, double> calculateTotalSalaryAndCurrencyForCurrentMonth() {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    double totalSalary = 0;
    String currency = 'USD'; // Initialize with an empty string

    for (var salary in advanceSalaryList) {
      if (salary.createdAt != null &&
          salary.createdAt!.year == currentYear &&
          salary.createdAt!.month == currentMonth) {
        // Assuming 'amount' is a String, you may need to parse it to double if necessary
        totalSalary += double.tryParse(salary.amount ?? '0.0') ?? 0.0;
        currency = salary.currency ?? ''; // Update the currency
      }
    }

    return MapEntry(currency, totalSalary);
  }
}
