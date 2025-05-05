import 'dart:io';

import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/model/get_diamond_pack.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/bottom_diamond_shop/bottom_diamond_shop.dart';
import 'package:orange_ui/screen/live_stream_application_screen/live_stream_application_screen.dart';
import 'package:orange_ui/screen/live_stream_history_screen/live_stream_history_screen.dart';
import 'package:orange_ui/screen/redeem_screen/redeem_screen.dart';
import 'package:orange_ui/screen/submit_redeem_screen/submit_redeem_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class LiveStreamDashBoardViewModel extends BaseViewModel {
  int eligible = 0;
  bool isLoading = false;
  RegistrationUserData? userData;
  String? coinValue;
  BannerAd? bannerAd;

  Appdata? settingAppData;

  void init() {
    getProfileApiCall();

    getSettingData();
  }

  void getProfileApiCall() {
    isLoading = true;
    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      userData = value?.data;
      eligible = value?.data?.canGoLive == 0
          ? 0
          : value?.data?.canGoLive == 1
              ? 1
              : 2;
      coinValue = value?.data?.wallet.toString() ?? '0';
      isLoading = false;
      notifyListeners();
    });
  }

  void onRedeemTap() {
    Get.to(() => const SubmitRedeemScreen(), arguments: coinValue)
        ?.then((value) {
      getProfileApiCall();
    });
  }

  void onAddCoinsBtnTap() {
    Get.bottomSheet(
      const BottomDiamondShop(),
      backgroundColor: ColorRes.transparent,
    ).then((value) {
      getProfileApiCall();
    });
  }

  void onDiamondPurchase(DiamondPack? data) {
    BubblyCamera.inAppPurchase(
        Platform.isAndroid ? data?.androidProductId : data?.iosProductId);
  }

  void onBackBtnTap() {
    Get.back();
  }

  void onHistoryBtnTap() {
    Get.to(() => const LiveStreamHistory());
  }

  void onRedeemBtnTap() {
    Get.to(() => const RedeemScreen());
  }

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      notifyListeners();
    },
        bannerId: Platform.isIOS
            ? settingAppData?.admobBannerIos
            : settingAppData?.admobBanner);
  }

  void onApplyBtnTap() {
    Get.to(() => const LiveStreamApplicationScreen())?.then((value) {
      getProfileApiCall();
    });
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      getBannerAd();
      notifyListeners();
    });
  }
}
