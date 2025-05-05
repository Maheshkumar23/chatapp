import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen_view_model.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class TopBar extends StatelessWidget {
  final UserDetailScreenViewModel model;

  const TopBar({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          height: 55,
          decoration: BoxDecoration(color: ColorRes.black.withOpacity(0.33), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              IconButton(
                onPressed: model.onBackTap,
                icon: const Icon(CupertinoIcons.back, color: ColorRes.darkOrange),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(model.userData?.fullname ?? 'Unknown',
                          style: const TextStyle(
                            color: ColorRes.white,
                            fontSize: 16,
                            fontFamily: FontRes.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ),
                    Text(
                      ' ${model.userData?.age ?? ''} ',
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Visibility(
                      visible: model.userData?.isVerified == 2,
                      child: Image.asset(AssetRes.tickMark, height: 16, width: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Visibility(
                visible: PrefService.userId != model.userData?.id,
                replacement: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.back,
                    color: ColorRes.transparent,
                  ),
                ),
                child: Visibility(
                  visible: !model.moreInfo,
                  replacement: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: ColorRes.transparent,
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) => model.onMoreBtnTap(value),
                    color: ColorRes.black.withOpacity(0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    itemBuilder: (BuildContext context) {
                      return {model.blockUnBlock, AppRes.report}.map(
                        (String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            textStyle: const TextStyle(fontFamily: FontRes.medium, color: ColorRes.white),
                            child: Text(
                              choice,
                              style: const TextStyle(fontFamily: FontRes.medium, color: ColorRes.white),
                            ),
                          );
                        },
                      ).toList();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      child: Image.asset(AssetRes.moreHorizontal, height: 10, width: 30, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
