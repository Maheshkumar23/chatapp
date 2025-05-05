import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/dashboard/dashboard_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:stacked/stacked.dart';

class SelectHobbiesScreenViewModel extends BaseViewModel {
  List<Interest> hobbiesList = [];
  List<String> selectedList = [];
  String fullName = '';
  int age = 0;
  String address = '';
  String bioText = '';
  String latitude = '';
  String longitude = '';

  void init() {
    getInterestApiCall();
  }

  void onClipTap(String value) {
    bool selected = selectedList.contains(value);
    if (selected) {
      selectedList.remove(value);
    } else {
      selectedList.add(value);
    }
    notifyListeners();
  }

  void getInterestApiCall() {
    PrefService.getInterest().then((value) {
      if (value?.data != null && value!.data!.isNotEmpty) {
        hobbiesList = value.data ?? [];
        notifyListeners();
      } else {
        Get.offAll(() => const DashboardScreen());
      }
    });
  }

  void onNextTap() {
    CommonUI.lottieLoader();
    ApiProvider().updateProfile(interest: selectedList).then((value) async {
      Get.back();
      Get.offAll(() => const DashboardScreen());
    });
  }

  void onSkipTap() {
    Get.offAll(() => const DashboardScreen());
  }
}
