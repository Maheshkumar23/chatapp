import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class BottomPurchaseShirt extends StatelessWidget {
  final List<Gifts>? diamondList;
  final VoidCallback onGemsSubmit;
  final VoidCallback onAddDiamonds;
  final Function(Gifts? data) onGiftTap;
  final VoidCallback onGiftDiamondEmpty;
  final int? diamond;
  final RegistrationUserData? userData;

  const BottomPurchaseShirt(
      {Key? key,
      required this.diamondList,
      required this.onGemsSubmit,
      required this.onAddDiamonds,
      required this.onGiftTap,
      required this.diamond,
      required this.onGiftDiamondEmpty,
      required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3,
          sigmaY: 3,
          tileMode: TileMode.mirror,
        ),
        child: Stack(
          children: [
            Container(
              width: Get.width,
              // height: 425,
              color: const Color(0x08000000),
            ),
            Container(
              width: Get.width,
              height: Get.width * 1.063,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: ColorRes.black.withOpacity(0.33),
              ),
              child: Column(
                children: [
                  topButtons(),
                  const SizedBox(height: 17),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: diamondList?.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          if (userData?.isFake != 1) {
                            diamondList![index].coinPrice! <= diamond!.toInt()
                                ? onGiftTap(diamondList?[index])
                                : onGiftDiamondEmpty();
                          } else {
                            if (Get.isBottomSheetOpen == true) {
                              Get.back();
                            }
                            CommonUI.snackBarWidget(S.of(context).youAreFakeUser);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorRes.white.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network('${ConstRes.aImageBaseUrl}${diamondList?[index].image}',
                                  height: 45.5,
                                  width: 52.45,
                                  fit: BoxFit.cover,
                                  color: diamond == null || diamondList![index].coinPrice! > diamond!.toInt()
                                      ? ColorRes.black.withOpacity(0.2)
                                      : null),
                              const SizedBox(height: 2.5),
                              Text(
                                "${diamondList?[index].coinPrice} 💎",
                                style: TextStyle(
                                  color: diamond == null || diamondList![index].coinPrice! > diamond!.toInt()
                                      ? ColorRes.black.withOpacity(0.2)
                                      : ColorRes.white,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topButtons() {
    return Row(
      children: [
        InkWell(
          onTap: onAddDiamonds,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 35,
            width: 81,
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
                "💎 ${NumberFormat.compact(locale: 'en').format(diamond ?? 0)}",
                style: const TextStyle(
                  color: ColorRes.white,
                  fontSize: 13,
                  fontFamily: FontRes.regular,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        InkWell(
          onTap: onAddDiamonds,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 35,
            width: 131,
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
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.current.add,
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 13,
                        fontFamily: FontRes.regular,
                      ),
                    ),
                    TextSpan(
                      text: " ${S.current.diamonds}",
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 13,
                        fontFamily: FontRes.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
