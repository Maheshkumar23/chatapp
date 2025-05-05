import 'package:flutter/material.dart';
import 'package:orange_ui/common/dashboard_top_bar.dart';
import 'package:orange_ui/screen/randoms_screen/randoms_screen_view_model.dart';
import 'package:orange_ui/screen/randoms_screen/widgets/bottom_buttons.dart';
import 'package:orange_ui/screen/randoms_screen/widgets/profile_pic_area.dart';
import 'package:stacked/stacked.dart';

class RandomsScreen extends StatelessWidget {
  const RandomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RandomsScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => RandomsScreenViewModel(),
      builder: (context, model, child) {
        return Column(
          children: [
            DashboardTopBar(
              onNotificationTap: model.onNotificationTap,
              onSearchTap: model.onSearchBtnTap,
              onLivesBtnClick: model.onLivesBtnClick,
              isDating: model.settingAppData?.isDating,
            ),
            const SizedBox(height: 27),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfilePicArea(
                      data: model.data,
                      isLoading: model.isLoading,
                    ),
                    BottomButtons(
                      bannerAd: model.bannerAd,
                      genderList: model.genderList,
                      selectedGender: model.selectedGender,
                      onGenderSelect: model.onGenderChange,
                      onMatchingStart: model.onStartMatchingTap,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
