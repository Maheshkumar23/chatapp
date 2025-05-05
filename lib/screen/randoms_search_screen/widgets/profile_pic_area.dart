import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/live_icon.dart';
import 'package:orange_ui/common/profile_detail_card.dart';
import 'package:orange_ui/common/social_icon.dart';
import 'package:orange_ui/common/top_story_line.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/randoms_search_screen/randoms_search_screen_view_model.dart';
import 'package:orange_ui/screen/shimmer_screen/shimmer_screen.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class ProfilePicArea extends StatelessWidget {
  final String profileImage;
  final RandomsSearchScreenViewModel model;

  const ProfilePicArea({Key? key, required this.profileImage, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: model.isLoading
          ? Container(
              width: Get.width,
              height: Get.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AssetRes.worldMap),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SpinKitRipple(
                    borderWidth: 100,
                    duration: const Duration(milliseconds: 1500),
                    size: Get.width / 1.1,
                    itemBuilder: (BuildContext context, int index) {
                      return CircleAvatar(
                        backgroundColor: ColorRes.grey21.withOpacity(0.40),
                      );
                    },
                  ),
                  SpinKitRipple(
                    borderWidth: 50,
                    duration: const Duration(milliseconds: 1500),
                    size: Get.width / 1.5,
                    itemBuilder: (BuildContext context, int index) {
                      return CircleAvatar(
                        backgroundColor: ColorRes.grey21.withOpacity(0.30),
                      );
                    },
                  ),
                  Container(
                    height: Get.width / 3,
                    width: Get.width / 3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profileImage),
                      ),
                    ),
                  ),
                ],
              ))
          : model.userData == null
              ? CommonUI.noData()
              : Container(
                  width: Get.width / 1.2,
                  height: Get.height / 1.6,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      model.userData?.images == null || model.userData!.images.isEmpty
                          ? Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: ColorRes.darkOrange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: Get.width - 100,
                                    height: Get.height - 256,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: ColorRes.darkOrange.withOpacity(0.2)),
                                    child: Image.asset(AssetRes.themeLabel),
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: PageView.builder(
                                controller: model.pageController,
                                itemCount: model.userData?.images.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String? profileImage = model.userData?.images[index].image;
                                  return FractionallySizedBox(
                                    widthFactor: 1 / model.pageController.viewportFraction,
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: '${ConstRes.aImageBaseUrl}$profileImage',
                                          cacheKey: '${ConstRes.aImageBaseUrl}$profileImage',
                                          fit: BoxFit.cover,
                                          width: Get.width,
                                          height: Get.height - 256,
                                          filterQuality: FilterQuality.medium,
                                          errorWidget: (context, error, stackTrace) {
                                            return Container(
                                              color: ColorRes.grey13,
                                              child: Image.asset(
                                                AssetRes.themeLabel,
                                                width: Get.width,
                                                height: Get.height - 256,
                                              ),
                                            );
                                          },
                                          progressIndicatorBuilder: (context, child, loadingProgress) {
                                            return ShimmerScreen.rectangular(
                                              width: Get.width,
                                              height: Get.height - 256,
                                              shapeBorder: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(21),
                                              ),
                                            );
                                          },
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: model.onLeftBtnClick,
                                                child: Container(
                                                  height: Get.height - 256,
                                                  color: ColorRes.transparent,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: model.onRightBtnClick,
                                                child: Container(
                                                  height: Get.height - 256,
                                                  color: ColorRes.transparent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(
                        height: Get.height - 256,
                        width: Get.width,
                        child: Column(
                          children: [
                            const SizedBox(height: 14),
                            TopStoryLine(pageController: model.pageController, images: model.userData?.images ?? []),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left: 9),
                              child: Row(
                                children: [
                                  SocialIcon(
                                      icon: AssetRes.instagramLogo,
                                      size: 15,
                                      onSocialIconTap: model.onInstagramTap,
                                      isVisible: model.isSocialBtnVisible(model.userData?.instagram)),
                                  SocialIcon(
                                      icon: AssetRes.facebookLogo,
                                      size: 21.0,
                                      onSocialIconTap: model.onFBTap,
                                      isVisible: model.isSocialBtnVisible(model.userData?.facebook)),
                                  SocialIcon(
                                      icon: AssetRes.youtubeLogo,
                                      size: 20.16,
                                      onSocialIconTap: model.onYoutubeTap,
                                      isVisible: model.isSocialBtnVisible(model.userData?.youtube)),
                                  const Spacer(),
                                  Visibility(
                                    visible: model.userData?.isLiveNow == 0 ? false : true,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: InkWell(
                                          onTap: model.onLiveBtnTap,
                                          child: Container(
                                            height: 35,
                                            width: 113,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40),
                                              color: ColorRes.black.withOpacity(0.33),
                                            ),
                                            child: Row(
                                              children: [
                                                const LiveIcon(),
                                                Text(
                                                  " ${S.current.liveCap}",
                                                  style: const TextStyle(
                                                    color: ColorRes.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  " ${S.current.nowCap}",
                                                  style: const TextStyle(
                                                    color: ColorRes.white,
                                                    fontFamily: FontRes.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            ProfileDetailCard(
                              onImageTap: model.onImageTap,
                              userData: model.userData,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
