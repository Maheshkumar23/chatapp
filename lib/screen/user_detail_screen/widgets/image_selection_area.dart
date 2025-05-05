import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/live_icon.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen_view_model.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/style_res.dart';

class ImageSelectionArea extends StatelessWidget {
  final VoidCallback onMoreInfoTap;

  final UserDetailScreenViewModel model;

  const ImageSelectionArea({Key? key, required this.onMoreInfoTap, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 35 + 76 + 15 + AppBar().preferredSize.height + 20 + 57 + 10,
      width: Get.width,
      child: Column(
        children: [
          joinBtnChip(),
          const Spacer(),
          if (model.settingAppData?.isDating == 1)
            LikeUnlikeBtn(like: model.like, onLikeBtnTap: model.onLikeBtnTap, userId: model.userData?.id),
          const SizedBox(height: 15),
          imageListArea(model.userData),
          const SizedBox(height: 20),
          BottomMoreBtn(onMoreInfoTap: onMoreInfoTap),
        ],
      ),
    );
  }

  Widget joinBtnChip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: PrefService.userId == model.userData?.id ? false : true,
          child: Visibility(
            visible: model.userData?.isLiveNow == 1 ? true : false,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                  child: InkWell(
                    onTap: model.onJoinBtnTap,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30), color: ColorRes.black.withOpacity(0.33)),
                      child: Row(
                        children: [
                          const LiveIcon(),
                          const SizedBox(width: 3),
                          Text(S.current.liveCap, style: const TextStyle(color: ColorRes.white, fontSize: 12)),
                          Text(
                            " ${S.current.nowCap}",
                            style: const TextStyle(color: ColorRes.white, fontSize: 12, fontFamily: FontRes.bold),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 31,
                            width: 95,
                            decoration: BoxDecoration(
                                color: ColorRes.white.withOpacity(0.10), borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Text(
                                S.current.join,
                                style: const TextStyle(color: ColorRes.white, fontSize: 12, fontFamily: FontRes.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (model.settingAppData?.isSocialMedia == 1)
          InkWell(
            onTap: model.onPostBtnClick,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  gradient: StyleRes.linearGradient),
              child: Row(
                children: [
                  Image.asset(AssetRes.icPostIcon, width: 15, height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      S.current.posts.toUpperCase(),
                      style: TextStyle(color: ColorRes.white.withOpacity(0.8), fontFamily: FontRes.bold, fontSize: 11),
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget imageListArea(RegistrationUserData? userData) {
    return (userData?.images ?? []).isEmpty
        ? const SizedBox()
        : SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: (userData?.images ?? []).length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Images? image = (userData?.images ?? [])[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => model.onImageSelect(index),
                  child: Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        border: model.selectedImgIndex == index
                            ? Border.all(color: ColorRes.white.withOpacity(0.80), width: 2)
                            : Border.all(color: ColorRes.transparent, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        imageUrl: '${ConstRes.aImageBaseUrl}${image.image}',
                        cacheKey: '${ConstRes.aImageBaseUrl}${image.image}',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            CommonUI.profileImagePlaceHolder(name: CommonUI.fullName(userData?.fullname)),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

class LikeUnlikeBtn extends StatefulWidget {
  final VoidCallback onLikeBtnTap;
  final bool like;
  final int? userId;

  const LikeUnlikeBtn({Key? key, required this.like, required this.onLikeBtnTap, this.userId}) : super(key: key);

  @override
  State<LikeUnlikeBtn> createState() => _LikeUnlikeBtnState();
}

class _LikeUnlikeBtnState extends State<LikeUnlikeBtn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(milliseconds: 150), vsync: this, value: 1.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: PrefService.userId == widget.userId ? false : true,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          widget.onLikeBtnTap();
          _controller.reverse().then((value) => _controller.forward());
        },
        child: Container(
          height: 76,
          width: 76,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ColorRes.white.withOpacity(0.30)),
          child: Center(
            child: Container(
              height: 66,
              width: 66,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(shape: BoxShape.circle, color: ColorRes.white.withOpacity(0.50)),
              child: widget.like
                  ? ScaleTransition(
                      scale: Tween(begin: 0.7, end: 1.0)
                          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                      child: Image.asset(AssetRes.icFillFav),
                    )
                  : ScaleTransition(
                      scale: Tween(begin: 0.7, end: 1.0)
                          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                      child: Image.asset(AssetRes.icFav)),
              //Image.asset(AssetRes.like, height: 30.23, width: 33),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomMoreBtn extends StatefulWidget {
  final VoidCallback onMoreInfoTap;

  const BottomMoreBtn({Key? key, required this.onMoreInfoTap}) : super(key: key);

  @override
  State<BottomMoreBtn> createState() => _BottomMoreBtnState();
}

class _BottomMoreBtnState extends State<BottomMoreBtn> with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;
  double height = AppBar().preferredSize.height;

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
    return SizedBox(
      height: height,
      width: Get.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
              child: Container(
                width: Get.width,
                height: height - 15,
                decoration: BoxDecoration(
                  color: ColorRes.black.withOpacity(0.4),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                widget.onMoreInfoTap();
                HapticFeedback.lightImpact();
              },
              onTapUp: _tapUp,
              onTapDown: _tapDown,
              child: Transform.scale(
                scale: _scale,
                child: FittedBox(
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
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
                      S.current.moreInfo,
                      style: TextStyle(
                        color: ColorRes.white.withOpacity(0.80),
                        fontSize: 11,
                        fontFamily: FontRes.bold,
                        letterSpacing: 0.65,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageListArea extends StatefulWidget {
  final List<Images> imageList;
  final Function(int index) onImgSelect;
  final int selectedImgIndex;

  const ImageListArea({Key? key, required this.imageList, required this.onImgSelect, required this.selectedImgIndex})
      : super(key: key);

  @override
  State<ImageListArea> createState() => _ImageListAreaState();
}

class _ImageListAreaState extends State<ImageListArea> with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
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
    super.dispose();
    _controller?.dispose();
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
    return SizedBox(
      height: 58,
      child: ListView.builder(
        itemCount: widget.imageList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              widget.onImgSelect(index);
            },
            onTapDown: _tapDown,
            onTapUp: _tapUp,
            child: Transform.scale(
              scale: _scale,
              child: Container(
                height: 58,
                width: 58,
                margin: EdgeInsets.only(right: index != (widget.imageList.length - 1) ? 8.33 : 0),
                decoration: BoxDecoration(
                  border: widget.selectedImgIndex == index
                      ? Border.all(
                          color: ColorRes.white.withOpacity(0.80),
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('${ConstRes.aImageBaseUrl}${widget.imageList[index].image}'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
