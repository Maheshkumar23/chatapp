import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class BottomInfoField extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onNextTap;
  final VoidCallback onSkipTap;
  final String buttonText;

  const BottomInfoField({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onNextTap,
    required this.onSkipTap,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: ColorRes.darkGrey5,
              fontSize: 25,
              fontFamily: FontRes.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColorRes.grey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: Get.height / 12),
          InkWell(
            onTap: onNextTap,
            child: Container(
              height: 48,
              width: 238,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorRes.lightOrange,
                    ColorRes.darkOrange,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: ColorRes.white,
                    fontSize: 15,
                    fontFamily: FontRes.semiBold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 25),
          InkWell(
            onTap: onSkipTap,
            child: Text(
              S.current.skip,
              style: const TextStyle(
                color: ColorRes.dimGrey3,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: Get.height / 25),
        ],
      ),
    );
  }
}
