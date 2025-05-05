import 'package:flutter/services.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';

class LikeProfilesScreenViewModel extends BaseViewModel {
  List<RegistrationUserData> userData = [];
  bool isLoading = true;
  List<String> likedIds = [];

  void init() {
    fetchLikedProfiles();
  }

  void fetchLikedProfiles() async {
    isLoading = true;
    ApiProvider().fetchLikedProfiles().then((value) {
      isLoading = false;
      userData = value.data ?? [];
      notifyListeners();
    });
    PrefService.getUserData().then((value) {
      likedIds = (value?.likedprofile ?? '').split(',');
    });
  }

  onSavedClick(RegistrationUserData p0) {
    HapticFeedback.lightImpact();
    if (likedIds.contains('${p0.id}')) {
      userData.remove(p0);
      notifyListeners();
    }
    ApiProvider().updateLikedProfile(p0.id);
  }

  void onLikeCardBack(RegistrationUserData p1) {
    likedIds = [];
    PrefService.getUserData().then((value) {
      likedIds = (value?.likedprofile ?? '').split(',');
      if (!likedIds.contains('${p1.id}')) {
        userData.remove(p1);
        notifyListeners();
      }
    });
  }
}
