import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/like_profiles_screen/like_profiles_screen_view_model.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class LikeCard extends StatelessWidget {
  final RegistrationUserData userData;
  final LikeProfilesScreenViewModel viewModel;
  final bool isLike;

  const LikeCard({Key? key, required this.userData, required this.viewModel, required this.isLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => UserDetailScreen(userData: userData))?.then((value) {
          viewModel.onLikeCardBack(userData);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: const BoxDecoration(color: ColorRes.lightGrey2),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: CommonFun.getProfileImage(images: userData.images),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return CommonUI.profileImagePlaceHolder(name: userData.fullname, heightWidth: 40);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(userData.fullname ?? 'Unknown',
                            style: const TextStyle(
                              color: ColorRes.darkGrey,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: FontRes.bold,
                            ),
                            maxLines: 1),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        "${userData.age ?? ''}",
                        style: const TextStyle(
                            color: ColorRes.darkGrey,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      const SizedBox(width: 3),
                      userData.isVerified == 2
                          ? Image.asset(AssetRes.tickMark, height: 18, width: 18)
                          : const SizedBox(),
                    ],
                  ),
                  Text(userData.live ?? '',
                      style: const TextStyle(
                          color: ColorRes.darkGrey9, fontSize: 13, overflow: TextOverflow.ellipsis),
                      maxLines: 1),
                ],
              ),
            ),
            InkWell(
              onTap: () => viewModel.onSavedClick(userData),
              child: Icon(
                isLike ? Icons.favorite : Icons.favorite_border,
                color: isLike ? ColorRes.darkOrange : null,
                size: 23,
              ),
            )
          ],
        ),
      ),
    );
  }
}
