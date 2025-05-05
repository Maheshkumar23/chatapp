import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/screen/chat_screen/chat_screen_view_model.dart';
import 'package:orange_ui/screen/chat_screen/widgets/bottom_input_bar.dart';
import 'package:orange_ui/screen/chat_screen/widgets/bottom_selected_item_bar.dart';
import 'package:orange_ui/screen/chat_screen/widgets/chat_area.dart';
import 'package:orange_ui/screen/chat_screen/widgets/chat_top_bar_area.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class ChatScreen extends StatelessWidget {
  final Conversation conversation;

  const ChatScreen({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => ChatScreenViewModel(conversation),
      builder: (context, model, child) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: Column(
            children: [
              ChatTopBarArea(
                conversation: model.conversation,
                onMoreBtnTap: model.onMoreBtnTap,
                blockUnblock: model.blockUnblock,
                onUserTap: model.onUserTap,
                msgFocusNode: model.msgFocusNode,
              ),
              ChatArea(
                chatData: model.grouped,
                onImageTap: model.onImageTap,
                scrollController: model.scrollController,
                onVideoItemClick: model.onVideoItemClick,
                onLongPress: model.onLongPress,
                timeStamp: model.timeStamp,
              ),
              if (model.timeStamp.isNotEmpty)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0.0),
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                        child: child);
                  },
                  child: BottomSelectedItemBar(
                      onCancelBtnClick: model.onCancelBtnClick,
                      selectedItemCount: model.timeStamp.length,
                      onItemDelete: model.chatDeleteDialog),
                )
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0.0),
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                        child: child);
                  },
                  child: model.isBlock == true
                      ? Center(
                          child: InkWell(
                            onTap: model.unblockDialog,
                            splashColor: ColorRes.transparent,
                            highlightColor: ColorRes.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                              decoration: BoxDecoration(
                                color: ColorRes.grey13,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 13),
                              child: Text(
                                S.current.youBlockThisUser,
                                style: const TextStyle(color: ColorRes.darkGrey9, fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      : BottomInputBar(
                          msgController: model.textMsgController,
                          msgFocusNode: model.msgFocusNode,
                          onShareBtnTap: model.onSendBtnTap,
                          onAddBtnTap: model.onPlusBtnClick,
                          onCameraTap: model.cameraClick,
                        ),
                )
            ],
          ),
        );
      },
    );
  }
}
