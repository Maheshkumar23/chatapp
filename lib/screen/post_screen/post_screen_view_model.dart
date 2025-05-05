import 'package:flutter/material.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/model/social/post/add_comment.dart';
import 'package:orange_ui/model/social/post/fetch_post_by_user.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';

class PostScreenViewModel extends BaseViewModel {
  RegistrationUserData? userData;
  List<Post> posts = [];
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  bool hasNoMoreData = false;

  init() {
    fetchPostByUse();
    fetchScrollData();
  }

  PostScreenViewModel(this.userData);

  void fetchPostByUse() {
    if (hasNoMoreData) {
      return;
    }
    isLoading = true;
    ApiProvider().callPost(
        completion: (response) {
          FetchPostByUser fetchPostByUser = FetchPostByUser.fromJson(response);
          if (posts.isEmpty) {
            posts = fetchPostByUser.data ?? [];
          } else {
            posts.addAll(fetchPostByUser.data ?? []);
          }
          if (paginationLimit > (fetchPostByUser.data ?? []).length) {
            hasNoMoreData = true;
          }
          isLoading = false;
          notifyListeners();
        },
        url: Urls.aFetchPostByUser,
        param: {
          Urls.myUserId: PrefService.userId,
          Urls.userId: userData?.id,
          Urls.aStart: posts.length,
          Urls.aLimit: paginationLimit
        });
  }

  void fetchScrollData() {
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchPostByUse();
        }
      }
    });
  }

  onDeleteItem(int id) {
    posts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  updateAllPost(RegistrationUserData? data) {
    for (var element in posts) {
      if (element.userId == data?.id) {
        element.user = data;
      }
    }
    notifyListeners();
  }
}
