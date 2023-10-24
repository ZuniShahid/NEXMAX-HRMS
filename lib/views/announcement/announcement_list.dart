import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/assets.dart';
import '../../constants/circle_image.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/no_data_widget.dart';
import '../../constants/page_navigation.dart';
import '../../constants/text_style.dart';
import '../../controllers/announcement_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/announcement_model.dart';
import '../../utilities/shimmer.dart';
import '../home/setting_page.dart';
import 'announcement_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _customController = ScrollController();
  final AnnouncementController _announcementController =
      Get.put(AnnouncementController());
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    _announcementController.callApi();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppAssets.purpleBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  Go.to(() => const SettingPage());
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleImage(
                    imageUrl: _authController.userData.value.profilePicture!,
                    height: 200,
                    width: 200,
                    placeBorderColor: Colors.transparent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _authController.userData.value.fullName!,
                    style: CustomTextStyles.titleStyle(color: Colors.white),
                  ),
                  Text(
                    _authController.userData.value.position!,
                    style: CustomTextStyles.titleStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 35.0),
                        child: Text(
                          'Announcement',
                          style: CustomTextStyles.bodyTextStyle(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Obx(() {
                          if (_announcementController.isLoadingInitial.value &&
                              _announcementController
                                  .announcementList.isEmpty) {
                            return _buildShimmerList(5);
                          } else if (!_announcementController
                                  .isLoadingInitial.value &&
                              _announcementController
                                  .announcementList.isEmpty) {
                            return const SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: NoDataWidget());
                          }

                          return NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                                _announcementController.loadNextPage();
                              }
                              return false;
                            },
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
                                    ),
                                  ),
                                );
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                physics: const BouncingScrollPhysics(),
                                controller: _customController,
                                itemCount: _announcementController
                                    .announcementList.length,
                                itemBuilder: (context, index) {
                                  AnnouncementsModelList model =
                                      _announcementController
                                          .announcementList[index];
                                  return CustomListItem(
                                    title: model.announcementDetail!.title!,
                                    description: model.message == null
                                        ? ''
                                        : model.message!,
                                    imageUrl:
                                        model.announcementDetail!.userPhoto!,
                                    employeeName:
                                        model.announcementDetail!.userName!,
                                    date: DateFormat('dd-MMM-yyyy').format(
                                        model.announcementDetail!.createdAt!),
                                    announcementDetail:
                                        model.announcementDetail!,
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(int itemCount) {
    return const ShimmerAnnouncementCard();
  }
}

class CustomListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String employeeName;
  final String date;
  final AnnouncementDetailModel announcementDetail;

  const CustomListItem({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.employeeName,
    required this.date,
    required this.announcementDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Go.to(() => AnnouncementDetailPage(
              announcementDetail: announcementDetail,
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
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
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
                        style: CustomTextStyles.bodyTextStyle(),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  employeeName,
                  style: CustomTextStyles.captionTextStyle(),
                ),
                const SizedBox(width: 30),
                Text(
                  date,
                  style: CustomTextStyles.captionTextStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
