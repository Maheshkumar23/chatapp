import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/feed_screen/feed_screen_view_model.dart';
import 'package:orange_ui/screen/post_screen/post_screen_view_model.dart';
import 'package:orange_ui/screen/post_screen/widget/post_card.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class PostScreen extends StatelessWidget {
  final RegistrationUserData? userData;

  const PostScreen({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostScreenViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => PostScreenViewModel(userData),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: ColorRes.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back, color: ColorRes.davyGrey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              CommonUI.userName(userData?.username),
                              style: const TextStyle(
                                  fontFamily: FontRes.bold, fontSize: 16, color: ColorRes.dimGrey3),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(' ${userData?.age ?? 0} ',
                              style: const TextStyle(
                                  fontFamily: FontRes.regular,
                                  color: ColorRes.dimGrey3,
                                  fontSize: 16)),
                          userData?.isVerified == 2
                              ? Image.asset(
                                  AssetRes.icBlueTick,
                                  width: 18,
                                )
                              : const SizedBox()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ViewModelBuilder<FeedScreenViewModel>.nonReactive(
                viewModelBuilder: () => FeedScreenViewModel(),
                builder: (context, model, child) => viewModel.isLoading
                    ? CommonUI.lottieWidget()
                    : viewModel.posts.isEmpty
                        ? CommonUI.noData()
                        : ListView.builder(
                            controller: viewModel.scrollController,
                            itemCount: viewModel.posts.length,
                            padding: const EdgeInsets.only(top: 10),
                            itemBuilder: (context, index) {
                              return PostCard(
                                postIndex: index,
                                post: viewModel.posts[index],
                                model: model,
                                onDeleteItem: viewModel.onDeleteItem,
                                updatePost: viewModel.updateAllPost,
                              );
                            },
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
