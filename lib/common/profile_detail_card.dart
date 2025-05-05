import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/gradient_widget.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class ProfileDetailCard extends StatelessWidget {
  final VoidCallback onImageTap;
  final RegistrationUserData? userData;

  const ProfileDetailCard({Key? key, required this.userData, required this.onImageTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onImageTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.fromLTRB(13, 9, 13, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorRes.black.withOpacity(0.33),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${CommonUI.fullName(userData?.fullname)} ',
                          style: const TextStyle(
                              color: ColorRes.white,
                              fontSize: 20,
                              fontFamily: FontRes.bold,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        userData?.age != null ? '${userData?.age}' : '',
                        style: const TextStyle(
                          color: ColorRes.white,
                          fontSize: 20,
                          fontFamily: FontRes.medium,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Visibility(
                        visible: userData?.isVerified == 2 ? true : false,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 9,
                              width: 9,
                              color: ColorRes.white,
                            ),
                            Image.asset(
                              AssetRes.tickMark,
                              height: 17.5,
                              width: 18.33,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: userData?.live == null || userData!.live!.isEmpty ? false : true,
                    child: Row(
                      children: [
                        GradientWidget(
                          child: Image.asset(
                            AssetRes.locationPin,
                            height: 13.5,
                            width: 10.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          userData?.live ?? '',
                          style: const TextStyle(
                            color: ColorRes.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.25),
                  Text(
                    userData?.bio ?? '',
                    style: const TextStyle(
                      color: ColorRes.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
