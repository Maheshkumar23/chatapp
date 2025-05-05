import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/blocked_profiles_screen/blocked_profiles_screen.dart';
import 'package:orange_ui/screen/like_profiles_screen/like_profiles_screen.dart';
import 'package:orange_ui/screen/saved_profiles_screen/saved_profiles_screen.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class OptionsCenterArea extends StatelessWidget {
  final bool notificationEnable;
  final bool showMeOnMap;
  final bool goAnonymous;
  final VoidCallback onApplyForVerTap;
  final VoidCallback onLiveStreamTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onShowMeOnMapTap;
  final VoidCallback onAnonymousTap;
  final int? verification;

  const OptionsCenterArea(
      {Key? key,
      required this.notificationEnable,
      required this.showMeOnMap,
      required this.goAnonymous,
      required this.onLiveStreamTap,
      required this.onNotificationTap,
      required this.onShowMeOnMapTap,
      required this.onAnonymousTap,
      required this.onApplyForVerTap,
      required this.verification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 6,
        ),
        TopOptionCard(
            title: S.current.livestream,
            onTap: onLiveStreamTap,
            widget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.asset(AssetRes.sun, height: 28, width: 28, color: ColorRes.lightOrange),
            )),
        Visibility(
          visible: verification == 0,
          child: TopOptionCard(
              title: S.current.verification,
              onTap: onApplyForVerTap,
              widget: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Image.asset(AssetRes.icBlueTick, height: 28, width: 28),
              )),
        ),
        Visibility(
          visible: (verification == 2
              ? false
              : true && verification == 0
                  ? false
                  : true),
          child: Stack(
            children: [
              Container(
                height: 54,
                width: Get.width,
                margin: const EdgeInsets.only(top: 3, bottom: 3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(AssetRes.map1),
                ),
              ),
              Container(
                height: 54,
                width: Get.width,
                margin: const EdgeInsets.only(top: 3, bottom: 3),
                decoration: BoxDecoration(
                  color: ColorRes.darkGrey5.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                height: 54,
                width: Get.width,
                margin: const EdgeInsets.only(top: 3, bottom: 3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15, tileMode: TileMode.mirror),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Image.asset(
                            AssetRes.tickMark,
                            height: 25,
                            width: 25,
                          ),
                        ),
                        Text(
                          S.current.liveVerification,
                          style: const TextStyle(
                            color: ColorRes.davyGrey,
                            fontSize: 15,
                            fontFamily: FontRes.semiBold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 36.17,
                          width: 112,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: verification == 0
                                ? ColorRes.darkOrange.withOpacity(0.20)
                                : verification == 1
                                    ? ColorRes.lightOrange.withOpacity(0.20)
                                    : ColorRes.lightGreen.withOpacity(0.20),
                          ),
                          child: Center(
                            child: Text(
                              verification == 0
                                  ? S.current.notEligible
                                  : verification == 1
                                      ? S.current.pending
                                      : S.current.eligible,
                              style: TextStyle(
                                fontSize: 12,
                                color: verification == 0
                                    ? ColorRes.darkOrange
                                    : verification == 1
                                        ? ColorRes.lightOrange
                                        : ColorRes.green2,
                                fontFamily: FontRes.semiBold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        TopOptionCard(
            onTap: () {
              Get.to(() => const SavedProfilesScreen());
            },
            title: S.current.savedProfiles,
            widget: const CircleImage(image: AssetRes.icBookMark)),
        TopOptionCard(
          onTap: () {
            Get.to(() => const LikeProfilesScreen());
          },
          title: S.current.likeProfiles,
          widget: const CircleImage(image: AssetRes.icFillFav),
        ),
        TopOptionCard(
            onTap: () {
              Get.to(() => const BlockedProfilesScreen());
            },
            title: S.of(context).blockedProfiles,
            widget: const CircleImage(image: AssetRes.icBlock)),
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 9),
          child: Text(
            S.current.privacy,
            style: const TextStyle(
              color: ColorRes.grey23,
              fontSize: 14,
              fontFamily: FontRes.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
        PermissionTiles(
          title: S.current.pushNotification,
          subTitle: S.current.notificationData,
          enable: notificationEnable,
          onTap: onNotificationTap,
        ),
        PermissionTiles(
          title: S.current.switchMap,
          subTitle: S.current.switchMapData,
          enable: showMeOnMap,
          onTap: onShowMeOnMapTap,
        ),
        PermissionTiles(
          title: S.current.anonymous,
          subTitle: S.current.anonymousData,
          enable: goAnonymous,
          onTap: onAnonymousTap,
        ),
      ],
    );
  }
}

class CircleImage extends StatelessWidget {
  final String image;

  const CircleImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      height: 28,
      width: 28,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: ColorRes.darkOrange.withOpacity(0.1), shape: BoxShape.circle),
      child: Image.asset(image),
    );
  }
}

class PermissionTiles extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool enable;
  final VoidCallback onTap;

  const PermissionTiles(
      {Key? key, required this.title, required this.subTitle, required this.enable, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorRes.grey10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: ColorRes.davyGrey,
                  fontFamily: FontRes.semiBold,
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                width: Get.width - 90,
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    color: ColorRes.grey20,
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onTap,
            child: Container(
              height: 25,
              width: 36,
              padding: const EdgeInsets.symmetric(horizontal: 3.5),
              alignment: enable ? Alignment.centerRight : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: ColorRes.grey,
                borderRadius: BorderRadius.circular(30),
                gradient: enable
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [ColorRes.lightOrange, ColorRes.darkOrange],
                      )
                    : null,
              ),
              child: Container(
                height: 19,
                width: 19,
                decoration: const BoxDecoration(
                  color: ColorRes.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopOptionCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Widget widget;

  const TopOptionCard({
    Key? key,
    required this.onTap,
    required this.title,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 49,
        margin: const EdgeInsets.symmetric(vertical: 3),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorRes.grey10,
        ),
        child: Row(
          children: [
            widget,
            Text(
              title,
              style: const TextStyle(
                color: ColorRes.davyGrey,
                fontSize: 15,
                fontFamily: FontRes.semiBold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
