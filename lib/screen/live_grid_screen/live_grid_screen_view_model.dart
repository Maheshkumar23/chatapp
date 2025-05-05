import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/live_stream.dart';
import 'package:orange_ui/model/generate_token.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/bottom_diamond_shop/bottom_diamond_shop.dart';
import 'package:orange_ui/screen/explore_screen/widgets/reverse_swipe_dialog.dart';
import 'package:orange_ui/screen/live_grid_screen/widgets/live_stream_end_sheet.dart';
import 'package:orange_ui/screen/person_streaming_screen/person_streaming_screen.dart';
import 'package:orange_ui/screen/random_streming_screen/random_streaming_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class LiveGridScreenViewModel extends BaseViewModel {
  RegistrationUserData? registrationUser;
  String? identity;
  List<LiveStreamUser> userData = [];
  List<String?> userEmail = [];
  bool isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late CollectionReference collection;
  StreamSubscription<QuerySnapshot<LiveStreamUser>>? subscription;
  int walletCoin = 0;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  Appdata? settingAppData;

  void init() {
    getProfileAPi();

    getSettingData();
  }

  void onBackBtnTap() {
    if (interstitialAd == null) {
      Get.back();
    } else {
      interstitialAd?.show().whenComplete(() {
        Get.back();
      });
    }
  }

  void initInterstitialAds() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    }, adMobIntId: Platform.isIOS ? settingAppData?.admobIntIos : settingAppData?.admobInt);
  }

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      notifyListeners();
    }, bannerId: Platform.isIOS ? settingAppData?.admobBannerIos : settingAppData?.admobBanner);
  }

  void goLiveBtnClick() {
    registrationUser?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.dialog(
            ConfirmationDialog(
              onTap: onGoLiveYesBtnTap,
              description: S.current.doYouReallyWantToLive,
              dialogSize: 2,
              textButton: S.current.goLive,
              textImage: '',
              padding: const EdgeInsets.symmetric(horizontal: 40),
            ),
          );
  }

  Future<void> onGoLiveYesBtnTap() async {
    Get.back();
    ApiProvider().callPost(
        completion: (response) async {
          GenerateToken token = GenerateToken.fromJson(response);
          if (token.status == true) {
            LiveStreamUser liveStreamUser = LiveStreamUser(
                userId: registrationUser?.id,
                fullName: registrationUser?.fullname,
                userImage: CommonFun.getProfileImage(images: registrationUser?.images),
                agoraToken: token.token,
                id: DateTime.now().millisecondsSinceEpoch,
                collectedDiamond: 0,
                hostIdentity: registrationUser?.identity,
                isVerified: false,
                joinedUser: [],
                address: registrationUser?.live,
                age: registrationUser?.age,
                watchingCount: 0);

            // You can request multiple permissions at once.
            Map<Permission, PermissionStatus> statuses = await [
              Permission.camera,
              Permission.microphone,
            ].request();

            if (statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted) {
              Get.to(() => RandomStreamingScreen(
                    userData: registrationUser,
                    liveStreamUser: liveStreamUser,
                    settingData: settingAppData,
                  ))?.then((value) async {
                notifyListeners();
              });
            } else {
              CommonUI.snackBar(message: S.current.userDidNotAllowCameraAndMicrophonePermission);
            }
          } else {
            CommonUI.snackBar(message: token.message ?? '');
          }
        },
        url: Urls.aGenerateAgoraToken,
        param: {Urls.channelName: registrationUser?.identity});
  }

  void getLiveUsers() {
    isLoading = true;
    collection = db.collection(FirebaseRes.liveHostList);
    subscription = collection
        .withConverter(
          fromFirestore: (snapshot, options) => LiveStreamUser.fromJson(snapshot.data()),
          toFirestore: (LiveStreamUser value, options) {
            return value.toJson();
          },
        )
        .snapshots()
        .listen((element) {
      userData = [];
      for (int i = 0; i < element.docs.length; i++) {
        userData.add(element.docs[i].data());
      }
      isLoading = false;
      notifyListeners();
    });
  }

  void onLiveStreamProfileTap(LiveStreamUser? user) {
    if (registrationUser?.isBlock == 1) {
      return CommonUI.snackBarWidget(S.current.userBlock);
    } else {
      String authString = '${ConstRes.customerId}:${ConstRes.customerSecret}';
      String authToken = base64.encode(authString.codeUnits);
      ApiProvider().agoraListStreamingCheck(user?.hostIdentity ?? '', authToken, ConstRes.agoraAppId).then((value) {
        if (value.data?.channelExist == true || value.data!.broadcasters!.isNotEmpty) {
          if (registrationUser?.isFake != 1) {
            if ((settingAppData?.liveWatchingPrice ?? 0) < walletCoin) {
              Get.dialog(
                ReverseSwipeDialog(
                    onCancelTap: onBackBtnTap,
                    onContinueTap: (isSelected) {
                      Get.back();
                      minusCoinApi().then((value) {
                        onImageTap(user);
                      });
                    },
                    isCheckBoxVisible: false,
                    walletCoin: walletCoin,
                    title1: S.current.liveCap,
                    title2: S.current.streamCap,
                    dialogDisc: AppRes.liveStreamDisc(settingAppData?.liveWatchingPrice ?? 0),
                    coinPrice: '${settingAppData?.liveWatchingPrice ?? 0}'),
              );
            } else {
              Get.dialog(
                EmptyWalletDialog(
                  onCancelTap: onBackBtnTap,
                  onContinueTap: () {
                    Get.back();
                    Get.bottomSheet(
                      const BottomDiamondShop(),
                    );
                  },
                  walletCoin: walletCoin,
                ),
              );
            }
          } else {
            onImageTap(user);
          }
        } else {
          Get.bottomSheet(LiveStreamEndSheet(
            name: user?.fullName ?? '',
            onExitBtn: () async {
              Get.back();
              db.collection(FirebaseRes.liveHostList).doc('${user?.userId}').delete();
              final batch = db.batch();
              var collection = db.collection(FirebaseRes.liveHostList).doc('${user?.userId}').collection(FirebaseRes.comments);
              var snapshots = await collection.get();
              for (var doc in snapshots.docs) {
                batch.delete(doc.reference);
              }
              await batch.commit();
            },
          ));
        }
      });
    }
  }

  Future<void> getProfileAPi() async {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      registrationUser = value?.data;
      walletCoin = (value?.data?.wallet ?? 0);
      notifyListeners();
    });
    getLiveUsers();
  }

  Future<void> minusCoinApi() async {
    CommonUI.getLottieLoader();
    await ApiProvider().minusCoinFromWallet(settingAppData?.liveWatchingPrice ?? 0);
    Get.back();
    getProfileAPi();
  }

  void onImageTap(LiveStreamUser? liveStreamUser) {
    userEmail.add(registrationUser?.identity);
    final liveStreamUserId = liveStreamUser?.userId;
    if (liveStreamUserId != null) {
      final newWatchingCount = (liveStreamUser?.watchingCount ?? 0) + 1;
      final newCollectedDiamond = (liveStreamUser?.collectedDiamond ?? 0) + (settingAppData?.liveWatchingPrice ?? 0).toInt();

      db.collection(FirebaseRes.liveHostList).doc('$liveStreamUserId').update({FirebaseRes.watchingCount: newWatchingCount, FirebaseRes.joinedUser: FieldValue.arrayUnion(userEmail), FirebaseRes.collectedDiamond: newCollectedDiamond}).then((_) {
        Get.to(() => PersonStreamingScreen(
              liveStreamUser: liveStreamUser,
              settingAppData: settingAppData,
            ))?.then(
          (value) {
            getProfileAPi();
          },
        );
      }).catchError((error) {
        log("Error occurred while updating live stream data: $error");
      });
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      getBannerAd();
      initInterstitialAds();
      notifyListeners();
    });
  }
}
