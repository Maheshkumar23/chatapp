import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/buttons.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/starting_profile_top_text.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/select_hobbies_screen/select_hobbies_screen_view_model.dart';
import 'package:orange_ui/screen/select_hobbies_screen/widgets/hobbies_clips.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class SelectHobbiesScreen extends StatelessWidget {
  const SelectHobbiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectHobbiesScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => SelectHobbiesScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            children: [
              const StartingProfileTopText(),
              SizedBox(height: Get.height * 0.0593),
              Expanded(
                child: Center(
                  child: model.hobbiesList.isEmpty
                      ? CommonUI.noData()
                      : HobbiesClips(
                          hobbiesList: model.hobbiesList,
                          selectedList: model.selectedList,
                          onClipTap: model.onClipTap,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: SubmitButton2(
                    title: S.current.next, onTap: model.onNextTap),
              ),
              const SizedBox(height: 27),
              InkWell(
                onTap: model.onSkipTap,
                child: Text(
                  S.current.skip,
                  style: const TextStyle(
                    color: ColorRes.dimGrey2,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 27),
            ],
          ),
        );
      },
    );
  }
}
