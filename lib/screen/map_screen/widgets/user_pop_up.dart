import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class UserPopUp extends StatelessWidget {
  final VoidCallback onMoreInfoTap;
  final RegistrationUserData? user;

  const UserPopUp({Key? key, required this.onMoreInfoTap, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 1,
        insetPadding: const EdgeInsets.symmetric(horizontal: 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: AspectRatio(
          aspectRatio: 0.8,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: CommonFun.getProfileImage(images: user?.images),
                        cacheKey: CommonFun.getProfileImage(images: user?.images),
                        errorWidget: (context, url, error) {
                          return CommonUI.profileImagePlaceHolder(
                              name: CommonUI.fullName(user?.fullname), heightWidth: 99);
                        },
                        height: 99,
                        width: 99,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              CommonUI.fullName(user?.fullname),
                              style: const TextStyle(
                                color: ColorRes.darkGrey5,
                                fontSize: 18,
                                fontFamily: FontRes.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '  ${user?.age ?? 0}',
                            style: const TextStyle(
                              color: ColorRes.darkGrey5,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 3),
                          user?.isVerified == 0
                              ? const SizedBox()
                              : Image.asset(AssetRes.tickMark, height: 16.5, width: 16.5),
                        ],
                      ),
                    ),
                    Text(
                      user?.live ?? '',
                      style: const TextStyle(
                        color: ColorRes.grey19,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onMoreInfoTap,
                      child: Container(
                        height: 38,
                        width: 127,
                        padding: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                            S.current.moreInfo,
                            style: const TextStyle(
                              color: ColorRes.white,
                              fontFamily: FontRes.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        S.current.cancel,
                        style: const TextStyle(color: ColorRes.grey20, fontSize: 15),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
