import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/firebase_res.dart';

const yourSelectedPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 2);
const yourPadding = EdgeInsets.symmetric(horizontal: 10);
const yourSelectedMargin = EdgeInsets.symmetric(vertical: 0);
const yourMargin = EdgeInsets.symmetric(vertical: 2);
final selectedColor = ColorRes.lightOrange.withOpacity(0.3);
final selectedColor1 = ColorRes.darkOrange.withOpacity(0.3);
const dateStyle = TextStyle(
  color: ColorRes.grey2,
  fontSize: 12,
);

class ChatArea extends StatelessWidget {
  final Map<String, List<ChatMessage>>? chatData;
  final Function(ChatMessage? imageData) onImageTap;
  final ScrollController scrollController;
  final Function(ChatMessage? item) onVideoItemClick;
  final Function(ChatMessage? chatMessage) onLongPress;
  final List<String> timeStamp;

  const ChatArea({
    Key? key,
    required this.chatData,
    required this.onImageTap,
    required this.scrollController,
    required this.onVideoItemClick,
    required this.onLongPress,
    required this.timeStamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView.builder(
          controller: scrollController,
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: chatData != null ? chatData?.keys.length : 0,
          physics: Platform.isAndroid ? const ClampingScrollPhysics() : const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            String? date = chatData?.keys.elementAt(index) ?? '';
            List<ChatMessage>? messages = chatData?[date];
            return Column(
              children: [
                alertView(date),
                ListView.builder(
                  itemCount: messages?.length,
                  reverse: true,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      child: messages?[index].senderUser?.userid == PrefService.userId
                          ? yourMsg(messages?[index])
                          : otherUserMsg(messages?[index]),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget yourMsg(ChatMessage? data) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return GestureDetector(
      onLongPress: () {
        onLongPress(data);
      },
      onTap: () {
        timeStamp.isNotEmpty ? onLongPress(data) : () {};
      },
      child: Container(
        padding: selected ? yourSelectedPadding : yourPadding,
        margin: selected ? yourSelectedMargin : yourMargin,
        decoration: BoxDecoration(
          color: selected ? selectedColor1 : ColorRes.white,
          borderRadius: selected ? BorderRadius.circular(0) : BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                DateFormat(AppRes.hmmA).format(
                  DateTime.fromMillisecondsSinceEpoch(
                    data!.time!.toInt(),
                  ),
                ),
                style: dateStyle),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    selected ? selectedColor : ColorRes.lightOrange,
                    selected ? selectedColor1 : ColorRes.darkOrange,
                  ],
                ),
              ),
              child: data.msgType == FirebaseRes.msg
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Get.width / 1.4,
                        minWidth: 100,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(11, 13, 8, 11),
                        child: Text(
                          data.msg ?? '',
                          style: const TextStyle(color: ColorRes.white),
                        ),
                      ),
                    )
                  : data.msgType == FirebaseRes.image
                      ? imageView(data)
                      : videoView(data),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherUserMsg(ChatMessage? data) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return GestureDetector(
      onLongPress: () {
        onLongPress(data);
      },
      onTap: () {
        timeStamp.isNotEmpty ? onLongPress(data) : () {};
      },
      child: Container(
        padding: selected ? yourSelectedPadding : yourPadding,
        margin: selected ? yourSelectedMargin : yourMargin,
        decoration: BoxDecoration(
          color: selected ? selectedColor1 : ColorRes.white,
          borderRadius: selected ? BorderRadius.circular(0) : BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: selected ? ColorRes.grey10.withOpacity(0.7) : ColorRes.grey10,
              ),
              child: data?.msgType == FirebaseRes.msg
                  ? ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Get.width / 1.4,
                        minWidth: 100,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 13, 12, 11),
                        child: Text(
                          '${data?.msg}',
                          style: const TextStyle(color: ColorRes.darkGrey),
                        ),
                      ),
                    )
                  : data?.msgType == FirebaseRes.image
                      ? imageView(data)
                      : videoView(data),
            ),
            const SizedBox(width: 10),
            Text(
                DateFormat(AppRes.hmmA).format(
                  DateTime.fromMillisecondsSinceEpoch(
                    data!.time!.toInt(),
                  ),
                ),
                style: dateStyle),
          ],
        ),
      ),
    );
  }

  Widget imageView(ChatMessage? data) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          onImageTap(data);
        },
        child: imageVideoContainer(
            child: Column(
              children: [
                Stack(
                  children: [imageVideoPost(data: data), imageVideoPostColor(selected: selected)],
                ),
                imageVideoPostMessage(data: data)
              ],
            ),
            selected: selected,
            data: data));
  }

  Widget videoView(ChatMessage? data) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    return InkWell(
        onTap: () {
          onVideoItemClick(data);
        },
        child: imageVideoContainer(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [imageVideoPost(data: data), imageVideoPostColor(selected: selected)],
                    ),
                    imageVideoPostMessage(data: data)
                  ],
                ),
                Container(
                  height: 31,
                  width: 31,
                  decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      AssetRes.playButton,
                      height: 16,
                      width: 15,
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ],
            ),
            selected: selected,
            data: data));
  }

  Widget alertView(String? time) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: ColorRes.grey13,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '$time',
          style: const TextStyle(color: ColorRes.darkGrey9, fontSize: 11),
        ),
      ),
    );
  }

  Widget imageVideoContainer({required Widget child, required bool selected, required ChatMessage? data}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: data?.senderUser?.userid == PrefService.userId
            ? null
            : selected
                ? ColorRes.grey13.withOpacity(0.4)
                : ColorRes.grey13,
        gradient: data?.senderUser?.userid == PrefService.userId
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  selected ? selectedColor : ColorRes.lightOrange,
                  selected ? selectedColor1 : ColorRes.darkOrange,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }

  Widget imageVideoPostColor({required bool selected}) {
    return Container(
      height: 171,
      width: 171,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            selected ? selectedColor : ColorRes.transparent,
            selected ? selectedColor1 : ColorRes.transparent,
          ],
        ),
      ),
    );
  }

  Widget imageVideoPost({ChatMessage? data}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: CachedNetworkImage(
          imageUrl: '${ConstRes.aImageBaseUrl}${data?.image}',
          height: 171,
          width: 171,
          fit: BoxFit.cover,
          cacheKey: '${data?.image}',
          repeat: ImageRepeat.noRepeat),
    );
  }

  Widget imageVideoPostMessage({ChatMessage? data}) {
    return data == null || data.msg == null || data.msg!.isEmpty
        ? const SizedBox()
        : Container(
            width: 171,
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              '${data.msg}',
              style: TextStyle(
                color: data.senderUser?.userid == PrefService.userId ? ColorRes.white : ColorRes.darkGrey,
              ),
            ),
          );
  }
}
