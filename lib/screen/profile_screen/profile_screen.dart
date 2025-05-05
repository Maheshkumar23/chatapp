import 'package:flutter/material.dart';
import 'package:orange_ui/common/dashboard_top_bar.dart';
import 'package:orange_ui/screen/profile_screen/profile_screen_view_model.dart';
import 'package:orange_ui/screen/profile_screen/widget/profile_images_area.dart';
import 'package:stacked/stacked.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => ProfileScreenViewModel(),
      builder: (context, model, child) {
        return SizedBox(
          child: Column(
            children: [
              DashboardTopBar(
                  onNotificationTap: model.onNotificationTap,
                  onSearchTap: model.onSearchBtnTap,
                  onLivesBtnClick: model.onLivesBtnClick,
                  isDating: model.settingAppData?.isDating),
              ProfileImageArea(
                userData: model.userData,
                pageController: model.pageController,
                onEditProfileTap: model.onEditProfileTap,
                onMoreBtnTap: model.onMoreBtnTap,
                onImageTap: model.onImageTap,
                onInstagramTap: model.onInstagramTap,
                onFacebookTap: model.onFBTap,
                onYoutubeTap: model.onYoutubeTap,
                isLoading: model.isLoading,
                isVerified: model.userData?.isVerified == 2 ? true : false,
                isSocialBtnVisible: model.isSocialBtnVisible,
              ),
            ],
          ),
        );
      },
    );
  }
}
