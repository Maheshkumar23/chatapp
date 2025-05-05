import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/full_image_view_shimmer.dart';
import 'package:orange_ui/common/live_icon.dart';
import 'package:orange_ui/common/profile_detail_card.dart';
import 'package:orange_ui/common/social_icon.dart';
import 'package:orange_ui/common/top_story_line.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class FullImageView extends StatelessWidget {
  final List<RegistrationUserData> userList;
  final VoidCallback onLiveBtnTap;
  final VoidCallback onImageTap;
  final VoidCallback onInstagramTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onYoutubeTap;
  final bool isLoading;
  final SwiperController userController;
  final Function(int index) onIndexChange;
  final bool Function(String? value) isSocialBtnVisible;

  const FullImageView(
      {Key? key,
      required this.userList,
      required this.onLiveBtnTap,
      required this.onImageTap,
      required this.onInstagramTap,
      required this.onFacebookTap,
      required this.onYoutubeTap,
      required this.isLoading,
      required this.userController,
      required this.onIndexChange,
      required this.isSocialBtnVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const FullImageViewShimmer();
    } else {
      return Expanded(
        child: userList.isEmpty
            ? CommonUI.noData()
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 17),
                child: AspectRatio(
                  aspectRatio: 1 / 1.30,
                  child: Swiper(
                    controller: userController,
                    duration: 250,
                    itemCount: userList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    onIndexChanged: onIndexChange,
                    itemBuilder: (context, currentProfileIndex) {
                      List<Images>? imagesProfile = userList[currentProfileIndex].images;
                      final PageController pageController = PageController();
                      return Stack(
                        children: [
                          imagesProfile.isEmpty
                              ? CommonUI.profileImagePlaceHolder(
                                  name: userList[currentProfileIndex].fullname,
                                  heightWidth: MediaQuery.of(context).size.height,
                                  borderRadius: 20)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount: userList[currentProfileIndex].images.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, currentImageIndex) {
                                      return Stack(
                                        children: [
                                          FadeInImage(
                                            placeholder: const AssetImage(AssetRes.placeholder),
                                            image: NetworkImage(CommonFun.getProfileImage(
                                                images: userList[currentProfileIndex].images,
                                                index: currentImageIndex)),
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                            filterQuality: FilterQuality.medium,
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return CommonUI.profileImagePlaceHolder(
                                                  name: userList[currentProfileIndex].fullname,
                                                  heightWidth: MediaQuery.of(context).size.height,
                                                  borderRadius: 20);
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (currentImageIndex == 0) {
                                                      return;
                                                    }
                                                    pageController.previousPage(
                                                      duration: const Duration(milliseconds: 500),
                                                      curve: Curves.linear,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: Get.height - 256,
                                                    color: ColorRes.transparent,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (userList[currentProfileIndex].images.length - 1 ==
                                                        currentImageIndex) {
                                                      return;
                                                    }
                                                    pageController.nextPage(
                                                      duration: const Duration(milliseconds: 500),
                                                      curve: Curves.linear,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: Get.height - 256,
                                                    color: ColorRes.transparent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                          Column(
                            children: [
                              const SizedBox(height: 14),
                              TopStoryLine(
                                pageController: pageController,
                                images: userList[currentProfileIndex].images,
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 9),
                                child: Row(
                                  children: [
                                    SocialIcon(
                                        icon: AssetRes.instagramLogo,
                                        size: 15,
                                        onSocialIconTap: onInstagramTap,
                                        isVisible: isSocialBtnVisible(userList[currentProfileIndex].instagram)),
                                    SocialIcon(
                                        icon: AssetRes.facebookLogo,
                                        size: 21.0,
                                        onSocialIconTap: onFacebookTap,
                                        isVisible: isSocialBtnVisible(userList[currentProfileIndex].facebook)),
                                    SocialIcon(
                                        icon: AssetRes.youtubeLogo,
                                        size: 20.16,
                                        onSocialIconTap: onYoutubeTap,
                                        isVisible: isSocialBtnVisible(userList[currentProfileIndex].youtube)),
                                    const Spacer(),
                                    Visibility(
                                      visible: userList[currentProfileIndex].isLiveNow == 1 ? true : false,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: InkWell(
                                            onTap: onLiveBtnTap,
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
                                userData: userList[currentProfileIndex],
                                onImageTap: onImageTap,
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
      );
    }
  }
}
