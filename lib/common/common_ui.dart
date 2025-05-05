import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class CommonUI {
  static Widget profileImagePlaceHolder(
      {required String? name, double heightWidth = 0, double? borderRadius, Color? color, double? fontSize}) {
    return Container(
      width: heightWidth,
      height: heightWidth,
      decoration: BoxDecoration(
          color: ColorRes.darkOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(borderRadius ?? 50)),
      alignment: Alignment.center,
      child: Text(
        (name == null || name.isEmpty ? 'Unknown' : name)[0].toUpperCase(),
        style: TextStyle(
            fontFamily: FontRes.semiBold,
            fontSize: fontSize ?? (heightWidth / 2),
            color: (color ?? ColorRes.darkOrange).withOpacity(.5)),
      ),
    );
  }

  static Widget postPlaceHolder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(color: ColorRes.lightGrey),
      alignment: Alignment.center,
      child: Image.asset(
        AssetRes.icPostPlaceholder,
        height: 200 / 3,
        color: ColorRes.grey,
      ),
    );
  }

  static String fullName(String? fullName) {
    return fullName ?? 'Unknown';
  }

  static String userName(String? userName) {
    return '@${userName ?? 'unknown'}';
  }

  static Widget noData({String? title}) {
    return Center(
      child: Text(
        title ?? S.current.noData,
        style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 18, color: ColorRes.dimGrey3),
      ),
    );
  }

  static Future<void> lottieLoader() {
    return showDialog(
        context: Get.context!,
        builder: (context) {
          return Center(child: Lottie.asset(AssetRes.loadingLottie, height: 100, width: 100));
        },
        barrierLabel: '');
  }

  static Future<void> getLottieLoader({bool isBarrierDismissible = true}) {
    return Get.dialog(
        Center(
          child: Lottie.asset(AssetRes.loadingLottie, height: 100, width: 100),
        ),
        barrierDismissible: isBarrierDismissible);
  }

  static Widget lottieWidget() {
    return Center(
      child: Lottie.asset(AssetRes.loadingLottie, height: 100, width: 100),
    );
  }

  static void snackBarWidget(String? titleName) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(
          SnackBar(
            content: Text(
              (titleName ?? '').capitalizeFirst ?? '',
              style: const TextStyle(overflow: TextOverflow.ellipsis),
              maxLines: 2,
            ),
            backgroundColor: ColorRes.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 2500),
          ),
        )
        .closed
        .then((value) => ScaffoldMessenger.of(Get.context!).clearSnackBars());
  }

  static void snackBar({required String message}) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        style: const TextStyle(color: ColorRes.white),
      ),
      backgroundColor: ColorRes.black,
    );
  }
}
