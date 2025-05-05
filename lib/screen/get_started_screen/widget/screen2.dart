import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/get_started_screen/widget/bottom_info_field.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class Screen2 extends StatelessWidget {
  final VoidCallback onNextTap;
  final VoidCallback onSkipTap;

  const Screen2({
    Key? key,
    required this.onNextTap,
    required this.onSkipTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: ColorRes.white,
      child: Stack(
        children: [
          Image.asset(AssetRes.getStarted2BG, width: Get.width, fit: BoxFit.cover, color: ColorRes.lightOrange),
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: Get.height / 10),
                Row(
                  children: [
                    SizedBox(width: Get.width / 2.25),
                    clipTile(AssetRes.fitness, S.current.fitness),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    SizedBox(width: Get.width / 4.8),
                    clipTile(AssetRes.music, S.current.music),
                    const SizedBox(width: 7),
                    clipTile(AssetRes.fastFood, S.current.foodies),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(width: Get.width / 10),
                      clipTile(AssetRes.movies, S.current.movies),
                      const SizedBox(width: 11),
                      clipTile(AssetRes.walking, S.current.walking),
                      const SizedBox(width: 11),
                      clipTile(AssetRes.chef, S.current.chef),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SizedBox(width: Get.width / 4.0),
                    clipTile(AssetRes.microphone, S.current.singing),
                    const SizedBox(width: 11),
                    clipTile(AssetRes.travel, S.current.travel),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    SizedBox(width: Get.width / 2.5),
                    clipTile(AssetRes.artist, S.current.artist),
                  ],
                ),
                SizedBox(height: Get.height / 8),
              ],
            ),
          ),
          BottomInfoField(
            title: S.current.exploreProfiles,
            subTitle: S.current.getStarted2Subtitle,
            onNextTap: onNextTap,
            onSkipTap: onSkipTap,
            buttonText: S.current.thatGreat,
          )
        ],
      ),
    );
  }

  Widget clipTile(String icon, String label) {
    return Container(
      height: 39,
      width: 116,
      decoration: BoxDecoration(color: ColorRes.white, borderRadius: BorderRadius.circular(30), boxShadow: [
        BoxShadow(
          color: ColorRes.black.withOpacity(0.10),
          offset: const Offset(0, 0.5),
          blurRadius: 3,
          spreadRadius: 2,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 18,
            width: 18,
            color: ColorRes.darkOrange,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: ColorRes.darkGrey,
              fontSize: 15,
              fontFamily: FontRes.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
