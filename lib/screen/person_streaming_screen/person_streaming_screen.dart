import 'package:flutter/material.dart';
import 'package:orange_ui/model/chat_and_live_stream/live_stream.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/screen/person_streaming_screen/person_streaming_screen_view_model.dart';
import 'package:orange_ui/screen/person_streaming_screen/widgets/bottom_text_field.dart';
import 'package:orange_ui/screen/person_streaming_screen/widgets/comment_list_area.dart';
import 'package:orange_ui/screen/person_streaming_screen/widgets/person_top_bar_area.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class PersonStreamingScreen extends StatelessWidget {
  final LiveStreamUser? liveStreamUser;
  final Appdata? settingAppData;

  const PersonStreamingScreen({Key? key, this.liveStreamUser, this.settingAppData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PersonStreamingScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => PersonStreamingScreenViewModel(
          liveStreamUser: liveStreamUser, settingAppData: settingAppData),
      builder: (context, model, child) {
        return PopScope(
          canPop: false,
          child: Scaffold(
              body: Stack(
            children: [
              model.remoteVideo(),
              InkWell(
                onTap: () {
                  model.commentFocus.unfocus();
                },
                splashColor: ColorRes.transparent,
                highlightColor: ColorRes.transparent,
                child: Column(
                  children: [
                    PersonTopBarArea(
                      onViewTap: model.onViewTap,
                      onMoreBtnTap: model.onMoreBtnTap,
                      onExitTap: model.onExitTap,
                      liveStreamUser: model.liveStreamUser,
                      onUserTap: model.onUserTap,
                    ),
                    const Spacer(),
                    CommentListArea(
                      commentList: model.commentList,
                      pageContext: context,
                    ),
                    BottomTextField(
                      commentController: model.commentController,
                      commentFocus: model.commentFocus,
                      onMsgSend: model.onCommentSend,
                      onGiftTap: model.onGiftBtnTap,
                      onGoProTap: model.onGoPremiumTap,
                      count: model.countDownValue,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          )),
        );
      },
    );
  }
}
