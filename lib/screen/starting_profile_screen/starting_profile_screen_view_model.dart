import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/dashboard/dashboard_screen.dart';
import 'package:orange_ui/screen/select_hobbies_screen/select_hobbies_screen.dart';
import 'package:orange_ui/screen/select_photo_screen/select_photo_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:stacked/stacked.dart';

class StartingProfileScreenViewModel extends BaseViewModel {
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  FocusNode addressFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode ageFocus = FocusNode();

  String? fullName = '';
  String addressError = '';
  String bioError = '';
  String ageError = '';
  String latitude = '';
  String longitude = '';
  String gender = S.current.female;
  bool showDropdown = false;

  void init() {
    getProfileApi();
    prefData();
  }

  void onAllScreenTap() {
    showDropdown = false;
    notifyListeners();
  }

  void getProfileApi() {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      fullName = value?.data?.fullname;
      notifyListeners();
    });
  }

  void prefData() async {
    latitude = await PrefService.getLatitude() ?? '';
    longitude = await PrefService.getLongitude() ?? '';
  }

  void onGenderTap() {
    addressFocus.unfocus();
    bioFocus.unfocus();
    ageFocus.unfocus();
    showDropdown = !showDropdown;
    notifyListeners();
  }

  void onGenderChange(String value) {
    gender = value;
    showDropdown = false;
    notifyListeners();
  }

  void onNextTap() async {
    if (ageController.text.isEmpty) {
      CommonUI.snackBar(message: S.current.pleaseEnterYourAge);
      ageFocus.requestFocus();
      return;
    }
    if (int.parse(ageController.text) < 18) {
      CommonUI.snackBar(message: S.current.youMustBe18);
      return;
    }
    CommonUI.lottieLoader();
    ApiProvider()
        .updateProfile(
            fullName: fullName,
            live: addressController.text,
            bio: bioController.text,
            age: ageController.text,
            gender: gender == AppRes.male
                ? 1
                : gender == AppRes.female
                    ? 2
                    : 3,
            latitude: latitude,
            longitude: longitude)
        .then((value) async {
      Get.back();
      checkScreenCondition(value.data);
    });
  }

  void checkScreenCondition(RegistrationUserData? data) {
    if (data?.images == null || data!.images.isEmpty) {
      Get.to(() => const SelectPhotoScreen());
    } else if (data.interests == null || data.interests!.isEmpty) {
      Get.to(() => const SelectHobbiesScreen());
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }
}
