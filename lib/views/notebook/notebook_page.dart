import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_colors.dart';
import '../../constants/circle_image.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/no_data_widget.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../constants/time_date_functions.dart';
import '../../controllers/notebook_controller.dart';
import '../../models/notebook_list_model.dart';
import '../../utilities/shimmer.dart';
import 'notebook_detail_page.dart';

class NoteBookPage extends StatefulWidget {
  const NoteBookPage({super.key});

  @override
  State<NoteBookPage> createState() => _NoteBookPageState();
}

class _NoteBookPageState extends State<NoteBookPage> {
  int selectedYear = DateTime.now().year;
  List<int> years =
      List.generate(20, (int index) => DateTime.now().year - index);

  final ScrollController _customController = ScrollController();
  final NotebookController _notebookController = Get.put(NotebookController());

  @override
  void initState() {
    _notebookController.callApi();
    _notebookController.selectedYear = selectedYear;
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
          'Note Book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                                  _notebookController.selectedYear =
                                      selectedYear;
                                  _notebookController.callApi();
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
                  SizedBox(
                    height: 35,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (v) {
                        _notebookController.searchQuery(v);
                      },
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: AppColors.primary),
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.secondary),
                        contentPadding: const EdgeInsets.all(0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                            width:
                                2.0, // Increase the width for the focused border if needed
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                            width:
                                2.0, // Increase the width for the focused border if needed
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (_notebookController.isLoading.value &&
                      _notebookController.filteredNotebooks.isEmpty) {
                    return const ShimmerAnnouncementCard();
                  } else if (!_notebookController.isLoading.value &&
                      _notebookController.filteredNotebooks.isEmpty) {
                    return const SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: NoDataWidget());
                  }
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        // Reached the end of the list, load the next page
                        _notebookController.loadNextPage();
                      }
                      return false;
                    },
                    child: Padding(
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
                          itemCount:
                              _notebookController.filteredNotebooks.length,
                          itemBuilder: (BuildContext context, int index) {
                            NotebooksListModel model =
                                _notebookController.filteredNotebooks[index];
                            return NotebookListItem(
                              title: model.title!,
                              description: model.message!,
                              imageUrl: model.userPhoto!,
                              employeeName: model.userName!,
                              date: TimeDateFunctions.dateTimeInDigits(
                                  model.createdAt!),
                              model: model,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotebookListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String employeeName;
  final String date;
  final NotebooksListModel model;

  const NotebookListItem({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.employeeName,
    required this.date,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Go.to(() => NoteBookDetailPage(
              model: model,
            ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: AppColors.primary,
                ),
                child: const Text(
                  'New',
                  style: TextStyle(fontSize: 8, color: Colors.white),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleImage(imageUrl: imageUrl),
                const SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: CustomTextStyles.bodyTextStyle(
                            color: AppColors.primary),
                      ),
                      Html(
                        data: description,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 16.0 + 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    employeeName,
                    style: CustomTextStyles.captionTextStyle(
                        color: AppColors.primary),
                  ),
                  Text(
                    date,
                    style: CustomTextStyles.captionTextStyle(
                        color: AppColors.primary),
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
