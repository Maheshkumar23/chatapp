import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:stacked/stacked.dart';

class EditProfileScreenViewModel extends BaseViewModel {
  void init() {
    getEditProfileApiCall();
    getInterestApiCall();
  }

  RegistrationUserData? userData;

  EditProfileScreenViewModel(this.userData);

  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();

  FocusNode ageFocus = FocusNode();
  FocusNode bioFocus = FocusNode();
  FocusNode aboutFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode youtubeFocus = FocusNode();
  FocusNode facebookFocus = FocusNode();
  FocusNode fullNameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode instagramFocus = FocusNode();

  List<Interest> hobbiesList = [];
  List<String> selectedList = [];

  String gender = AppRes.female;
  String fullNameError = '';
  String userNameError = '';
  String bioError = '';
  String aboutError = '';
  String addressError = '';
  String ageError = '';

  List<String> deleteIds = [];
  List<String> interestList = [];
  List<Images> imageList = [];
  List<File> imageFileList = [];

  bool showDropdown = false;
  bool isLoading = false;
  ImagePicker imagePicker = ImagePicker();

  void onClipTap(String value) {
    bool selected = selectedList.contains(value);
    if (selected) {
      selectedList.remove(value);
    } else {
      selectedList.add(value);
    }
    notifyListeners();
  }

  void getInterestApiCall() async {
    await PrefService.getInterest().then((value) {
      if (value != null && value.status!) {
        hobbiesList = value.data ?? [];
        notifyListeners();
      }
    }).then((value) {
      getPrefUser();
    });
  }

  void getEditProfileApiCall() async {
    imageList = userData?.images ?? [];
    fullNameController.text = userData?.fullname ?? '';
    userNameController.text = userData?.username ?? '';
    bioController.text = userData?.bio ?? '';
    aboutController.text = userData?.about ?? '';
    addressController.text = userData?.live ?? '';
    ageController.text = userData?.age?.toString() ?? '';
    gender = userData?.gender == 1
        ? AppRes.male
        : userData?.gender == 2
            ? AppRes.female
            : AppRes.other;
    instagramController.text = userData?.instagram ?? '';
    facebookController.text = userData?.facebook ?? '';
    youtubeController.text = userData?.youtube ?? '';
    notifyListeners();
  }

  void getPrefUser() {
    PrefService.getUserData().then((value) {
      List<String> interestIds = (value?.interests ?? '').split(',');
      selectedList.addAll(interestIds);
      notifyListeners();
    });
  }

  void onImageRemove(int index) {
    File? imageOne;
    for (File image in imageFileList) {
      if (image.path == imageList[index].image) {
        imageOne = image;
      }
    }
    if (imageOne != null) {
      imageFileList.remove(imageOne);
    }
    deleteIds.add(imageList[index].id.toString());
    imageList.removeAt(index);
    notifyListeners();
  }

  void onImageAdd() async {
    selectImages();
  }

  void onBackBtnTap() {
    Get.back();
  }

  void onAllScreenTap() {
    showDropdown = false;
    notifyListeners();
  }

  void onGenderTap() {
    addressFocus.unfocus();
    bioFocus.unfocus();
    aboutFocus.unfocus();
    ageFocus.unfocus();
    showDropdown = !showDropdown;
    notifyListeners();
  }

  void onGenderChange(String value) {
    gender = value;
    showDropdown = false;
    notifyListeners();
  }

  void onSaveTap() {
    updateProfileApiCall();
  }

  void selectImages() async {

    final selectedImages = await imagePicker.pickMultiImage(
        imageQuality: quality, maxHeight: maxHeight, maxWidth: maxWidth);
    if (selectedImages.isEmpty) return;
    if (selectedImages.isNotEmpty) {
      for (XFile image in selectedImages) {
        var images = File(image.path);
        imageFileList.add(images);
        imageList.add(
          Images(id: -123, userId: PrefService.userId, image: images.path),
        );
      }
    }
    notifyListeners();
  }

  void updateProfileApiCall() {
    bool validation = isValid();
    notifyListeners();
    if (validation) {
      CommonUI.lottieLoader();
      ApiProvider()
          .updateProfile(
              images: imageFileList,
              bio: bioController.text.trim(),
              age: ageController.text.trim(),
              instagram: instagramController.text.trim(),
              about: aboutController.text.trim(),
              facebook: facebookController.text.trim(),
              youtube: youtubeController.text.trim(),
              live: addressController.text.trim(),
              gender: gender == S.current.male ? 1 : 2,
              fullName: fullNameController.text.trim(),
              userName: userNameController.text.trim(),
              deleteImageIds: deleteIds,
              interest: selectedList)
          .then((value) async {
        if (value.data?.id == PrefService.userId) {
          await PrefService.saveUser(value.data);
        }
        Get.back(result: value.data);
        Get.back(result: value.data);
      });
    }
  }

  bool isValid() {
    int i = 0;
    if (imageList.isEmpty) {
      if (imageFileList.isEmpty) {
        CommonUI.snackBarWidget(S.current.pleaseAddAtLeastEtc);
        i++;
      }
      CommonUI.snackBarWidget(S.current.imageIsEmpty);
      i++;
    }
    if (fullNameController.text == '') {
      fullNameError = S.current.enterFullName;
      i++;
    }
    if (userNameController.text == '') {
      userNameFocus.requestFocus();
      userNameError = S.current.enterUsername;
      i++;
    }
    if (aboutController.text == '') {
      aboutFocus.requestFocus();
      CommonUI.snackBarWidget(S.current.enterAbout);
      i++;
    }
    if (ageController.text == '') {
      ageError = S.current.enterAge;
      i++;
    } else if (int.parse(ageController.text) < 18) {
      ageFocus.requestFocus();
      CommonUI.snackBar(message: S.current.youMustBe18);
      return false;
    }
    if (selectedList.isEmpty) {
      CommonUI.snackBarWidget(S.current.pleaseAddAtLeastInterest);
      i++;
    }
    notifyListeners();
    return i == 0 ? true : false;
  }

  @override
  void dispose() {
    bioFocus.dispose();
    aboutFocus.dispose();
    ageFocus.dispose();
    youtubeFocus.dispose();
    addressFocus.dispose();
    fullNameFocus.dispose();
    facebookFocus.dispose();
    instagramFocus.dispose();
    fullNameController.dispose();
    addressController.dispose();
    bioController.dispose();
    aboutController.dispose();
    ageController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  void onTextFieldChange(String value) {
    notifyListeners();
  }
}
