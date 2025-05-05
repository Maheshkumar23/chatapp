import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/dashboard/dashboard_screen.dart';
import 'package:orange_ui/screen/login_pwd_screen/login_pwd_screen.dart';
import 'package:orange_ui/screen/login_pwd_screen/widgets/forgot_password.dart';
import 'package:orange_ui/screen/register_screen/register_screen.dart';
import 'package:orange_ui/screen/select_hobbies_screen/select_hobbies_screen.dart';
import 'package:orange_ui/screen/select_photo_screen/select_photo_screen.dart';
import 'package:orange_ui/screen/starting_profile_screen/starting_profile_screen.dart';
import 'package:orange_ui/service/firebase_notification_manager.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stacked/stacked.dart';

class LoginDashboardScreenViewModel extends BaseViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? tokenId;
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  String emailError = "";
  String appleUserName = '';
  FocusNode resetFocusNode = FocusNode();

  void init() {
    FirebaseNotificationManager.shared.getNotificationToken(
      (token) {
        tokenId = token;
      },
    );
    getEmail();
  }

  void getEmail() async {
    emailController.text = await PrefService.getEmail() ?? '';
  }

  bool isValid() {
    if (emailController.text == "") {
      emailError = S.current.enterEmail;
      return false;
    } else {
      emailError = "";
      return true;
    }
  }

  void onContinueTap() {
    bool validation = isValid();
    notifyListeners();
    emailFocus.unfocus();
    if (validation) {
      Get.to(() => LoginPwdScreen(email: emailController.text));
    }
  }

  void onGoogleTap() {
    CommonUI.lottieLoader();
    signInWithGoogle().then((value) async {
      if (value == null) {
        Get.back();
        return;
      }
      // if (value?.user?.email == null||value!.user!.email!.isEmpty) return;
      Get.back();
      registrationApiCall(email: value.user?.email, name: value.user?.displayName, loginType: 1);
    });
  }

  void onAppleTap() {
    signInWithApple().then((value) async {
      if (value == null) {
        return;
      }
      String appleFullName = await PrefService.getFullName() ?? '';
      registrationApiCall(email: value.user?.email, name: appleFullName, loginType: 2);
      notifyListeners();
    });
  }

  void onSignUpTap() {
    Get.to(() => const RegisterScreen());
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
      ForgotPassword(
        resetBtnClick: resetBtnClick,
        resetFocusNode: resetFocusNode,
      ),
    );
  }

  Future<UserCredential?> signInWithApple() async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider('apple.com').credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    final user = await _auth.signInWithCredential(credential);

    final fullName = appleIdCredential.givenName;

    final familyName = appleIdCredential.familyName;

    if (fullName != null || familyName != null) {
      String name = '$fullName $familyName';
      await user.user?.updateDisplayName(name);
      await PrefService.setFullName(name);
      notifyListeners();
    }
    // await user.user?.updateDisplayName(familyName);
    return user;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;

      // Check if authentication details are null
      if (googleAuth == null || googleAuth.accessToken == null || googleAuth.idToken == null) {
        Get.back();
        return null;
      }

      // Create a new credential
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final user = await _auth.signInWithCredential(credential);
      return user;
    } catch (error) {
      Get.back();
      return null;
    }
  }

  void registrationApiCall({required String? email, required String? name, required int loginType}) {
    CommonUI.lottieLoader();
    ApiProvider()
        .registration(email: email, fullName: name, deviceToken: tokenId, loginType: loginType, password: '')
        .then((value) async {
      Get.back();
      if (value.status == true) {
        PrefService.userId = value.data!.id!;
        await PrefService.setLoginText(true);
        if (value.data?.lattitude != null) {
          await PrefService.setLatitude("${value.data?.lattitude}");
          await PrefService.setLongitude("${value.data?.longitude}");
        }
        await PrefService.saveUser(value.data);
        await checkScreenCondition(value.data);
      }
    });
  }

  Future<void> checkScreenCondition(RegistrationUserData? data) async {
    if (data == null) return;
    if (data.age == null) {
      Get.offAll(
        () => const StartingProfileScreen(),
      );
    } else if (data.images.isEmpty) {
      Get.off(() => const SelectPhotoScreen());
    } else if (data.interests == null || data.interests!.isEmpty) {
      Get.off(() => const SelectHobbiesScreen());
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }
}
