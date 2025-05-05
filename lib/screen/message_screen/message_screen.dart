import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/dashboard_top_bar.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/screen/message_screen/message_screen_view_model.dart';
import 'package:orange_ui/screen/message_screen/widgets/user_card.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => MessageScreenViewModel(),
      builder: (context, model, child) {
        return Container(
          color: ColorRes.white,
          child: Column(
            children: [
              DashboardTopBar(
                  onNotificationTap: model.onNotificationTap,
                  onSearchTap: model.onSearchTap,
                  onLivesBtnClick: model.onLivesBtnClick,
                  isDating: model.settingAppData?.isDating),
              const SizedBox(height: 3),
              if (model.isLoading)
                Expanded(child: CommonUI.lottieWidget())
              else
                Expanded(
                  child: model.userList.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).noData,
                            style: const TextStyle(
                                color: ColorRes.darkGrey9,
                                fontFamily: FontRes.semiBold,
                                fontSize: 17),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          itemCount: model.userList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Conversation conversation = model.userList[index];
                            ChatUser? chatUser = conversation.user;
                            return InkWell(
                              onTap: () {
                                model.onUserTap(conversation);
                              },
                              onLongPress: () {
                                model.onLongPress(conversation);
                              },
                              child: UserCard(
                                name: chatUser?.username ?? '',
                                age: chatUser?.age ?? '',
                                msg: conversation.lastMsg!.isEmpty ? '' : conversation.lastMsg,
                                time: conversation.time.toString(),
                                image: chatUser?.image ?? '',
                                newMsg: chatUser?.isNewMsg ?? false,
                                tickMark: chatUser?.isHost,
                              ),
                            );
                          },
                        ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (model.bannerAd != null)
                Container(
                  alignment: Alignment.center,
                  width: model.bannerAd?.size.width.toDouble(),
                  height: model.bannerAd?.size.height.toDouble(),
                  child: AdWidget(ad: model.bannerAd!),
                ),
            ],
          ),
        );
      },
    );
  }
}
