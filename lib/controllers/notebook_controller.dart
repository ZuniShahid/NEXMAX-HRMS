import 'dart:convert';

import 'package:get/get.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/notebook_list_model.dart';
import '../utilities/widgets/custom_dialog.dart';
import 'auth_controller.dart';
import 'base_controller.dart';

class NotebookController extends GetxController {
  final BaseController _baseController = BaseController.instance;

  RxList<NotebooksListModel> notebookList = <NotebooksListModel>[].obs;
  RxString searchQuery = ''.obs;
  int currentPage = 1; // Current page for pagination
  int totalItemCount = 0; // Total count from the response
  int loadedItemCount = 0; // Loaded count from the response
  int selectedYear = DateTime.now().year; // Selected year for the dropdown
  RxBool isLoading = false.obs; // Loading indicator

  AuthController authController = Get.find<AuthController>();

  void callApi() {
    currentPage = 1; // Reset to the first page
    notebookList.clear(); // Clear the list when loading initial data
    isLoading.value = true; // Show loading indicator
    fetchingNotebookList();
  }

  /*<---------------------Fetch NoteBook List--------------------->*/

  Future fetchingNotebookList() async {
    await authController.refreshToken();
    var body = {
      'perPage': '15', // Items per page
      'page': currentPage.toString(), // Use the current page
      'sort_by': '',
      'sort_order': '',
      'year': selectedYear.toString(), // Include the selected year
      'user_id': authController.userData.value.userId.toString(),
    };

    try {
      var response = await DataApiService.instance.post('/notebooks', body);
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
        currentPage++; // Increment the current page
      }

      notebookList.addAll(RxList<NotebooksListModel>.from(
        result['data'].map((x) => NotebooksListModel.fromJson(x)).where(
            (newAnnouncement) => notebookList.every((existingAnnouncement) =>
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
      fetchingNotebookList();
    }
  }

  void searchNotebooks(String query) {
    searchQuery.value = query;
  }

  RxList<NotebooksListModel> get filteredNotebooks {
    return RxList<NotebooksListModel>.from(notebookList.where((notebook) {
      final title = (notebook.title ?? '').toLowerCase();
      final description = (notebook.message ?? '').toLowerCase();
      final query = searchQuery.value.toLowerCase();

      final createdAt = (notebook.createdAt ?? '').toString();
      final year =
          int.tryParse(createdAt.split('-')[0]) ?? 0; // Extract the year

      return (title.contains(query) || description.contains(query)) &&
          year == selectedYear;
    }));
  }
}
