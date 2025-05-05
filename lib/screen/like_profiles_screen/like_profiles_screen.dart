import 'package:flutter/material.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/like_profiles_screen/like_profiles_screen_view_model.dart';
import 'package:orange_ui/screen/like_profiles_screen/widget/like_card.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class LikeProfilesScreen extends StatelessWidget {
  const LikeProfilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LikeProfilesScreenViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => LikeProfilesScreenViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                TopBarArea(title2: S.of(context).likeProfiles),
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  width: MediaQuery.of(context).size.width,
                  color: ColorRes.grey5,
                ),
                Expanded(
                  child: viewModel.isLoading
                      ? CommonUI.lottieWidget()
                      : viewModel.userData.isEmpty
                          ? Center(
                              child: Text(
                                S.of(context).noLikeData,
                                style: const TextStyle(
                                  color: ColorRes.darkGrey,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: FontRes.bold,
                                ),
                                maxLines: 1,
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: viewModel.userData.length,
                              itemBuilder: (context, index) {
                                RegistrationUserData userData = viewModel.userData[index];
                                bool isLike = false;
                                for (var element in viewModel.likedIds) {
                                  if (element == '${userData.id}') {
                                    isLike = true;
                                  }
                                }
                                return LikeCard(
                                    userData: userData, viewModel: viewModel, isLike: isLike);
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
