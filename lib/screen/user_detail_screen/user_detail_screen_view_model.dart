import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/model/chat_and_live_stream/live_stream.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/follow_user.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/chat_screen/chat_screen.dart';
import 'package:orange_ui/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:orange_ui/screen/person_streaming_screen/person_streaming_screen.dart';
import 'package:orange_ui/screen/post_screen/post_screen.dart';
import 'package:orange_ui/screen/user_report_screen/report_sheet.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

class UserDetailScreenViewModel extends BaseViewModel {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isLoading = false;
  bool moreInfo = false;
  bool like = false;
  int selectedImgIndex = 0;
  bool save = false;
  String reason = S.current.cyberbullying;
  bool showDropdown = false;
  LiveStreamUser? liveStreamUser;
  List<String?> joinedUsers = [];
  RegistrationUserData? userData;
  RegistrationUserData? myUserData;
  int? userId;
  String? latitude = '';
  String? longitude = '';
  double distance = 0.0;
  String blockUnBlock = S.current.block;
  InterstitialAd? interstitialAd;
  bool isFollow = true;

  Appdata? settingAppData;

  UserDetailScreenViewModel({this.userId, this.userData});

  void init(bool? showInfo) {
    // if (Get.arguments is int) {
    //   userId = Get.arguments;
    // } else if (Get.arguments is String) {
    //   userId = int.parse(Get.arguments);
    // } else {
    //   userData = Get.arguments;
    // }
    getSettingData();
    userDetailApiCall();
  }

