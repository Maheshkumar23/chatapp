import 'package:flutter/material.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class LiveGridTopArea extends StatelessWidget {
  final VoidCallback onBackBtnTap;
  final VoidCallback onGoLiveTap;
  final RegistrationUserData? userData;

  const LiveGridTopArea({Key? key, required this.onBackBtnTap, required this.onGoLiveTap, this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 19),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: onBackBtnTap,
              child: Container(
                height: 37,
                width: 37,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: ColorRes.darkOrange.withOpacity(0.1), shape: BoxShape.circle),
                child: Image.asset(
                  AssetRes.backArrow,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Image.asset(AssetRes.themeLabel, height: 30, width: 100),
            Text(
              " ${S.current.live}",
              style: const TextStyle(
                fontSize: 20,
                color: ColorRes.black,
              ),
            ),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                if (userData?.isFake != 1) {
                  userData?.canGoLive == 0
                      ? CommonUI.snackBarWidget(
                          S.of(context).pleaseApplyForLiveStreamFromLivestreamDashboardFromProfile)
                      : userData?.canGoLive == 1
                          ? CommonUI.snackBarWidget(S.of(context).yourApplicationIsPendingPleaseWait)
                          : onGoLiveTap();
                } else {
                  onGoLiveTap();
                }
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorRes.lightOrange,
                      ColorRes.darkOrange,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetRes.sun,
                      height: 21,
                      width: 21,
                      color: ColorRes.white,
                    ),
                    const SizedBox(width: 7.62),
                    Text(
                      S.current.goLive,
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 14,
                        fontFamily: FontRes.extraBold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
