import 'package:flutter/material.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/saved_profiles_screen/saved_profiles_screen_view_model.dart';
import 'package:orange_ui/screen/saved_profiles_screen/widget/saved_card.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class SavedProfilesScreen extends StatelessWidget {
  const SavedProfilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedProfilesScreenViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => SavedProfilesScreenViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                TopBarArea(title2: S.of(context).savedProfiles),
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
                                S.of(context).noSavedData,
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
                                bool isSaved = false;
                                for (var element in viewModel.savedIds) {
                                  if (element == '${userData.id}') {
                                    isSaved = true;
                                  }
                                }
                                return SavedCard(
                                  userData: userData,
                                  viewModel: viewModel,
                                  isSaved: isSaved,
                                );
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
