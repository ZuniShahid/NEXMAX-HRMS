import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/circle_image.dart';
import '../../constants/gradeinet_background.dart';
import '../../constants/text_style.dart';
import '../../constants/time_date_functions.dart';
import '../../models/notebook_list_model.dart';

class NoteBookDetailPage extends StatefulWidget {
  const NoteBookDetailPage({super.key, required this.model});

  final NotebooksListModel model;

  @override
  State<NoteBookDetailPage> createState() => _NoteBookDetailPageState();
}

class _NoteBookDetailPageState extends State<NoteBookDetailPage> {
  final ScrollController _customController = ScrollController();
  late NotebooksListModel _model;

  @override
  void initState() {
    // TODO: implement initState
    _model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            ''.toUpperCase(),
            style: const TextStyle(color: Colors.white),
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
          actions: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.download_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.print,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 3),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleImage(imageUrl: _model.userPhoto!),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _model.userName!,
                            style: CustomTextStyles.bodyTextStyle(
                                color: AppColors.primary),
                          ),
                          Text(
                            TimeDateFunctions.dateTimeInDigits(_model.createdAt!),
                            style: CustomTextStyles.captionTextStyle(
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: AppColors.secondary,
                  thickness: 2.0,
                ),
              ),
              Expanded(
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 28),
                    physics: const BouncingScrollPhysics(),
                    controller: _customController,
                    children: [
                      Text(
                        _model.title!,
                        style: CustomTextStyles.bodyTextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Html(
                        data: _model.message!,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox pageSizedBox() => const SizedBox(height: 20);
}

