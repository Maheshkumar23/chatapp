import 'package:flutter/material.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/options_screen/widgets/bottom_legal_area.dart';
import 'package:orange_ui/screen/options_screen/widgets/language_section.dart';
import 'package:orange_ui/screen/options_screen/widgets/options_center_area.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

import 'options_screen_view_model.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OptionalScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => OptionalScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                TopBarArea(title2: S.current.options),
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: MediaQuery.of(context).size.width,
                  color: ColorRes.grey5,
                ),
                Expanded(
                  child: model.isLoading
                      ? Center(child: CommonUI.lottieWidget())
                      : Padding(
                          padding: const EdgeInsets.only(left: 8, right: 9),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                OptionsCenterArea(
                                  notificationEnable: model.notificationEnable,
                                  goAnonymous: model.goAnonymous,
                                  showMeOnMap: model.showMeOnMap,
                                  onLiveStreamTap: model.onLiveStreamTap,
                                  onApplyForVerTap: model.onApplyForVerTap,
                                  onAnonymousTap: model.onGoAnonymousTap,
                                  onNotificationTap: model.onNotificationTap,
                                  onShowMeOnMapTap: model.onShowMeOnMapTap,
                                  verification: model.verificationProcess,
                                ),
                                const SizedBox(height: 20),
                                LanguageSection(
                                    navigateLanguage: model.navigateLanguage),
                                const SizedBox(height: 20),
                                BottomLegalArea(
                                  onPrivacyPolicyTap: () =>
                                      model.onNavigateWebViewScreen(0),
                                  onTermsOfUseTap: () =>
                                      model.onNavigateWebViewScreen(1),
                                  onLogoutTap: model.onLogoutTap,
                                  onDeleteAccountTap: model.onDeleteAccountTap,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
