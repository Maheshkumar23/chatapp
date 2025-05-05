import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

class VerificationScreenViewModel extends BaseViewModel {
  void init() {
    userData = Get.arguments;
  }

  TextEditingController fullNameController = TextEditingController();
  RegistrationUserData? userData;
  FocusNode fullNameFocus = FocusNode();
  String fullNameError = '';
  bool isDocumentType = false;
  bool isSelfie = false;
  bool showDropdown = false;
  String docType = S.current.drivingLicence;
  File? selfieImage;
  File? docFile;
  String? documentName;
  String? userIdentity;

  void onDocTypeTap() {
    fullNameFocus.unfocus();
    showDropdown = !showDropdown;
    notifyListeners();
  }

  void onDocChange(String value) {
    docType = value;
    showDropdown = false;
    notifyListeners();
  }

  void onTakePhotoTap() async {
    if (Platform.isAndroid) {
      final PermissionStatus status;
      status = await Permission.camera.request();

      var allAccepted = true;
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
      if (!allAccepted) {
        openAppSettings();
        return;
      }
    }
    fullNameFocus.unfocus();
    final ImagePicker picker = ImagePicker();
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera).onError(
      (PlatformException error, stackTrace) {
        CommonUI.snackBarWidget(error.message ?? '');
        return null;
      },
    );
    if (photo == null || photo.path.isEmpty) return;
    selfieImage = File(photo.path);
    notifyListeners();
    // print('photo path ${photo.path}');
  }

  void onDocumentTap() async {
    fullNameFocus.unfocus();
    final ImagePicker picker = ImagePicker();
    XFile? photo;

    photo = await picker
        .pickImage(source: ImageSource.gallery)
        .onError((PlatformException error, stackTrace) {
      CommonUI.snackBarWidget(error.message ?? '');
      return null;
    });

    if (photo == null || photo.path.isEmpty) return;
    docFile = File(photo.path);
    documentName = photo.name;
    notifyListeners();
  }

  void onSubmitBtnClick() {
    if (isVerified()) {
      CommonUI.lottieLoader();
      ApiProvider()
          .applyForVerification(
              selfieImage, docFile, fullNameController.text, docType)
          .then((value) {
        CommonUI.snackBarWidget(value.message ?? '');
        Get.back();
        Get.back();
      });
    }
  }

  bool isVerified() {
    int i = 0;
    isDocumentType = false;
    fullNameFocus.unfocus();
    isSelfie = false;
    if (fullNameController.text == '') {
      fullNameError = S.current.enterFullName;
      i++;
    }
    if (docFile == null || docFile!.path.isEmpty) {
      isDocumentType = true;
      i++;
    }
    if (selfieImage == null || selfieImage!.path.isEmpty) {
      CommonUI.snackBarWidget(S.current.pleaseAddSelfiePhoto);
      isSelfie = true;
      i++;
    }
    notifyListeners();
    return i == 0 ? true : false;
  }

  void onBackBtnTap() {
    Get.back();
  }
}
