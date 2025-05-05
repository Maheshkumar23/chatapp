import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/languages_screen/languages_screen.dart';
import 'package:orange_ui/screen/livestream_dashboard_screen/livestream_dashboard_screen.dart';
import 'package:orange_ui/screen/login_dashboard_screen/login_dashboard_screen.dart';
import 'package:orange_ui/screen/verification_screen/verification_screen.dart';
import 'package:orange_ui/screen/webview_screen/webview_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:orange_ui/utils/pref_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';

class OptionalScreenViewModel extends BaseViewModel {
  bool notificationEnable = false;
  bool showMeOnMap = false;
  bool goAnonymous = false;
  int? loginType;
  int? verificationProcess = 0;
  bool isLoading = false;
  int? deleteId;
  RegistrationUserData? userData;
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void init() {
    getProfileApiCall();
  }

  void getProfileApiCall() {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) {
      userData = value?.data;
      deleteId = value?.data?.id;
      verificationProcess = value?.data?.isVerified == 0
          ? 0
          : value?.data?.isVerified == 1
              ? 1
              : 2;
      notificationEnable = value?.data?.isNotification == 1 ? true : false;
      showMeOnMap = value?.data?.showOnMap == 1 ? true : false;
      goAnonymous = value?.data?.anonymous == 1 ? true : false;
      loginType = value?.data?.loginType;
      notifyListeners();
    });
  }

  void onLiveStreamTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => const LiveStreamDashBoard());
  }

  void onApplyForVerTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : Get.to(() => const VerificationScreen(), arguments: userData)
            ?.then((value) {
            getProfileApiCall();
          });
  }

  void onNotificationTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : ApiProvider()
            .onOffNotification(notificationEnable ? 0 : 1)
            .then((value) async {
            if (value.status == true) {
              notificationEnable =
                  value.data?.isNotification == 1 ? true : false;
              await PrefService.saveUser(value.data);
              notifyListeners();
              CommonUI.snackBarWidget(value.message!);
            }
          });
  }

  void onShowMeOnMapTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : ApiProvider()
            .onOffShowMeOnMap(showMeOnMap ? 0 : 1)
            .then((value) async {
            if (value.status == true) {
              showMeOnMap = value.data?.showOnMap == 1 ? true : false;
              await PrefService.saveUser(value.data);
              CommonUI.snackBarWidget(value.message!);
              notifyListeners();
            }
          });
  }

  void onGoAnonymousTap() {
    userData?.isBlock == 1
        ? CommonUI.snackBarWidget(S.current.userBlock)
        : ApiProvider().onOffAnonymous(goAnonymous ? 0 : 1).then((value) async {
            if (value.status == true) {
              goAnonymous = value.data?.anonymous == 1 ? true : false;
              await PrefService.saveUser(value.data);
              notifyListeners();
              CommonUI.snackBarWidget(value.message!);
            }
          });
  }

  void onNavigateWebViewScreen(int type) {
    Get.to(
      () => WebViewScreen(
          appBarTitle:
              type == 0 ? S.current.privacyPolicy : S.current.termsOfUse,
          url: type == 0 ? Urls.aPrivacyPolicy : Urls.aTermsOfUse),
    );
  }

  Future<void> onLogOutYesBtnClick() async {
    if (loginType == 1) {
      await googleSignOut();
    }
    if (loginType == 2) {
      // apple logout
    }
    if (loginType == 3) {
      //facebook logout
    }
    if (loginType == 4) {
      await FirebaseAuth.instance.signOut();
    }
    ApiProvider().logoutUser().then((value) {
      PrefService.setLoginText(false);
      CommonUI.snackBarWidget('${value.message}');
      Get.offAll(() => const LoginDashboardScreen());
    });
  }

  void onLogoutTap() async {
    Get.dialog(ConfirmationDialog(
      onTap: onLogOutYesBtnClick,
      description: S.current.logOutDis,
      textButton: '${S.current.logOut} ',
      textImage: AssetRes.logout,
      dialogSize: 1.9,
      padding: const EdgeInsets.symmetric(horizontal: 40),
    ));
  }

  Future googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  void onDeleteYesBtnClick() async {
    String password = await PrefService.getString(PrefConst.password) ?? '';
    Get.back();
    CommonUI.lottieLoader();

    FirebaseAuth.instance.currentUser?.delete();
    await FirebaseAuth.instance.signOut();
    ApiProvider().deleteAccount(deleteId).then((value) async {
      if (value.status == true) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: userData?.identity ?? '',
          password: password,
        )
            .then((value) {
          value.user?.delete();
        });
        await deleteFirebaseUser();
        CommonUI.snackBarWidget(value.message ?? '');
        PrefService.setLoginText(false);

        Get.offAll(() => const LoginDashboardScreen());
      }
      notifyListeners();
    });
  }

  Future<void> deleteFirebaseUser() async {
    await db
        .collection(FirebaseRes.userChatList)
        .doc('${userData?.id}')
        .collection(FirebaseRes.userList)
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection(FirebaseRes.userChatList)
            .doc(element.id)
            .collection(FirebaseRes.userList)
            .doc('${userData?.id}')
            .update({
          FirebaseRes.isDeleted: true,
          FirebaseRes.deletedId: '${DateTime.now().millisecondsSinceEpoch}',
          FirebaseRes.block: false,
          FirebaseRes.blockFromOther: false,
        });

        db
            .collection(FirebaseRes.userChatList)
            .doc('${userData?.id}')
            .collection(FirebaseRes.userList)
            .doc(element.id)
            .update({
          FirebaseRes.isDeleted: true,
          FirebaseRes.deletedId: '${DateTime.now().millisecondsSinceEpoch}',
          FirebaseRes.block: false,
          FirebaseRes.blockFromOther: false,
        });
      }
    });
  }

  void onNoBtnClick() {
    Get.back();
  }

  void onDeleteAccountTap() {
    Get.dialog(ConfirmationDialog(
      onTap: onDeleteYesBtnClick,
      description: S.current.deleteDialogDis,
      dialogSize: 1.6,
      padding: const EdgeInsets.symmetric(horizontal: 40),
    ));
  }

  void navigateLanguage() {
    Get.to(() => const LanguagesScreen());
  }
}
