import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/live_grid_screen/live_grid_screen.dart';
import 'package:orange_ui/screen/notification_screen/notification_screen.dart';
import 'package:orange_ui/screen/randoms_search_screen/randoms_search_screen.dart';
import 'package:orange_ui/screen/search_screen/search_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';

class RandomsScreenViewModel extends BaseViewModel {
  RegistrationUserData? data;
  List<String> genderList = [S.current.boys, S.current.both, S.current.girls];
  int selectedGender = 3;
  bool isLoading = false;
  BannerAd? bannerAd;

  Appdata? settingAppData;

  void init() {
    getProfileApiCall();
    getSettingData();
  }

  void getProfileApiCall() async {
    isLoading = true;
    PrefService.getUserData().then((value) {
      data = value;
      isLoading = false;
      notifyListeners();
    });
  }

  void onNotificationTap() {
    data?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const NotificationScreen());
  }

  void onSearchBtnTap() {
    data?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const SearchScreen());
  }

  void onLivesBtnClick() {
    Get.to(() => const LiveGridScreen());
  }

  void onGenderChange(int value) {
    data?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : selectedGender = value;
    notifyListeners();
  }

  void onStartMatchingTap() {
    data?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => RandomsSearchScreen(selectedGender: selectedGender, profileImage: CommonFun.getProfileImage(images: data?.images)));
  }

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      notifyListeners();
    }, bannerId: Platform.isIOS ? settingAppData?.admobBannerIos : settingAppData?.admobBanner);
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      getBannerAd();
      notifyListeners();
    });
  }
}
