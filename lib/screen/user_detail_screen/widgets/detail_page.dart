import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/follow_following_screen/follow_following_screen.dart';
import 'package:orange_ui/screen/follow_following_screen/follow_following_screen_view_model.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen_view_model.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/style_res.dart';

class DetailPage extends StatelessWidget {
  final UserDetailScreenViewModel model;

  final VoidCallback onHideBtnTap;

  const DetailPage({Key? key, required this.onHideBtnTap, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding: const EdgeInsets.fromLTRB(21, 20, 21, 0),
                  decoration: BoxDecoration(
                    color: ColorRes.black.withOpacity(0.33),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Text(
                                      model.userData?.fullname ?? AppRes.defaultFullname,
                                      style: const TextStyle(
                                          color: ColorRes.white,
                                          fontSize: 22,
                                          fontFamily: FontRes.bold,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      " ${model.userData?.age ?? 0} ",
                                      style: const TextStyle(
                                          color: ColorRes.white,
                                          fontSize: 22,
                                          fontFamily: FontRes.regular,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Flexible(
                                    child: Visibility(
                                      visible: model.userData?.isVerified == 2 ? true : false,
                                      child: Image.asset(AssetRes.tickMark, height: 20, width: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: PrefService.userId == model.userData?.id ? false : true,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: model.onSaveTap,
                                child: Container(
                                  height: 37,
                                  width: 37,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: ColorRes.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    AssetRes.save,
                                    color: model.save ? null : ColorRes.dimGrey5.withOpacity(0.70),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          model.userData?.bio ?? '',
                          style: TextStyle(color: ColorRes.white.withOpacity(0.80), fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    height: 27,
                                    width: 27,
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: ColorRes.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(AssetRes.home),
                                  ),
                                  const SizedBox(width: 7),
                                  Flexible(
                                    child: Text(
                                      model.userData?.live == null || model.userData!.live!.isEmpty
                                          ? ''
                                          : '${model.userData?.live}',
                                      style: TextStyle(
                                          color: ColorRes.white.withOpacity(0.80),
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Visibility(
                                visible: PrefService.userId == model.userData?.id ? false : true,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 27,
                                      width: 27,
                                      padding: const EdgeInsets.all(6.5),
                                      decoration: const BoxDecoration(
                                        color: ColorRes.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        AssetRes.locationPin,
                                        color: ColorRes.darkOrange,
                                        height: 12.25,
                                        width: 10.5,
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    Flexible(
                                      child: Text(
                                        model.distance == 0.0
                                            ? S.of(context).noLocation
                                            : '${model.distance.toStringAsFixed(2)} ${S.of(context).kmsAway}',
                                        style: TextStyle(
                                            color: ColorRes.white.withOpacity(0.80),
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          S.current.about,
                          style: const TextStyle(color: ColorRes.white, fontFamily: FontRes.bold, fontSize: 17),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          model.userData?.about ?? S.current.noDataAvailable,
                          style: TextStyle(color: ColorRes.white.withOpacity(0.80), fontSize: 14),
                        ),
                        const SizedBox(height: 15),
                        model.interestList.isNotEmpty
                            ? Text(
                                S.current.interest,
                                style: const TextStyle(color: ColorRes.white, fontFamily: FontRes.bold, fontSize: 17),
                              )
                            : const SizedBox(),
                        if (model.interestList.isNotEmpty) const SizedBox(height: 11),
                        interestButtons(model.interestList),
                        if (model.settingAppData?.isSocialMedia == 1)
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: ColorRes.davyGrey.withOpacity(0.15),
                                        border: Border.all(color: ColorRes.dimGrey7.withOpacity(0.15)),
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Row(
                                      children: [
                                        VerticalColumnText(
                                          count: NumberFormat.compact().format(model.userData?.following ?? 0),
                                          title: S.of(context).following,
                                          onTap: () {
                                            Get.to(() => FollowFollowingScreen(
                                                  followFollowingType: FollowFollowingType.following,
                                                  userId: model.userData?.id ?? -1,
                                                ));
                                          },
                                        ),
                                        const SizedBox(width: 20),
                                        VerticalColumnText(
                                          count: NumberFormat.compact().format(model.userData?.followers ?? 0),
                                          title: S.of(context).followers,
                                          onTap: () {
                                            Get.to(() => FollowFollowingScreen(
                                                  followFollowingType: FollowFollowingType.follower,
                                                  userId: model.userData?.id ?? -1,
                                                ));
                                          },
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: model.userData?.id == PrefService.userId
                                              ? InkWell(
                                                  onTap: model.onEditBtnClick,
                                                  child: Container(
                                                      padding: const EdgeInsets.all(15),
                                                      alignment: Alignment.center,
                                                      decoration: ShapeDecoration(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(30)),
                                                          color: ColorRes.dimGrey7.withOpacity(0.15)),
                                                      child: Text(
                                                        S.current.edit.toUpperCase(),
                                                        style: const TextStyle(
                                                            fontFamily: FontRes.bold,
                                                            color: ColorRes.white,
                                                            fontSize: 12,
                                                            letterSpacing: 1.33),
                                                      )),
                                                )
                                              : FollowUnFollowBtn(model: model),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        const SizedBox(height: 6),
                        Visibility(
                          visible: PrefService.userId != model.userData?.id,
                          child: InkWell(
                            onTap: model.onChatWithBtnTap,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 50,
                              width: Get.width,
                              decoration: BoxDecoration(color: ColorRes.white, borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  '${S.current.chatWith}${model.userData?.fullname?.toUpperCase()}',
                                  style: const TextStyle(
                                      color: ColorRes.darkOrange,
                                      fontSize: 12,
                                      fontFamily: FontRes.bold,
                                      letterSpacing: 0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        InkWell(
                          onTap: model.onShareProfileBtnTap,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 50,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: ColorRes.dimGrey7.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text(
                                  '${S.current.share} ${model.userData?.fullname?.toUpperCase()}\'S ${S.current.profileCap}',
                                  style: const TextStyle(
                                      color: ColorRes.white,
                                      fontSize: 12,
                                      fontFamily: FontRes.bold,
                                      letterSpacing: 0.6),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                        const SizedBox(height: 27),
                        Visibility(
                          visible: PrefService.userId == model.userData?.id ? false : true,
                          child: Center(
                            child: InkWell(
                              onTap: model.onReportTap,
                              child: Text(
                                '${S.current.reportCap}${model.userData?.fullname?.toUpperCase()}',
                                style: TextStyle(
                                  color: ColorRes.white.withOpacity(0.50),
                                  fontSize: 12,
                                  fontFamily: FontRes.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          HideInfoChip(onHideBtnTap: onHideBtnTap),
        ],
      ),
    );
  }

  Widget interestButtons(List<String> interests) {
    return Wrap(
      children: interests.map<Widget>((e) {
        return Container(
          margin: const EdgeInsets.only(right: 8, bottom: 10),
          padding: const EdgeInsets.fromLTRB(20.6, 9.50, 20.6, 8.51),
          decoration: BoxDecoration(color: ColorRes.white.withOpacity(0.15), borderRadius: BorderRadius.circular(50)),
          child: Text(
            e.toUpperCase(),
            style:
                const TextStyle(fontSize: 12, color: ColorRes.white, letterSpacing: 0.5, fontFamily: FontRes.semiBold),
          ),
        );
      }).toList(),
    );
  }
}

class FollowUnFollowBtn extends StatelessWidget {
  final UserDetailScreenViewModel model;

  const FollowUnFollowBtn({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: model.onFollowUnfollowBtnClick,
      child: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              gradient: !model.isFollow ? StyleRes.linearGradient : null,
              color: model.isFollow ? ColorRes.dimGrey7.withOpacity(0.15) : null),
          child: Text(
            (model.isFollow ? S.current.unfollow : S.current.follow).toUpperCase(),
            style: const TextStyle(fontFamily: FontRes.bold, color: ColorRes.white, fontSize: 12, letterSpacing: 1.33),
          )),
    );
  }
}

class VerticalColumnText extends StatelessWidget {
  final String count;
  final String title;
  final VoidCallback onTap;

  const VerticalColumnText({Key? key, required this.count, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(count, style: TextStyle(color: ColorRes.white.withOpacity(0.8), fontFamily: FontRes.bold, fontSize: 22)),
          Text(title,
              style: TextStyle(color: ColorRes.white.withOpacity(0.8), fontFamily: FontRes.medium, fontSize: 15)),
        ],
      ),
    );
  }
}

class HideInfoChip extends StatefulWidget {
  final VoidCallback onHideBtnTap;

  const HideInfoChip({Key? key, required this.onHideBtnTap}) : super(key: key);

  @override
  State<HideInfoChip> createState() => _HideInfoChipState();
}

class _HideInfoChipState extends State<HideInfoChip> with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller?.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller!.value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        widget.onHideBtnTap();
        HapticFeedback.lightImpact();
      },
      onTapUp: _tapUp,
      onTapDown: _tapDown,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.fromLTRB(21, 10, 21, 9),
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
          child: Text(
            S.current.hideInfo,
            style: TextStyle(
              color: ColorRes.white.withOpacity(0.80),
              fontSize: 11,
              fontFamily: FontRes.bold,
              letterSpacing: 0.65,
            ),
          ),
        ),
      ),
    );
  }
}
