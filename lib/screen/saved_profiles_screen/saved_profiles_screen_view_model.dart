import 'package:flutter/services.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';

class SavedProfilesScreenViewModel extends BaseViewModel {
  List<RegistrationUserData> userData = [];
  bool isLoading = true;
  List<String> savedIds = [];

  void init() {
    fetchSavedProfiles();
  }

  void fetchSavedProfiles() async {
    isLoading = true;
    ApiProvider().fetchSavedProfiles().then((value) {
      isLoading = false;
      userData = value.data ?? [];
      notifyListeners();
    });
    PrefService.getUserData().then((value) {
      savedIds = (value?.savedprofile ?? '').split(',');
    });
  }

  onSavedClick(RegistrationUserData p0) {
    HapticFeedback.lightImpact();
    if (savedIds.contains('${p0.id}')) {
      userData.remove(p0);
      notifyListeners();
    }
    ApiProvider().updateSaveProfile(p0.id);
  }

  void onSavedCardBack(RegistrationUserData p1) {
    savedIds = [];
    PrefService.getUserData().then((value) {
      savedIds = (value?.savedprofile ?? '').split(',');
      if (!savedIds.contains('${p1.id}')) {
        userData.remove(p1);
        notifyListeners();
      }
    });
  }
}
