import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/dashboard/dashboard_screen.dart';
import 'package:orange_ui/screen/login_pwd_screen/widgets/forgot_password.dart';
import 'package:orange_ui/screen/select_hobbies_screen/select_hobbies_screen.dart';
import 'package:orange_ui/screen/select_photo_screen/select_photo_screen.dart';
import 'package:orange_ui/screen/starting_profile_screen/starting_profile_screen.dart';
import 'package:orange_ui/service/firebase_notification_manager.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/pref_res.dart';
import 'package:stacked/stacked.dart';

import '../../utils/const_res.dart';

class LoginPwdScreenViewModel extends BaseViewModel {
  String? tokenId;
  String email = '';
  TextEditingController pwdController = TextEditingController();
  FocusNode pwdFocus = FocusNode();
  String pwdError = "";
  bool showPwd = false;
  bool isVerified = false;
  RegistrationUserData? userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode resetFocusNode = FocusNode();
  bool isResetBtnVisible = false;

  void init(String email) {
    FirebaseNotificationManager.shared.getNotificationToken(
      (token) {
        tokenId = token;
      },
    );
    this.email = email;
  }

  void onViewBtnTap() {
    showPwd = !showPwd;
    notifyListeners();
  }

  void onBackBtnTap() {
    Get.back();
  }

  Future<void> onContinueTap() async {
    bool validation = inValid();
    notifyListeners();
    pwdFocus.unfocus();
    if (validation) {
      if (!GetUtils.isEmail(email)) {
        CommonUI.lottieLoader();
        ApiProvider()
            .registration(email: email, fullName: '', deviceToken: tokenId, loginType: 4, password: pwdController.text)
            .then((value) async {
          if (value.data != null) {
            Get.back();
            PrefService.userId = value.data!.id!;
            await PrefService.saveString(PrefConst.password, pwdController.text);
            await PrefService.setLoginText(true);
            await PrefService.saveUser(value.data);
            await PrefService.setFullName('${value.data?.fullname}');
            checkScreenCondition(value.data);
          } else {
            Get.back();
            CommonUI.snackBarWidget(S.current.incorrectPasswordOrUserid);
          }
        });
      } else {
        signIn(email: email, password: pwdController.text).then((value) async {
          if (value?.user?.email == email) {
            CommonUI.lottieLoader();
            if (value?.user?.emailVerified == true) {
              Get.back();
              CommonUI.lottieLoader();
              ApiProvider()
                  .registration(email: email, fullName: '', deviceToken: tokenId, loginType: 4)
                  .then((value) async {
                Get.back();
                PrefService.userId = value.data!.id!;
                 print( "valid token : ${PrefService.userId}");
                await PrefService.setLoginText(true);
                await PrefService.saveUser(value.data);
                await PrefService.setFullName('${value.data?.fullname}');
                checkScreenCondition(value.data);
              });
            } else {
              Get.back();
              CommonUI.snackBarWidget(S.current.pleaseVerifyYourEmailFromYourInbox);
            }
          }
        });
      }
    }
  }

  bool inValid() {
    if (pwdController.text == "") {
      pwdError = S.current.enterPassword;
      return false;
    } else {
      return true;
    }
  }

  void resetBtnClick(TextEditingController controller) async {
    resetFocusNode.unfocus();
    if (controller.text.isEmpty) {
      CommonUI.snackBar(message: S.current.pleaseEnterEmail);
      return;
    } else if (!GetUtils.isEmail(controller.text)) {
      CommonUI.snackBar(message: S.current.pleaseEnterValidEmailAddress);
      return;
    }
    Get.back();
    CommonUI.lottieLoader();
    try {
      await _auth.sendPasswordResetEmail(email: controller.text);
      controller.clear();
      Get.back();
      CommonUI.snackBar(message: S.current.emailSentSuccessfully);
    } on FirebaseAuthException catch (e) {
      Get.back();
      CommonUI.snackBar(message: "${e.message}");
    }
  }

  void onForgotPwdTap() {
    Get.bottomSheet(
      ForgotPassword(resetBtnClick: resetBtnClick, resetFocusNode: resetFocusNode, email: email),
    );
  }

  //SIGN IN METHOD
  Future<UserCredential?> signIn({required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      CommonUI.snackBarWidget('${e.message}');
      return null;
    }
  }

  void checkScreenCondition(RegistrationUserData? data) {
    if (data?.age == null) {
      Get.offAll(() => const StartingProfileScreen());
    } else if (data!.images.isEmpty) {
      Get.off(() => const SelectPhotoScreen());
    } else if (data.interests == null || data.interests!.isEmpty) {
      Get.off(() => const SelectHobbiesScreen());
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }
}
