import 'package:flutter/material.dart';
import 'package:orange_ui/common/top_bar_area.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/live_stream_application_screen/widgets/center_area_livestream.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

import 'live_stream_application_screen_view_model.dart';

class LiveStreamApplicationScreen extends StatelessWidget {
  const LiveStreamApplicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamApplicationScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => LiveStreamApplicationScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: Column(
            children: [
              TopBarArea(
                title: S.current.liveStreamCap,
                title2: S.current.application,
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                width: MediaQuery.of(context).size.width,
                color: ColorRes.grey5,
              ),
              CenterAreaLiveStream(
                aboutController: model.aboutController,
                languageController: model.languageController,
                onSubmitTap: model.onSubmitBtnTap,
                videoController: model.videoController,
                onAddBtnTap: model.onPlusBtnTap,
                onRemoveBtnTap: model.onRemoveBtnTap,
                onVideoControllerChange: model.onVideoControllerChange,
                onVideoChangeBtnTap: model.onVideoChangeBtnTap,
                onVideoPlayBtnTap: model.onVideoPlayBtnTap,
                onAttachBtnTap: model.onAttachBtnTap,
                videoImage: model.videoImageFile,
                isVideoAttach: model.isVideoAttach,
                controllers: model.socialProfileController,
                fieldCount: model.fieldCount,
                isAbout: model.isAbout,
                isIntroVideo: model.isIntroVideo,
                isLanguages: model.isLanguages,
                isSocialLink: model.isSocialLink,
                aboutFocus: model.aboutFocus,
                languageFocus: model.languageFocus,
                socialLinkFocus: model.socialLinksFocus,
              ),
            ],
          ),
        );
      },
    );
  }
}
