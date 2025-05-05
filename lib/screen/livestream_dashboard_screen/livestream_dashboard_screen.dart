import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/livestream_dashboard_screen/livestream_dashboard_screen_view_model.dart';
import 'package:orange_ui/screen/livestream_dashboard_screen/widgets/center_area_livestream_dashboard.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class LiveStreamDashBoard extends StatelessWidget {
  const LiveStreamDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamDashBoardViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => LiveStreamDashBoardViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: Column(
            children: [
              TopBarArea(
                  title: S.current.liveStreamCap, title2: S.current.dashboard),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                width: MediaQuery.of(context).size.width,
                color: ColorRes.grey5,
              ),
              model.isLoading
                  ? Expanded(child: CommonUI.lottieWidget())
                  : CenterAreaLiveStreamDashBoard(
                      onRedeemTap: model.onRedeemTap,
                      eligible: model.eligible,
                      onHistoryBtnTap: model.onHistoryBtnTap,
                      onRedeemBtnTap: model.onRedeemBtnTap,
                      onAddCoinsBtnTap: model.onAddCoinsBtnTap,
                      onApplyBtnTap: model.onApplyBtnTap,
                      wallet: model.userData?.wallet,
                      totalCollection:
                          model.userData?.totalCollected.toString(),
                      totalStream: model.userData?.totalStreams.toString(),
                      appdata: model.settingAppData,
                    ),
              const SizedBox(height: 10),
              if (model.bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: model.bannerAd?.size.width.toDouble(),
                  height: model.bannerAd?.size.height.toDouble(),
                  child: AdWidget(ad: model.bannerAd!),
                ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}
