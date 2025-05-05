import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/notification_screen/widgets/admin_notificaiton_page.dart';
import 'package:orange_ui/screen/notification_screen/widgets/personal_notification.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

import 'notification_screen_view_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => NotificationScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBarArea(
                title2: S.current.notification,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                height: 1,
                width: Get.width,
                color: ColorRes.grey5,
              ),
              const SizedBox(height: 11),
              Container(
                height: 50,
                width: 254,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorRes.aquaHaze,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => model.onTabChange(0),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        width: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: model.tabIndex == 0 ? ColorRes.darkGrey : ColorRes.aquaHaze,
                        ),
                        child: Center(
                          child: Text(
                            S.current.personal,
                            style: TextStyle(
                              color: model.tabIndex == 0 ? ColorRes.white : ColorRes.darkGrey,
                              fontFamily: FontRes.regular,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => model.onTabChange(1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 40,
                        width: 112,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: model.tabIndex == 1 ? ColorRes.darkGrey : ColorRes.aquaHaze,
                        ),
                        child: Center(
                          child: Text(
                            S.current.platform,
                            style: TextStyle(
                              color: model.tabIndex == 1 ? ColorRes.white : ColorRes.darkGrey,
                              fontFamily: FontRes.regular,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              model.isLoading
                  ? Expanded(
                      child: Center(
                          child: Lottie.asset(AssetRes.loadingLottie, width: 100, height: 100)),
                    )
                  : Expanded(
                      child: model.tabIndex == 0
                          ? model.isUserLoading
                              ? CommonUI.lottieWidget()
                              : PersonalNotificationPage(
                                  userNotification: model.userNotification,
                                  controller: model.userScrollController,
                                  onUserTap: model.onUserTap,
                                )
                          : model.isLoading
                              ? CommonUI.lottieWidget()
                              : AdminNotificationPage(
                                  adminNotification: model.adminNotification,
                                  controller: model.adminScrollController,
                                ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
