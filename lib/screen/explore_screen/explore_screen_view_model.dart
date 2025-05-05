import 'dart:io';

import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/bottom_diamond_shop/bottom_diamond_shop.dart';
import 'package:orange_ui/screen/live_grid_screen/live_grid_screen.dart';
import 'package:orange_ui/screen/map_screen/map_screen.dart';
import 'package:orange_ui/screen/notification_screen/notification_screen.dart';
import 'package:orange_ui/screen/search_screen/search_screen.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/pref_res.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/reverse_swipe_dialog.dart';

class ExploreScreenViewModel extends BaseViewModel {
  int imageIndex = 0;
  bool isLoading = false;
  SwiperController userController = SwiperController();
  List<RegistrationUserData> userList = [];
  int currentUserIndex = 0;
  int? walletCoin = 0;
  RegistrationUserData? userData;
  bool isSelected = false;
  InterstitialAd? interstitialAd;
  int count = 0;

  Appdata? settingAppData;

  void init() {
    exploreScreenApiCall();
    prefSetting();
  }

  void prefSetting() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      initInterstitialAds();
      notifyListeners();
    });
  }

  Future<void> exploreScreenApiCall() async {
    isLoading = true;
    ApiProvider().getExplorePageProfileList().then((value) async {
      userList = value.data ?? [];
      isLoading = false;
      getProfileAPi();
      notifyListeners();
    });
  }

  Future<void> getProfileAPi() async {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      userData = value?.data;
      walletCoin = value?.data?.wallet;
      isSelected = await PrefService.getDialog(PrefConst.isDialogDialog) ?? false;
      await PrefService.saveUser(value?.data);
    });
  }

  bool isSocialBtnVisible(String? socialLink) {
    if (socialLink != null) {
      return socialLink.contains(AppRes.isHttp) || socialLink.contains(AppRes.isHttps);
    } else {
      return false;
    }
  }

  Future<void> minusCoinApi() async {
    await ApiProvider().minusCoinFromWallet(settingAppData?.reverseSwipePrice);
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
    )) throw '${S.current.couldNotLaunch} ';
  }

  void onSocialBtnTap(int type) {
    if (type == 0) {
      _launchUrl(userList[currentUserIndex].youtube ?? '');
    } else if (type == 1) {
      _launchUrl(userList[currentUserIndex].facebook ?? '');
    } else if (type == 2) {
      _launchUrl(userList[currentUserIndex].instagram ?? '');
    }
  }

  void onPlayButtonTap() async {
    if (userData == null) {
      return;
    }
    if (userData?.isBlock == 1) {
      return CommonUI.snackBarWidget(S.current.userBlock);
    } else {
      if (userData?.isFake != 1) {
        if ((settingAppData?.reverseSwipePrice ?? 0) <= walletCoin! && walletCoin != 0) {
          !isSelected
              ? Get.dialog(
                  ReverseSwipeDialog(
                    isCheckBoxVisible: true,
                    walletCoin: walletCoin,
                    title1: S.current.reverse,
                    title2: S.current.swipe,
                    dialogDisc: AppRes.reverseSwipeDisc(settingAppData?.reverseSwipePrice ?? 0),
                    coinPrice: '${settingAppData?.reverseSwipePrice ?? 0}',
                    onCancelTap: () {
                      onBackBtnTap();
                    },
                    onContinueTap: (isSelected) {
                      PrefService.setDialog(PrefConst.isDialogDialog, isSelected);
                      minusCoinApi().then(
                        (value) {
                          onBackBtnTap();
                          userController.previous();
                        },
                      );
                    },
                  ),
                ).then(
                  (value) {
                    getProfileAPi();
                  },
                )
              : onPreviousBtnTap();
        } else {
          Get.dialog(
            EmptyWalletDialog(
              onCancelTap: onBackBtnTap,
              onContinueTap: () {
                Get.back();
                Get.bottomSheet(const BottomDiamondShop());
              },
              walletCoin: walletCoin,
            ),
          );
        }
      } else {
        userController.previous();
      }
    }
  }

  void onPreviousBtnTap() {
    minusCoinApi().then((value) {
      getProfileAPi();
      userController.previous(animation: true);
    });
  }

  void onBackBtnTap() {
    Get.back();
  }

  void onNextButtonTap() {
    count++;
    if (count == 5) {
      if (interstitialAd != null) {
        interstitialAd?.show().then((value) {
          count = 0;
          userController.next(animation: true);
          initInterstitialAds();
        });
      }
    } else {
      userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : userController.next(animation: true);
    }
  }

  void initInterstitialAds() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    }, adMobIntId: Platform.isIOS ? settingAppData?.admobIntIos : settingAppData?.admobInt);
  }

  void onIndexChange(int index) {
    currentUserIndex = index;
    notifyListeners();
  }

  void onNotificationTap() {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const NotificationScreen());
  }

  void onLivesBtnClick() {
    Get.to(() => const LiveGridScreen());
  }

  void onSearchTap() {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const SearchScreen());
  }

  void onTitleTap() {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const MapScreen());
  }

  void onImageTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(
            () => UserDetailScreen(userData: userList[currentUserIndex]),
          );
  }

  void onLiveBtnTap() {
    // Get.to(() => const PremiumScreen());
  }

  void onEyeButtonTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => UserDetailScreen(
              showInfo: true,
              userData: userList[currentUserIndex],
            ));
  }

  @override
  void dispose() {
    userController.dispose();
    super.dispose();
  }
}
