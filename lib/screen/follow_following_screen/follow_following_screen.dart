import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/follow_following_screen/follow_following_screen_view_model.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class FollowFollowingScreen extends StatelessWidget {
  final FollowFollowingType followFollowingType;
  final int userId;

  const FollowFollowingScreen({Key? key, required this.followFollowingType, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FollowFollowingScreenViewModel>.reactive(
      viewModelBuilder: () => FollowFollowingScreenViewModel(followFollowingType, userId),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back, color: ColorRes.davyGrey)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          FollowFollowingType.following == followFollowingType
                              ? S.of(context).followingList
                              : S.of(context).followerList,
                          style: const TextStyle(color: ColorRes.davyGrey, fontFamily: FontRes.semiBold, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? CommonUI.lottieWidget()
                    : viewModel.users.isEmpty
                        ? CommonUI.noData()
                        : ListView.builder(
                            controller: viewModel.scrollController,
                            itemCount: viewModel.users.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              RegistrationUserData user = viewModel.users[index];
                              return InkWell(
                                onTap: () {
                                  Get.to(() => UserDetailScreen(
                                        userData: user,
                                        userId: user.id,
                                      ));
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: ColorRes.lightGrey2,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(7),
                                          child: CachedNetworkImage(
                                            imageUrl: CommonFun.getProfileImage(images: user.images),
                                            cacheKey: CommonFun.getProfileImage(images: user.images),
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) {
                                              return CommonUI.profileImagePlaceHolder(
                                                  name: user.fullname, borderRadius: 7, heightWidth: 50);
                                            },
                                          )),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    CommonUI.fullName(user.fullname),
                                                    style: const TextStyle(
                                                        fontFamily: FontRes.bold,
                                                        fontSize: 18,
                                                        color: ColorRes.darkGrey),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(' ${user.age ?? 0} ',
                                                    style: const TextStyle(
                                                        fontFamily: FontRes.regular,
                                                        color: ColorRes.darkGrey,
                                                        fontSize: 18)),
                                                user.isVerified == 0
                                                    ? const SizedBox()
                                                    : Image.asset(
                                                        AssetRes.icBlueTick,
                                                        width: 18,
                                                      )
                                              ],
                                            ),
                                            Text(
                                              user.live ?? '',
                                              style: const TextStyle(
                                                  color: ColorRes.darkGrey9, fontFamily: FontRes.regular, fontSize: 13),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        );
      },
    );
  }
}
