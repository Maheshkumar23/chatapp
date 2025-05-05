import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:orange_ui/screen/live_grid_screen/live_grid_screen.dart';
import 'package:orange_ui/screen/notification_screen/notification_screen.dart';
import 'package:orange_ui/screen/options_screen/options_screen.dart';
import 'package:orange_ui/screen/search_screen/search_screen.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenViewModel extends BaseViewModel {
  RegistrationUserData? userData;
  bool isLoading = false;
  int currentImageIndex = 0;
  late PageController pageController;

  Appdata? settingAppData;

  void init() {
    pageController = PageController(initialPage: 0, viewportFraction: 1.01)
      ..addListener(() {
        onMainImageChange();
      });
    getSettingData();
    profileScreenApiCall();
  }

  void profileScreenApiCall() async {
    isLoading = true;
    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      userData = value?.data;
      await PrefService.saveUser(value?.data);
      isLoading = false;
      notifyListeners();
    });
  }

  void onEditProfileTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to<RegistrationUserData>(() => EditProfileScreen(
              userData: userData,
            ))?.then((value) {
            if (value != null) {
              if (value.id == PrefService.userId) {
                userData = value;
              }
            }
            notifyListeners();
          });
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch ';
  }

  bool isSocialBtnVisible(String? socialLink) {
    if (socialLink != null) {
      return socialLink.contains("http://") || socialLink.contains("https://");
    } else {
      return false;
    }
  }

  void onInstagramTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : _launchUrl(userData?.instagram ?? '');
  }

  void onFBTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : _launchUrl(userData?.facebook ?? '');
  }

  void onYoutubeTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : _launchUrl(userData?.youtube ?? '');
  }

  void onSearchBtnTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => const SearchScreen());
  }

  void onLivesBtnClick() {
    Get.to(() => const LiveGridScreen());
  }

  void onMainImageChange() {
    if (pageController.page!.round() != currentImageIndex) {
      currentImageIndex = pageController.page!.round();
      notifyListeners();
    }
  }

  void onNotificationTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => const NotificationScreen());
  }

  void onImageTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => UserDetailScreen(
              userData: userData,
            ));
  }

  void onMoreBtnTap() {
    Get.to(() => const OptionScreen());
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      notifyListeners();
    });
  }
}
