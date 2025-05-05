import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/starting_profile_top_text.dart';
import 'package:orange_ui/screen/select_photo_screen/select_photo_screen_view_model.dart';
import 'package:orange_ui/screen/select_photo_screen/widgets/bottom_selection_list.dart';
import 'package:orange_ui/screen/select_photo_screen/widgets/full_image_view.dart';
import 'package:stacked/stacked.dart';

class SelectPhotoScreen extends StatelessWidget {
  const SelectPhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectPhotoScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => SelectPhotoScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            children: [
              const StartingProfileTopText(),
              SizedBox(height: Get.height / 25),
              FullImageView(
                imageList: model.imageFileList,
                pageController: model.pageController,
                fullName: model.fullName,
                age: model.age,
                address: model.address,
                bioText: model.bioText,
              ),
              const Spacer(),
              BottomSelectionList(
                imageList: model.imageFileList,
                selectedIndex: model.pageIndex,
                onAddBtnTap: model.onImageAdd,
                onImgRemove: model.onImageRemove,
                onPlayBtnTap: model.onPlayButtonTap,
              ),
            ],
          ),
        );
      },
    );
  }
}
