import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class CenterAreaLiveStreamDashBoard extends StatelessWidget {
  final VoidCallback onRedeemTap;
  final int eligible;
  final VoidCallback onHistoryBtnTap;
  final VoidCallback onRedeemBtnTap;
  final VoidCallback onAddCoinsBtnTap;
  final VoidCallback onApplyBtnTap;
  final int? wallet;
  final String? totalStream;
  final String? totalCollection;
  final Appdata? appdata;

  const CenterAreaLiveStreamDashBoard({
    Key? key,
    required this.onRedeemTap,
    required this.eligible,
    required this.onHistoryBtnTap,
    required this.onRedeemBtnTap,
    required this.onAddCoinsBtnTap,
    required this.onApplyBtnTap,
    required this.wallet,
    required this.totalCollection,
    required this.totalStream,
    this.appdata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int coinValue = wallet ?? 0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 9),
        child: Column(
          children: [
            Visibility(
              visible: eligible == 0
                  ? true
                  : eligible == 1
                      ? false
                      : false,
              child: Stack(
                children: [
                  SizedBox(
                    height: 54,
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AssetRes.map1),
                    ),
                  ),
                  Container(
                    height: 54,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: ColorRes.darkGrey5.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    height: 54,
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15, tileMode: TileMode.mirror),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.current.getAccess,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontRes.bold,
                                  color: ColorRes.darkGrey,
                                ),
                              ),
                              InkWell(
                                onTap: onApplyBtnTap,
                                child: Container(
                                  height: 36.17,
                                  width: 112,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: ColorRes.darkOrange.withOpacity(0.15)),
                                  child: Center(
                                    child: Text(
                                      S.current.apply,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: ColorRes.darkOrange,
                                        fontFamily: FontRes.semiBold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                SizedBox(
                  height: 54,
                  width: Get.width,
                  child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset(AssetRes.map1)),
                ),
                Container(
                  height: 54,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: ColorRes.darkGrey5.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                SizedBox(
                  height: 54,
                  width: Get.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13, right: 3),
                        child: Row(
                          children: [
                            Image.asset(
                              AssetRes.sun,
                              color: ColorRes.lightOrange,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(width: 13),
                            Text(
                              S.current.eligibility,
                              style: const TextStyle(fontSize: 15, color: ColorRes.darkGrey),
                            ),
                            const Spacer(),
                            Container(
                              height: 36.17,
                              width: 115,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: eligible == 0
                                    ? ColorRes.darkOrange.withOpacity(0.20)
                                    : eligible == 1
                                        ? ColorRes.lightOrange.withOpacity(0.20)
                                        : ColorRes.lightGreen.withOpacity(0.20),
                              ),
                              child: Center(
                                child: Text(
                                  eligible == 0
                                      ? S.current.notEligible
                                      : eligible == 1
                                          ? S.current.pending
                                          : S.current.eligible,
                                  style: TextStyle(
                                    color: eligible == 0
                                        ? ColorRes.darkOrange
                                        : eligible == 1
                                            ? ColorRes.lightOrange
                                            : ColorRes.green2,
                                    fontSize: 12,
                                    fontFamily: FontRes.semiBold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1 / .55,
              child: Stack(
                children: [
                  SizedBox(
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AssetRes.map2),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: ColorRes.darkGrey5.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19, top: 18, right: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.current.wallet,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ColorRes.lightGrey5,
                                    letterSpacing: 2,
                                    fontFamily: FontRes.semiBold,
                                  ),
                                ),
                                const Spacer(),
                                Image.asset(
                                  AssetRes.themeLabel,
                                  height: 23,
                                  width: 76,
                                ),
                                Text(
                                  S.current.liveCAp,
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            const Spacer(),
                            Text(
                              wallet.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: FontRes.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const Spacer(),
                            LinearProgressIndicator(
                              backgroundColor: ColorRes.dimGrey7,
                              value: appdata?.minThreshold == 0 ? 0 : coinValue / (appdata?.minThreshold ?? 0),
                              valueColor: const AlwaysStoppedAnimation<Color>(ColorRes.darkOrange),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${S.current.threshold}${appdata?.minThreshold}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ColorRes.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: coinValue >= (appdata?.minThreshold ?? 0) ? onRedeemTap : () {},
                                  child: Container(
                                    height: 41,
                                    width: 141,
                                    decoration: coinValue >= (appdata?.minThreshold ?? 0)
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                ColorRes.lightOrange,
                                                ColorRes.darkOrange,
                                              ],
                                            ),
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: ColorRes.lightGrey6.withOpacity(0.20),
                                          ),
                                    child: Center(
                                      child: Text(
                                        S.current.redeemCap,
                                        style: TextStyle(
                                          color: coinValue >= (appdata?.minThreshold ?? 0)
                                              ? ColorRes.white
                                              : ColorRes.darkGrey9,
                                          fontSize: 12,
                                          fontFamily: FontRes.semiBold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: onAddCoinsBtnTap,
                                  child: Container(
                                    height: 41,
                                    width: 141,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
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
                                        S.current.addCoins,
                                        style: const TextStyle(
                                          color: ColorRes.white,
                                          fontSize: 12,
                                          fontFamily: FontRes.semiBold,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 11),
            AspectRatio(
              aspectRatio: 1 / 0.37,
              child: Stack(
                children: [
                  SizedBox(
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AssetRes.map2),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: ColorRes.darkGrey5.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 19, top: 18, right: 13, bottom: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.current.totalStream,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: ColorRes.lightGrey5,
                                      fontFamily: FontRes.semiBold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  Text(
                                    S.current.totalCollection,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: ColorRes.lightGrey5,
                                      fontFamily: FontRes.semiBold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    NumberFormat.compactCurrency(decimalDigits: 0, name: '').format(
                                      int.parse(totalStream ?? '0'),
                                    ),
                                    style: const TextStyle(
                                      color: ColorRes.darkGrey,
                                      letterSpacing: 3,
                                      fontSize: 19,
                                      fontFamily: FontRes.bold,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.compactCurrency(decimalDigits: 2, name: '').format(
                                      int.parse(totalCollection ?? '0'),
                                    ),
                                    style: const TextStyle(
                                      color: ColorRes.darkGrey,
                                      letterSpacing: 3,
                                      fontSize: 19,
                                      fontFamily: FontRes.bold,
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: onHistoryBtnTap,
                                    child: Container(
                                      height: 37.8,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorRes.lightGrey6.withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          S.current.history,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: ColorRes.darkGrey9,
                                            fontFamily: FontRes.semiBold,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: onRedeemBtnTap,
                                    child: Container(
                                      // height: 38,
                                      //width: 150,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: ColorRes.lightGrey6.withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          S.current.redeemRequests,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: ColorRes.darkGrey9,
                                            fontFamily: FontRes.semiBold,
                                            letterSpacing: 0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
