import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/gradient_widget.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class FullImageView extends StatelessWidget {
  final List<File>? imageList;
  final PageController pageController;
  final String fullName;
  final int? age;
  final String address;
  final String bioText;

  const FullImageView({
    Key? key,
    required this.imageList,
    required this.pageController,
    required this.fullName,
    required this.age,
    required this.address,
    required this.bioText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height / 1.65,
      margin: const EdgeInsets.symmetric(horizontal: 36),
      child: Stack(
        children: [
          imageList == null || imageList!.isEmpty
              ? CommonUI.profileImagePlaceHolder(
                  name: fullName, heightWidth: MediaQuery.of(context).size.height / 1.65, borderRadius: 20)
              : PageView.builder(
                  controller: pageController,
                  itemCount: imageList?.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1 / pageController.viewportFraction,
                      child: Container(
                        width: Get.width,
                        height: Get.height / 1.65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(imageList![index].path)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(
            width: Get.width,
            height: Get.height / 1.65,
            child: Column(
              children: [
                const SizedBox(height: 14),
                TopFileStoryLine(pageController: pageController, images: imageList ?? []),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Row(
                    children: [
                      socialIcon(AssetRes.instagramLogo, 13.58),
                      socialIcon(AssetRes.facebookLogo, 18.0),
                      socialIcon(AssetRes.youtubeLogo, 18.26),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9, right: 9, bottom: 9, top: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 8.15, horizontal: 11.77),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorRes.black.withOpacity(0.33),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: fullName,
                                    style: const TextStyle(
                                      color: ColorRes.white,
                                      fontSize: 18,
                                      fontFamily: FontRes.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${age ?? ''}",
                                    style: const TextStyle(
                                      color: ColorRes.white,
                                      fontSize: 18,
                                      fontFamily: FontRes.regular,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GradientWidget(
                                  child: Image.asset(
                                    AssetRes.locationPin,
                                    height: 12.23,
                                    width: 9.51,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  address,
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bioText,
                              style: const TextStyle(
                                color: ColorRes.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget socialIcon(String icon, double size) {
    return Container(
      height: 27,
      width: 27,
      margin: const EdgeInsets.only(right: 6.34),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorRes.white,
      ),
      child: Center(
        child: Image.asset(icon, height: size, width: size),
      ),
    );
  }
}

class TopFileStoryLine extends StatefulWidget {
  final List<File> images;
  final PageController pageController;

  const TopFileStoryLine({Key? key, required this.images, required this.pageController}) : super(key: key);

  @override
  State<TopFileStoryLine> createState() => _TopFileStoryLineState();
}

class _TopFileStoryLineState extends State<TopFileStoryLine> {
  int currentPosition = 0;
  int lastCurrentPosition = 0;

  @override
  Widget build(BuildContext context) {
    widget.pageController.addListener(() {
      currentPosition = widget.pageController.page?.round() ?? 0;
      if (currentPosition != lastCurrentPosition) {
        if (mounted) {
          lastCurrentPosition = currentPosition;
          setState(() {});
        }
      }
    });
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 31),
      child: Row(
        children: List.generate(widget.images.length, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 3),
              height: 2.7,
              width: (Get.width - 62) / widget.images.length,
              decoration: BoxDecoration(
                color: currentPosition == index ? ColorRes.white : ColorRes.white.withOpacity(0.30),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }
}
