import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/social/post/add_comment.dart';
import 'package:orange_ui/model/social/post/fetch_comment.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';

class CommentSheetViewModel extends BaseViewModel {
  List<CommentData> comments = [];
  ScrollController scrollController = ScrollController();
  Post? post;
  bool isLoading = true;
  RegistrationUserData? userData;

  DetectableTextEditingController detectableTextFieldController = DetectableTextEditingController(
      detectedStyle:
          const TextStyle(fontFamily: FontRes.bold, color: ColorRes.darkOrange, fontSize: 14),
      regExp: detectionRegExp(atSign: false, url: false));

  void init() {
    fetchCommentData();
    fetchScrollData();
    getPrefData();
  }

  CommentSheetViewModel(this.post);

  fetchCommentData() {
    isLoading = true;

    ApiProvider().callPost(
        completion: (response) {
          isLoading = false;
          FetchComment comment = FetchComment.fromJson(response);
          comments.addAll(comment.data ?? []);
          notifyListeners();
        },
        url: Urls.aFetchComments,
        param: {
          Urls.aPostId: post?.id,
          Urls.aStart: comments.length,
          Urls.aLimit: paginationLimit
        });
  }

  void fetchScrollData() {
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchCommentData();
        }
      }
    });
  }

  void onCommentSend() {
    ApiProvider().callPost(
        completion: (response) {
          AddComment addComment = AddComment.fromJson(response);
          comments.add(CommentData(
              postId: addComment.data?.postId,
              description: addComment.data?.description,
              createdAt: addComment.data?.createdAt,
              id: addComment.data?.id,
              updatedAt: addComment.data?.updatedAt,
              userId: addComment.data?.userId,
              user: userData));
          post?.setCommentCount(1);
          notifyListeners();
        },
        url: Urls.aAddComment,
        param: {
          Urls.userId: PrefService.userId,
          Urls.aPostId: post?.id,
          Urls.aDescription: detectableTextFieldController.text.trim(),
        });
    detectableTextFieldController.clear();
  }

  void deleteComment(int commentId) {
    if (commentId == -1) {
      CommonUI.snackBar(message: S.current.commentNotFound);
    }

    Get.dialog(ConfirmationDialog(
      onTap: () {
        comments.removeWhere((element) {
          return element.id == commentId;
        });
        post?.setCommentCount(-1);
        notifyListeners();
        ApiProvider().callPost(
            completion: (response) {},
            url: Urls.aDeleteComment,
            param: {Urls.userId: PrefService.userId, Urls.aCommentId: commentId});
      },
      description: S.current.areYouSureYouWantToDeleteTheComment,
      heading: S.current.commentDelete,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      dialogSize: 2,
    ));
  }

  void getPrefData() {
    PrefService.getUserData().then((value) {
      userData = value;
      notifyListeners();
    });
  }
}
