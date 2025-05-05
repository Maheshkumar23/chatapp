import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/color_res.dart';

class TopStoryLine extends StatefulWidget {
  final List<Images> images;
  final PageController pageController;

  const TopStoryLine({Key? key, required this.images, required this.pageController}) : super(key: key);

  @override
  State<TopStoryLine> createState() => _TopStoryLineState();
}

class _TopStoryLineState extends State<TopStoryLine> {
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
