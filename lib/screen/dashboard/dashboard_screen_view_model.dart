import 'package:flutter/services.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/social/post/add_post.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/single_post_screen/single_post_screen.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';

class DashboardScreenViewModel extends BaseViewModel {
  int pageIndex = 0;
  RegistrationUserData? userData;

  Appdata? settingAppData;

  void init() {
    FlutterAppBadge.count(0);
    initBranch();
    getProfileApiCall();
  }

  void getProfileApiCall() {
    ApiProvider().getProfile(userID: PrefService.userId).then((value) {
      userData = value?.data;
      notifyListeners();
    });
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      notifyListeners();
    });
  }

  void onBottomBarTap(int index) {
    if (userData?.isBlock == 1 && index == 4) {
      pageIndex = index;
      notifyListeners();
      return;
    }
    if (userData?.isBlock == 1) {
      return CommonUI.snackBarWidget(S.current.userBlock);
    }
    pageIndex = index;
    notifyListeners();
  }

  void initBranch() {
    FlutterBranchSdk.listSession().listen(
      (data) {
        if (data.containsKey("+clicked_branch_link") && data["+clicked_branch_link"] == true) {
          if (data.containsKey('user_id')) {
            Get.to(() => UserDetailScreen(userId: int.parse(data['user_id'])));
          } else if (data.containsKey(Urls.aPostId)) {
            Future.delayed(const Duration(milliseconds: 100)).then((value) {
              ApiProvider().callPost(
                  completion: (response) {
                    AddPost post = AddPost.fromJson(response);
                    if (post.status == true) {
                      Get.to(() => SinglePostScreen(post: post.data));
                    } else {
                      CommonUI.snackBar(message: post.message ?? '');
                    }
                  },
                  url: Urls.aFetchPostByPostId,
                  param: {Urls.userId: PrefService.userId, Urls.aPostId: data[Urls.aPostId]});
            });
          }
        }
      },
      onError: (error) {
        PlatformException platformException = error as PlatformException;
        CommonUI.snackBarWidget('InitSession error: ${platformException.code} - ${platformException.message}');
      },
    );
  }
}
