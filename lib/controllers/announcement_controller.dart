import 'dart:convert';

import 'package:get/get.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/announcement_model.dart';
import '../models/currency_model.dart';
import '../utilities/widgets/custom_dialog.dart';
import 'auth_controller.dart';
import 'base_controller.dart';

class AnnouncementController extends GetxController {
  final BaseController _baseController = BaseController.instance;

  RxList<AnnouncementsModelList> announcementList =
      <AnnouncementsModelList>[].obs;

  RxList<CurrencyModel> currencyList =
      <CurrencyModel>[].obs;

  AuthController authController = Get.find<AuthController>();

  Rx<int> currentPage = 1.obs;
  Rx<int> totalItemCount = 0.obs;
  Rx<int> loadedItemCount = 0.obs;

  Rx<bool> isLoadingInitial =
      true.obs; // Loading indicator for initial data fetch
  Rx<bool> isLoadingNext =
      false.obs; // Loading indicator for loading the next page

  void callApi() {
    fetchingCurrencies();
    currentPage.value = 1; // Reset to the first page
    isLoadingInitial.value = true; // Show initial data loading indicator
    fetchingAnnouncementList();
  }

  Future fetchingAnnouncementList() async {
    await authController.refreshToken();
    var body = {
      'user_id': authController.userData.value.userId.toString(),
      'perPage': '15', // Items per page
      'page': currentPage.value.toString(), // Use the current page
    };

    try {
      var response = await DataApiService.instance.post('/announcements', body);
      if (response == null) return;

      var result = json.decode(response);

      totalItemCount.value = int.parse(result['totalCount'].toString());
      int loadedCount = int.parse(result['loadedCount'].toString());

      if (loadedCount < 0) {
        loadedItemCount.value = 0;
      } else {
        loadedItemCount.value += loadedCount;
      }

      if (loadedItemCount.value < totalItemCount.value) {
        currentPage.value++; // Increment the current page
      }

      if (currentPage.value == 1) {
        announcementList.clear(); // Clear the list when loading initial data
      }

      announcementList.addAll(RxList<AnnouncementsModelList>.from(
        result['sent_announcements'].map((x) => AnnouncementsModelList.fromJson(x))
            .where((newAnnouncement) =>
            announcementList.every((existingAnnouncement) =>
            newAnnouncement.id != existingAnnouncement.id)
        ),
      ));


      isLoadingInitial.value = false; // Hide initial data loading indicator
      isLoadingNext.value = false; // Hide initial data loading indicator
    } catch (error) {
      isLoadingInitial.value = false; // Hide initial data loading indicator
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialogBox.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    }
  }

  void loadNextPage() {
    if (isLoadingNext.value) return;
    if (loadedItemCount.value < totalItemCount.value) {
      isLoadingNext.value = true; // Show loading indicator for next page
      fetchingAnnouncementList();
    }
  }

  Future fetchingCurrencies() async {
    await authController.refreshToken();

    try {
      var response = await DataApiService.instance.get('/currencies');
      if (response == null) return;

      var result = json.decode(response);

      List<Map<String, dynamic>> currenciesData = List.castFrom(result);

      currencyList.value = RxList<CurrencyModel>.from(
        currenciesData.map((currencyMap) => CurrencyModel.fromJson(currencyMap)),
      );

    } catch (error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialogBox.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    }
  }

}
