import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/login_dashboard_screen/login_dashboard_screen.dart';
import 'package:orange_ui/screen/webview_screen/webview_screen.dart';
import 'package:orange_ui/service/firebase_notification_manager.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';

class RegisterScreenViewModel extends BaseViewModel {
  String? tokenId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  FocusNode fullNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  FocusNode confirmPwdFocus = FocusNode();
  FocusNode ageFocus = FocusNode();

  String fullNameError = '';
  String emailError = '';
  String pwdError = '';
  String confirmPwdError = '';
  String ageError = '';

  bool showPwd = false;

  void init() {
    FirebaseNotificationManager.shared.getNotificationToken((token) {
      tokenId = token;
    });
  }

  void onViewTap() {
    showPwd = !showPwd;
    notifyListeners();
  }

  void onTermsOfUseTap() {
    Get.to(() => WebViewScreen(appBarTitle: S.current.termsOfUse, url: Urls.aTermsOfUse));
  }

  void onPrivacyPolicyTap() {
    Get.to(
      () => WebViewScreen(appBarTitle: S.current.privacyPolicy, url: Urls.aPrivacyPolicy),
    );
  }

  Future<void> onContinueTap() async {
    if (isValid()) {
      CommonUI.lottieLoader();
      signUp(email: emailController.text, password: pwdController.text).then((value) {
        if (value == null) return;
        value.user?.sendEmailVerification();
        ApiProvider()
            .registration(
                email: emailController.text, fullName: fullNameController.text, deviceToken: tokenId, loginType: 5)
            .then((value) async {
          CommonUI.snackBarWidget(S.current.registrationSuccessfully);
          PrefService.userId = value.data?.id ?? -1;
          await PrefService.saveUser(value.data);
          Get.back();
          Get.offAll(() => const LoginDashboardScreen());
        });
      });
    }
    notifyListeners();
  }

  bool isValid() {
    int count = 0;
    if (emailController.text == '') {
      count++;
      emailFocus.requestFocus();
      emailError = S.current.enterEmail;
      return false;
    } else {
      bool isEmailValid = GetUtils.isEmail(emailController.text);
      if (!isEmailValid) {
        CommonUI.snackBarWidget(S.current.pleaseValidEmail);
        return false;
      } else {
        emailFocus.unfocus();
        FocusScope.of(Get.context!).requestFocus(fullNameFocus);
      }
    }
    if (fullNameController.text == '') {
      count++;
      fullNameFocus.requestFocus();
      fullNameError = S.current.enterFullName;
      return false;
    } else {
      fullNameFocus.unfocus();
      FocusScope.of(Get.context!).requestFocus(pwdFocus);
    }
    if (pwdController.text == '') {
      count++;
      pwdError = S.current.enterPassword;
      pwdFocus.requestFocus();
      return false;
    } else {
      pwdFocus.unfocus();
      FocusScope.of(Get.context!).requestFocus(confirmPwdFocus);
    }
    if (confirmPwdController.text == '') {
      count++;
      confirmPwdError = S.current.enterConfirmPassword;
      confirmPwdFocus.requestFocus();
      return false;
    } else {
      if (confirmPwdController.text != pwdController.text) {
        count++;
        confirmPwdController.clear();
        confirmPwdError = S.current.passwordMismatch;
      }
      confirmPwdFocus.unfocus();
      FocusScope.of(Get.context!).requestFocus(ageFocus);
    }
    if (ageController.text.isEmpty) {
      count++;
      ageError = S.current.enterAge;
      ageFocus.requestFocus();
      return false;
    } else if (int.parse(ageController.text) < 18) {
      count++;
      CommonUI.snackBar(message: S.current.youMust18);
      ageFocus.unfocus();
    }

    return count == 0 ? true : false;
  }

  Future<UserCredential?> signUp({required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      CommonUI.snackBarWidget('${e.message}');
      Get.offAll(() => const LoginDashboardScreen());
      return null;
    }
  }

  @override
  void dispose() {
    fullNameFocus.dispose();
    emailFocus.dispose();
    pwdFocus.dispose();
    confirmPwdFocus.dispose();
    ageFocus.dispose();
    fullNameController.dispose();
    emailController.dispose();
    pwdController.dispose();
    confirmPwdController.dispose();
    ageController.dispose();
    super.dispose();
  }
}
