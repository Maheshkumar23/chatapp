import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/chat_screen/chat_screen.dart';
import 'package:orange_ui/screen/live_grid_screen/live_grid_screen.dart';
import 'package:orange_ui/screen/notification_screen/notification_screen.dart';
import 'package:orange_ui/screen/search_screen/search_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:stacked/stacked.dart';

class MessageScreenViewModel extends BaseViewModel {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Conversation> userList = [];
  Conversation? conversation;
  bool isLoading = false;
  StreamSubscription<QuerySnapshot<Conversation>>? subscription;
  RegistrationUserData? userData;
  BannerAd? bannerAd;

  Appdata? settingAppData;

  void init() {
    getSettingData();
    getChatUsers();
    getProfileApi();
  }

  void onNotificationTap() {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const NotificationScreen());
  }

  void getProfileApi() {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) {
      userData = value?.data;
      notifyListeners();
    });
  }

  void onSearchTap() {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => const SearchScreen());
  }

  void onLivesBtnClick() {
    Get.to(() => const LiveGridScreen());
  }

  void onUserTap(Conversation conversation) {
    userData?.isBlock == 1 ? CommonUI.snackBarWidget(S.current.userBlock) : Get.to(() => ChatScreen(conversation: conversation));
  }

  void getChatUsers() {
    isLoading = true;
    PrefService.getUserData().then((value) {
      subscription = db
          .collection(FirebaseRes.userChatList)
          .doc('${value?.id}')
          .collection(FirebaseRes.userList)
          .orderBy(FirebaseRes.time, descending: true)
          .withConverter(fromFirestore: Conversation.fromFirestore, toFirestore: (Conversation value, options) => value.toFirestore())
          .snapshots()
          .listen((element) {
        userList = [];
        for (int i = 0; i < element.docs.length; i++) {
          if (element.docs[i].data().isDeleted == false) {
            userList.add(element.docs[i].data());
            notifyListeners();
          }
        }
        isLoading = false;
        notifyListeners();
      });
    });
  }

  void getBannerAd() {
    CommonFun.bannerAd((ad) {
      bannerAd = ad as BannerAd;
      notifyListeners();
    }, bannerId: Platform.isIOS ? settingAppData?.admobBannerIos : settingAppData?.admobBanner);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void onLongPress(Conversation? conversation) {
    HapticFeedback.vibrate();
    Get.dialog(ConfirmationDialog(
      onTap: () {
        db.collection(FirebaseRes.userChatList).doc(userData?.identity).collection(FirebaseRes.userList).doc(conversation?.user?.userIdentity).update({
          FirebaseRes.isDeleted: true,
          FirebaseRes.deletedId: '${DateTime.now().millisecondsSinceEpoch}',
          FirebaseRes.block: false,
          FirebaseRes.blockFromOther: false,
        }).then((value) {
          Get.back();
        });
      },
      description: S.current.messageWillOnlyBeRemoved,
      dialogSize: 1.9,
      padding: const EdgeInsets.symmetric(horizontal: 40),
    ));
    notifyListeners();
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      getBannerAd();
      notifyListeners();
    });
  }
}
