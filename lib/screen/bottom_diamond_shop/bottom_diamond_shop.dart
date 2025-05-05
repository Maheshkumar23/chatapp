import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/bottom_diamond_shop/bottom_diamond_shop_view_model.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class BottomDiamondShop extends StatelessWidget {
  const BottomDiamondShop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomDiamondShopViewModel>.reactive(
      onViewModelReady: (model) => model.init(),
      viewModelBuilder: () => BottomDiamondShopViewModel(),
      builder: (context, model, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10, tileMode: TileMode.mirror),
              child: Stack(
                children: [
                  Container(width: Get.width, color: ColorRes.black.withOpacity(0.3)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    width: Get.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: S.current.diamondCap,
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 17,
                                  fontFamily: FontRes.regular,
                                ),
                              ),
                              TextSpan(
                                text: " ${S.current.shop}",
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 17,
                                  fontFamily: FontRes.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: model.isLoading
                              ? CommonUI.lottieWidget()
                              : model.products.isEmpty
                                  ? CommonUI.noData()
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: model.products.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.fromLTRB(17, 13, 9, 14),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: ColorRes.white.withOpacity(0.14),
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(AssetRes.diamond, height: 24, width: 24),
                                              const SizedBox(width: 7),
                                              Text(
                                                model.products[index].title,
                                                style: const TextStyle(
                                                  color: ColorRes.white,
                                                ),
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                borderRadius: BorderRadius.circular(30),
                                                onTap: () => model.makePurchase(model.products[index]),
                                                child: Container(
                                                  width: 131,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [ColorRes.lightOrange, ColorRes.darkOrange],
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      model.products[index].price,
                                                      style: const TextStyle(
                                                        color: ColorRes.white,
                                                        fontSize: 15,
                                                        fontFamily: FontRes.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                        ),
                        const SizedBox(height: 23),
                        SizedBox(
                          width: Get.width / 1.7,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.current.bayContinuingThePurchaseEtc,
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: FontRes.regular,
                                  ),
                                ),
                                TextSpan(
                                  text: S.current.terms,
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: FontRes.regular,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${S.current.and} ",
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: FontRes.regular,
                                  ),
                                ),
                                TextSpan(
                                  text: S.current.privacyPolicy,
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: FontRes.regular,
                                  ),
                                ),
                                TextSpan(
                                  text: " ${S.current.automatically} ",
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: FontRes.regular,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
