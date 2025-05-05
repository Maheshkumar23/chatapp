import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class BottomButtons extends StatelessWidget {
  final List<String> genderList;
  final int selectedGender;
  final Function(int value) onGenderSelect;
  final VoidCallback onMatchingStart;
  final BannerAd? bannerAd;

  const BottomButtons(
      {Key? key,
      required this.genderList,
      required this.selectedGender,
      required this.onGenderSelect,
      required this.onMatchingStart,
      required this.bannerAd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.current.findSomeoneRandomly,
          textAlign: TextAlign.center,
          style: const TextStyle(color: ColorRes.davyGrey, fontSize: 16),
        ),
        const SizedBox(height: 10),
        if (bannerAd != null)
          Container(
            alignment: Alignment.center,
            width: bannerAd?.size.width.toDouble(),
            height: bannerAd?.size.height.toDouble(),
            child: AdWidget(ad: bannerAd!),
          ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: ColorRes.grey10,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: selectedGender == 1
                    ? Alignment.centerLeft
                    : selectedGender == 3
                        ? Alignment.center
                        : Alignment.centerRight,
                child: Container(
                  width: (Get.width / genderList.length) - 14 - (genderList.length * 5),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ColorRes.lightOrange, ColorRes.darkOrange]),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        onGenderSelect(1);
                      },
                      child: SizedBox(
                        width: (Get.width / genderList.length) - 14 - (genderList.length * 5),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selectedGender == 1 ? ColorRes.white : ColorRes.davyGrey,
                              fontSize: 13,
                              fontFamily: FontRes.bold,
                            ),
                            child: Text(S.current.boys),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        onGenderSelect(3);
                      },
                      child: SizedBox(
                        width: (Get.width / genderList.length) - 14 - (genderList.length * 5),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selectedGender == 3 ? ColorRes.white : ColorRes.davyGrey,
                              fontSize: 13,
                              fontFamily: FontRes.bold,
                            ),
                            child: Text(S.current.both),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        onGenderSelect(2);
                      },
                      child: SizedBox(
                        width: (Get.width / genderList.length) - 14 - (genderList.length * 5),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selectedGender == 2 ? ColorRes.white : ColorRes.davyGrey,
                              fontSize: 13,
                              fontFamily: FontRes.bold,
                            ),
                            child: Text(S.current.girls),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: Get.height / 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onMatchingStart,
            child: Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                color: ColorRes.darkOrange.withOpacity(0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  S.current.startMatching,
                  style: const TextStyle(
                    color: ColorRes.darkOrange,
                    fontFamily: FontRes.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Get.height / 60),
      ],
    );
  }
}
