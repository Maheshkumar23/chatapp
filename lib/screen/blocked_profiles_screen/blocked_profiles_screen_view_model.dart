import 'package:flutter/services.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';

class BlockedProfilesScreenViewModel extends BaseViewModel {
  List<RegistrationUserData> userData = [];
  bool isLoading = true;
  List<String> blockedIds = [];

  void init() {
    fetchLikedProfiles();
  }

  void fetchLikedProfiles() async {
    isLoading = true;
    ApiProvider().fetchBlockedProfiles().then((value) {
      isLoading = false;
      userData = value.data ?? [];
      notifyListeners();
    });
    PrefService.getUserData().then((value) {
      blockedIds = (value?.blockedUsers ?? '').split(',');
    });
  }

  onUnblockClick(RegistrationUserData p0) {
    HapticFeedback.lightImpact();
    if (blockedIds.contains('${p0.id}')) {
      userData.remove(p0);
      notifyListeners();
    }
    ApiProvider().updateBlockList(p0.id);
  }

  void onBackBlockIds(RegistrationUserData p1) {
    blockedIds = [];
    PrefService.getUserData().then((value) {
      blockedIds = (value?.blockedUsers ?? '').split(',');
      if (!blockedIds.contains('${p1.id}')) {
        userData.remove(p1);
        notifyListeners();
      }
    });
  }
}