  void shareLink(RegistrationUserData? userData) async {
    BranchUniversalObject buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: userData?.fullname ?? '',
      imageUrl: CommonFun.getProfileImage(images: userData?.images),
      contentDescription: userData?.about ?? '',
      publiclyIndex: true,
      locallyIndex: true,
      contentMetadata: BranchContentMetaData()..addCustomMetadata('user_id', userData?.id),
    );
    BranchLinkProperties lp = BranchLinkProperties(channel: 'facebook', feature: 'sharing', stage: 'new share', tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    BranchResponse response = await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      Share.share(
        '${S.current.checkOutThisProfile} ${response.result}',
        subject: '${S.current.look} ${userData?.fullname}',
      );
    } else {}
  }

  List<String> interestList = [];

  Future<void> userProfileApiCall() async {
    isLoading = true;
    await ApiProvider().getProfile(userID: userId ?? userData?.id).then(
      (value) async {
        userData = value?.data;
        like = value?.data?.isLiked ?? false;
        save = (value?.data?.savedprofile?.split(',') ?? []).contains('${userId ?? userData?.id}');
        isFollow = (userData?.followingStatus == 2 || userData?.followingStatus == 3);
        List<String> interestID = (userData?.interests ?? '').split(',');
        PrefService.getInterest().then((value) {
          value?.data?.forEach((element) {
            if (interestID.contains('${element.id}')) {
              if (element.title != null || element.title!.isEmpty) {
                interestList.add(element.title ?? '');
              }
            }
          });
        });

        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> registrationUserApiCall() async {
    // Latest userdata
    await ApiProvider().getProfile(userID: PrefService.userId).then((value) {
      myUserData = value?.data;
      blockUnBlock = value?.data?.blockedUsers?.contains('${userData?.id}') == true ? S.current.unBlock : S.current.block;
      save = value?.data?.savedprofile?.contains('${userData?.id}') ?? false;
      like = value?.data?.likedprofile?.contains('${userData?.id}') ?? false;
      notifyListeners();

      PrefService.saveUser(value?.data);
    });
  }

  void userDetailApiCall() async {
    userProfileApiCall().then((value) {
      registrationUserApiCall();
    });
    latitude = await PrefService.getLatitude() ?? '';
    longitude = await PrefService.getLongitude() ?? '';
    if (latitude != null && latitude!.isNotEmpty && latitude != '0.0' && userData?.lattitude != null && userData!.lattitude!.isNotEmpty && userData?.lattitude != '0.0') {
      distance = calculateDistance(
        lat1: double.parse(latitude ?? '0.0'),
        lon1: double.parse(longitude ?? '0.0'),
        lat2: double.parse(userData?.lattitude ?? '0.0'),
        lon2: double.parse(userData?.longitude ?? '0.0'),
      );
    } else {
      distance = 0;
    }
    notifyListeners();
  }

  void onReasonChange(String value) {
    reason = value;
    showDropdown = false;
    notifyListeners();
  }

  void onReasonTap() {
    showDropdown = !showDropdown;
    notifyListeners();
  }

  void onImageSelect(int index) {
    selectedImgIndex = index;
    notifyListeners();
  }

  void onJoinBtnTap() {
    List<Images>? images = userData?.images;
    joinedUsers.add(userData?.identity ?? '');
    liveStreamUser = LiveStreamUser(
        userId: userData?.id,
        userImage: images != null && images.isNotEmpty ? images[0].image : '',
        id: DateTime.now().millisecondsSinceEpoch,
        watchingCount: 0,
        joinedUser: [],
        isVerified: userData?.isVerified == 2 ? true : false,
        hostIdentity: userData?.identity,
        collectedDiamond: 0,
        agoraToken: '',
        fullName: userData?.fullname ?? '',
        age: userData?.age ?? 0,
        address: userData?.live ?? '');
    db.collection(FirebaseRes.liveHostList).doc('${userData?.id}').update(
      {FirebaseRes.joinedUser: FieldValue.arrayUnion(joinedUsers), FirebaseRes.watchingCount: liveStreamUser!.watchingCount! + 1},
    ).then((value) {
      Get.to(() => const PersonStreamingScreen(), arguments: {Urls.aChannelId: userData?.identity, Urls.aIsBroadcasting: false, Urls.aUserInfo: liveStreamUser});
    }).catchError((e) {
      CommonUI.snackBarWidget(S.current.userNotLive);
    });
  }

  void onHideInfoTap() {
    notifyListeners();
  }

  void onBackTap() {
    PrefService.getUserData().then((value) {
      if (value?.id == userData?.id) {
        Get.back();
      } else {
        if (interstitialAd != null) {
          interstitialAd?.show().whenComplete(() {
            Get.back();
          });
        } else {
          Get.back();
        }
      }
    });
  }

  void initInterstitialAds() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    }, adMobIntId: Platform.isIOS ? settingAppData?.admobIntIos : settingAppData?.admobInt);
  }

  void onMoreBtnTap(String value) {
    if (value == S.current.block) {
      blockUnblockApi(blockProfileId: userData?.id).then((value) {
        registrationUserApiCall();
      });
    } else if (value == S.current.unBlock) {
      blockUnblockApi(blockProfileId: userData?.id).then((value) {
        registrationUserApiCall();
      });
    } else {
      onReportTap();
    }
  }

  Future<void> blockUnblockApi({int? blockProfileId}) async {
    CommonUI.lottieLoader();
    await ApiProvider().updateBlockList(blockProfileId);
    onBackTap();
  }

  void onLikeBtnTap() async {
    like = !like;
    notifyListeners();
    await ApiProvider().updateLikedProfile(userData?.id);
    // like != true
    //     ? null
    //     : await ApiProvider()
    //         .notifyLikeUser(userId: userData?.id ?? 0, type: 1);
  }

  void onSaveTap() {
    save = !save;
    ApiProvider().updateSaveProfile(userData?.id);
    notifyListeners();
  }

  void onChatWithBtnTap() {
    PrefService.getUserData().then((value) {
      ChatUser chatUser = ChatUser(
        age: '${userData?.age ?? ''}',
        city: userData?.live ?? '',
        image: CommonFun.getProfileImage(images: userData?.images),
        userIdentity: userData?.identity,
        userid: userData?.id,
        isNewMsg: false,
        isHost: userData?.isVerified == 2 ? true : false,
        date: DateTime.now().millisecondsSinceEpoch.toDouble(),
        username: userData?.fullname,
      );
      Conversation conversation = Conversation(
        block: myUserData?.blockedUsers?.contains('${userData?.id}') == true ? true : false,
        blockFromOther: userData?.blockedUsers?.contains('${myUserData?.id}') == true ? true : false,
        conversationId: CommonFun.getConversationID(myId: value?.id, otherUserId: userData?.id),
        deletedId: '',
        time: DateTime.now().millisecondsSinceEpoch.toDouble(),
        isDeleted: false,
        isMute: false,
        lastMsg: '',
        newMsg: '',
        user: chatUser,
      );
      Get.to(() => ChatScreen(conversation: conversation))?.then((value) {
        registrationUserApiCall();
      });
    });
  }

  void onShareProfileBtnTap() {
    shareLink(userData);
  }

  void onReportTap() {
    Get.bottomSheet(
      ReportSheet(reportId: userData?.id, fullName: userData?.fullname, profileImage: CommonFun.getProfileImage(images: userData?.images), age: userData?.age, userData: userData, address: userData?.live, reportType: 1),
      isScrollControlled: true,
    );
  }

  double calculateDistance({lat1, lon1, lat2, lon2}) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void onFollowUnfollowBtnClick() {
    CommonUI.getLottieLoader(isBarrierDismissible: false);
    if (isFollow) {
      ApiProvider().callPost(
          completion: (response) {
            Get.back();
            FollowUser followUser = FollowUser.fromJson(response);
            if (followUser.status == true) {
              userData?.followerCount(-1);
              isFollow = false;
              notifyListeners();
            }
          },
          url: Urls.aUnfollowUser,
          param: {Urls.myUserId: PrefService.userId, Urls.userId: userData?.id});
    } else {
      ApiProvider().callPost(
          completion: (response) {
            Get.back();
            FollowUser followUser = FollowUser.fromJson(response);
            if (followUser.status == true) {
              isFollow = true;
              userData?.followerCount(1);
              notifyListeners();
            }
          },
          url: Urls.aFollowUser,
          param: {Urls.myUserId: PrefService.userId, Urls.userId: userData?.id});
    }
  }

  void onEditBtnClick() {
    Get.to<RegistrationUserData>(() => EditProfileScreen(userData: userData))?.then((value) {
      if (value != null) {
        if (value.id == PrefService.userId) {
          userData = value;
        }
        notifyListeners();
      }
    });
  }

  void onPostBtnClick() {
    Get.to(() => PostScreen(userData: userData));
  }

  void getSettingData() {
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      initInterstitialAds();
      notifyListeners();
    });
  }
}
