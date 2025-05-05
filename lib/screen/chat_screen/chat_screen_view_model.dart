import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/common/video_upload_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/chat.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/bottom_diamond_shop/bottom_diamond_shop.dart';
import 'package:orange_ui/screen/chat_screen/widgets/image_video_msg_sheet.dart';
import 'package:orange_ui/screen/chat_screen/widgets/image_view_page.dart';
import 'package:orange_ui/screen/chat_screen/widgets/item_selection_dialog_android.dart';
import 'package:orange_ui/screen/chat_screen/widgets/item_selection_dialog_ios.dart';
import 'package:orange_ui/screen/chat_screen/widgets/unblock_user_dialog.dart';
import 'package:orange_ui/screen/explore_screen/widgets/reverse_swipe_dialog.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen.dart';
import 'package:orange_ui/screen/user_report_screen/report_sheet.dart';
import 'package:orange_ui/screen/video_preview_screen/video_preview_screen.dart';
import 'package:orange_ui/screen/video_preview_screen/video_preview_screen_view_model.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/app_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:orange_ui/utils/pref_res.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatScreenViewModel extends BaseViewModel {
  var db = FirebaseFirestore.instance;
  late DocumentReference documentSender;
  late DocumentReference documentReceiver;
  late CollectionReference drChatMessages;
  ImagePicker picker = ImagePicker();

  TextEditingController textMsgController = TextEditingController();
  FocusNode msgFocusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  File? chatImage;
  File? cameraImage;
  XFile? _pickedFile;
  String? imagePath = '';
  String selectedItem = S.current.image;
  String blockUnblock = S.current.block;
  List<ChatMessage> chatData = [];
  String deletedId = '';

  StreamSubscription<QuerySnapshot<ChatMessage>>? chatStream;
  StreamSubscription<DocumentSnapshot<Conversation>>? conUserStream;

  Conversation conversation;
  RegistrationUserData? registrationUserData;
  RegistrationUserData? receiverUserData;

  Map<String, List<ChatMessage>>? grouped;
  int startingNumber = 30;
  List<String> notDeletedIdentity = [];
  List<String> timeStamp = [];
  bool isLongPress = false;
  int? walletCoin = 0;
  bool isSelected = false;
  bool isBlock = false;
  bool isBlockOther = false;
  static String senderId = '';

  Appdata? settingAppData;

  ChatScreenViewModel(this.conversation);

  void init() {
    const MethodChannel(Urls.aBubblyCamera).setMethodCallHandler((payload) async {
      if (payload.method == AppRes.isSuccessPurchase && (payload.arguments as bool)) {}
      return;
    });
    senderId = conversation.conversationId ?? '';
    getPrefData();
    scrollToGetChat();
  }

  Future<void> getPrefData() async {
    await PrefService.getUserData().then((value) {
      registrationUserData = value;
      blockUnblock = conversation.block == true ? S.current.unBlock : S.current.block;
      isBlock = conversation.block == true ? true : false;
      isBlockOther = conversation.blockFromOther == true ? true : false;
    });
    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      notifyListeners();
    });
    getProfileAPi();
    initFireBaseData();
  }

  Future<void> getProfileAPi() async {
    ApiProvider().getProfile(userID: conversation.user?.userid).then((value) {
      receiverUserData = value?.data;
      notifyListeners();
    });

    ApiProvider().getProfile(userID: PrefService.userId).then((value) async {
      registrationUserData = value?.data;
      walletCoin = value?.data?.wallet;
      isSelected = await PrefService.getDialog(PrefConst.isMessageDialog) ?? false;
      blockUnblock = value?.data?.blockedUsers?.contains('${conversation.user?.userid}') == true
          ? S.current.unBlock
          : S.current.block;
      notifyListeners();
      await PrefService.saveUser(value?.data);
    });
  }

  /// initialise firebase
  void initFireBaseData() {
    documentReceiver = db
        .collection(FirebaseRes.userChatList)
        .doc('${conversation.user?.userid}')
        .collection(FirebaseRes.userList)
        .doc('${registrationUserData?.id}');
    documentSender = db
        .collection(FirebaseRes.userChatList)
        .doc('${registrationUserData?.id}')
        .collection(FirebaseRes.userList)
        .doc('${conversation.user?.userid}');

    if (conversation.conversationId == null) {
      conversation.setConversationId(
          CommonFun.getConversationID(myId: registrationUserData?.id, otherUserId: conversation.user?.userid));
    }

    drChatMessages = db.collection(FirebaseRes.chat).doc(conversation.conversationId).collection(FirebaseRes.chat);

    getChat();
  }

  Future<void> minusCoinApi() async {
    await ApiProvider().minusCoinFromWallet(settingAppData?.messagePrice);
  }

  void scrollToGetChat() {
    scrollController.addListener(() {
      if (scrollController.offset == scrollController.position.maxScrollExtent) {
        getChat();
      }
    });
  }

  void onUserTap() {
    Get.to(() => UserDetailScreen(
          userId: conversation.user?.userid,
        ));
  }

  void onCancelBtnClick() {
    timeStamp = [];
    notifyListeners();
  }

  /// chat item delete method
  void chatDeleteDialog() {
    Get.dialog(ConfirmationDialog(
      onTap: onDeleteBtnClick,
      description: S.current.afterDeletingTheChatYouCanNotRestoreOurMessage,
      dialogSize: 1.6,
      padding: const EdgeInsets.symmetric(horizontal: 40),
    ));
  }

  void onDeleteBtnClick() {
    for (int i = 0; i < timeStamp.length; i++) {
      drChatMessages.doc(timeStamp[i]).update(
        {
          FirebaseRes.noDeleteIdentity: FieldValue.arrayRemove(
            ['${registrationUserData?.id}'],
          )
        },
      );
      chatData.removeWhere(
        (element) => element.time.toString() == timeStamp[i],
      );
    }
    timeStamp = [];
    Get.back();
    notifyListeners();
  }

  /// long press to select chat method
  void onLongPress(ChatMessage? data) {
    if (!timeStamp.contains('${data?.time?.round()}')) {
      timeStamp.add('${data?.time?.round()}');
    } else {
      timeStamp.remove('${data?.time?.round()}');
    }
    isLongPress = true;
    notifyListeners();
  }

  void unblockDialog() {
    Get.dialog(UnblockUserDialog(
      onCancelBtnClick: () {
        Get.back();
      },
      unblockUser: unBlockUser,
      name: conversation.user?.username,
    ));
  }

  /// more btn event
  Future<void> onMoreBtnTap(String value) async {
    if (value == S.current.block) {
      blockUser();
    }
    if (value == S.current.unBlock) {
      unBlockUser();
    }

    if (value == AppRes.report) {
      Get.bottomSheet(
        ReportSheet(
          reportId: conversation.user?.userid,
          userData: receiverUserData,
          fullName: conversation.user?.username,
          profileImage: conversation.user?.image,
          age: int.parse(conversation.user?.age ?? '0'),
          address: conversation.user?.city,
          reportType: 1,
        ),
        isScrollControlled: true,
      );
    }
  }

  Future<void> blockUser() async {
    ApiProvider().updateBlockList(conversation.user?.userid);
    await documentSender
        .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) {
              return value.toFirestore();
            })
        .update({
      FirebaseRes.block: true,
    });
    await documentReceiver
        .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) {
              return value.toFirestore();
            })
        .update({
      FirebaseRes.blockFromOther: true,
    });
    blockUnblock = S.current.unBlock;
    isBlock = true;
    isBlockOther = true;
    notifyListeners();
  }

  Future<void> unBlockUser() async {
    ApiProvider().updateBlockList(conversation.user?.userid);
    await documentSender
        .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) {
              return value.toFirestore();
            })
        .update({
      FirebaseRes.block: false,
    });
    await documentReceiver
        .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) {
              return value.toFirestore();
            })
        .update({
      FirebaseRes.blockFromOther: false,
    });
    blockUnblock = S.current.block;
    isBlock = false;
    isBlockOther = false;
    notifyListeners();
  }

  /// navigate to imageviewScreen
  void onImageTap(ChatMessage? imageData) {
    Get.to(
      () => ImageViewPage(
        userData: imageData,
        onBack: () {
          Get.back();
        },
      ),
    )?.then((value) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: ColorRes.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ));
    });
  }

  /// send a text message
  void onSendBtnTap() {
    if (conversation.blockFromOther == true) {
      CommonUI.snackBarWidget(S.current.thisUserBlockYou);
      textMsgController.clear();
      return;
    }
    if (registrationUserData?.isFake != 1) {
      if (textMsgController.text.trim() != '') {
        if ((settingAppData?.reverseSwipePrice ?? 0) <= walletCoin! && walletCoin != 0) {
          !isSelected ? getChatMsgDialog(onContinueTap: onTextMsgContinueClick) : onMessageSent();
        } else {
          emptyDialog();
        }
      }
    } else {
      firebaseMsgUpdate(msgType: FirebaseRes.msg, textMessage: textMsgController.text.trim()).then((value) {
        textMsgController.clear();
      });
    }
  }

  void onTextMsgContinueClick(bool isSelected) {
    PrefService.setDialog(PrefConst.isMessageDialog, isSelected);
    minusCoinApi().then(
      (value) {
        Get.back();
        firebaseMsgUpdate(
          msgType: FirebaseRes.msg,
          textMessage: textMsgController.text.trim(),
        );
        textMsgController.clear();
      },
    );
  }

  void onMessageSent() {
    String text = textMsgController.text;
    textMsgController.clear();
    minusCoinApi().then(
      (value) async {
        getProfileAPi();
        firebaseMsgUpdate(msgType: FirebaseRes.msg, textMessage: text.trim());
      },
    );
  }

  void onPlusTap() {
    minusCoinApi().then(
      (value) {
        getProfileAPi();
        onAddBtnTap();
      },
    );
  }

  /// send a image method
  void onSendBtnClick(String msg, String? image) {
    firebaseMsgUpdate(image: image, msgType: FirebaseRes.image, textMessage: msg);
    Get.back();
  }

  void onPlusBtnClick() {
    if (registrationUserData?.isFake != 1) {
      if ((settingAppData?.reverseSwipePrice ?? 0) <= walletCoin! && walletCoin != 0) {
        !isSelected ? getChatMsgDialog(onContinueTap: onPlusContinueClick) : onPlusTap();
      } else {
        emptyDialog();
      }
    } else {
      onAddBtnTap();
    }
  }

  void onPlusContinueClick(bool isSelected) {
    PrefService.setDialog(PrefConst.isMessageDialog, isSelected);
    minusCoinApi().then(
      (value) {
        Get.back();
        onAddBtnTap();
      },
    );
  }

  /// Add btn to choose photo or video method
  void onAddBtnTap() async {
    msgFocusNode.unfocus();
    if (conversation.blockFromOther == true) {
      CommonUI.snackBarWidget(S.current.thisUserBlockYou);
      return;
    }
    Platform.isIOS
        ? Get.bottomSheet(
            ItemSelectionDialogIos(
              onCloseBtnClickIos: () {
                Get.back();
              },
              onImageBtnClickIos: () {
                itemSelectImage();
              },
              onVideoBtnClickIos: itemSelectVideo,
            ),
          )
        : showModalBottomSheet(
            context: Get.context!,
            backgroundColor: ColorRes.transparent,
            builder: (BuildContext context) {
              return ItemSelectionDialogAndroid(
                onCloseBtnClick: () {
                  Get.back();
                },
                onImageBtnClick: itemSelectImage,
                onVideoBtnClick: itemSelectVideo,
              );
            },
          );
  }

  /// selected video or image method
  void itemSelectImage() async {
    selectedItem = S.current.image;
    final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: quality, maxHeight: maxHeight, maxWidth: maxWidth);
    if (photo == null || photo.path.isEmpty) return;
    cameraImage = File(photo.path);
    ApiProvider().getStoreFileGivePath(image: cameraImage).then(
      (value) {
        if (value.status == true) {
          Get.back();
          Get.bottomSheet(
              ImageVideoMsgSheet(image: value.path, onSendBtnClick: onSendBtnClick, selectedItem: selectedItem),
              isScrollControlled: true);
        }
        notifyListeners();
      },
    );
  }

  void itemSelectVideo() async {
    selectedItem = S.current.videoCap;
    _pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );

    if (_pickedFile == null || _pickedFile!.path.isEmpty) return;

    /// calculating file size
    final videoFile = File(_pickedFile?.path ?? '');
    int sizeInBytes = videoFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb <= 15) {
      VideoThumbnail.thumbnailFile(
        video: _pickedFile!.path,
      ).then(
        (value) {
          Get.back();
          Get.bottomSheet(
            ImageVideoMsgSheet(
              image: value,
              selectedItem: selectedItem,
              onSendBtnClick: (msg, image) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return CommonUI.lottieWidget();
                  },
                );
                ApiProvider()
                    .getStoreFileGivePath(
                  image: File(image ?? ''),
                )
                    .then(
                  (value) {
                    imagePath = value.path;
                    ApiProvider().getStoreFileGivePath(image: videoFile).then(
                      (value) {
                        firebaseMsgUpdate(
                            video: value.path, msgType: FirebaseRes.video, textMessage: msg, image: imagePath);
                        Get.back();
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
            isScrollControlled: true,
          );
        },
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return VideoUploadDialog(
            selectAnother: () {
              Get.back();
              itemSelectVideo();
            },
          );
        },
      );
    }
  }

  ///  video preview screen navigate
  void onVideoItemClick(ChatMessage? data) {
    Get.to(() => VideoPreviewScreen(
          videoUrl: data?.video,
          type: VideoType.other,
        ))?.then((value) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: ColorRes.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      );
    });
  }

  void prefCameraTap() {
    minusCoinApi().then(
      (value) {
        getProfileAPi();
        onCameraTap();
      },
    );
  }

  void cameraClick() {
    if (registrationUserData?.isFake != 1) {
      if ((settingAppData?.reverseSwipePrice ?? 0) <= walletCoin! && walletCoin != 0) {
        !isSelected ? getChatMsgDialog(onContinueTap: onCameraContinueClick) : prefCameraTap();
      } else {
        emptyDialog();
      }
    } else {
      onCameraTap();
    }
  }

  void onCameraContinueClick(bool isSelected) {
    PrefService.setDialog(PrefConst.isMessageDialog, isSelected);
    minusCoinApi().then(
      (value) {
        Get.back();
        onCameraTap();
      },
    );
  }

  /// camera button tap
  Future<void> onCameraTap() async {
    if (conversation.blockFromOther == true) {
      CommonUI.snackBarWidget(S.current.thisUserBlockYou);
      textMsgController.clear();
      return;
    }
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.camera.request();

      var allAccepted = true;
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
      if (!allAccepted) {
        openAppSettings();
        return;
      }
    }

    try {
      final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: quality,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          preferredCameraDevice: CameraDevice.front);

      if (photo == null || photo.path.isEmpty) return;
      chatImage = File(photo.path);
      ApiProvider().getStoreFileGivePath(image: chatImage).then(
        (value) {
          if (value.status == true) {
            firebaseMsgUpdate(image: value.path, msgType: FirebaseRes.image);
          }
          notifyListeners();
        },
      );
    } on PlatformException catch (e) {
      CommonUI.snackBarWidget('${e.message}');
    }
  }

  ///User chat method
  void getChat() async {
    await documentSender
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then((value) {
      deletedId = value.data()?.deletedId.toString() ?? '';
      notifyListeners();
    });

    chatStream = drChatMessages
        .where(FirebaseRes.noDeleteIdentity, arrayContains: '${registrationUserData?.id}')
        .where(FirebaseRes.time, isGreaterThan: deletedId.isEmpty ? 0.0 : double.parse(deletedId))
        .orderBy(FirebaseRes.time, descending: true)
        .limit(startingNumber)
        .withConverter(
          fromFirestore: ChatMessage.fromFirestore,
          toFirestore: (ChatMessage value, options) {
            return value.toFirestore();
          },
        )
        .snapshots()
        .listen(
      (element) async {
        chatData = [];

        for (int i = 0; i < element.docs.length; i++) {
          chatData.add(element.docs[i].data());
        }

        grouped = groupBy<ChatMessage, String>(
          chatData,
          (message) {
            final now = DateTime.now();
            DateTime time = DateTime.fromMillisecondsSinceEpoch(message.time!.toInt());
            if (DateFormat(AppRes.dMY).format(DateTime.now()) == DateFormat(AppRes.dMY).format(time)) {
              return S.current.today;
            }
            if (DateFormat(AppRes.dMY).format(DateTime(now.year, now.month, now.day - 1)) ==
                DateFormat(AppRes.dMY).format(time)) {
              return S.current.yesterday;
            } else {
              return DateFormat(AppRes.dMY).format(time);
            }
          },
        );
        startingNumber += 45;
        notifyListeners();
      },
    );
  }

  ///Firebase message update method
  Future<void> firebaseMsgUpdate({required String msgType, String? textMessage, String? image, String? video}) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    notDeletedIdentity = [];
    notDeletedIdentity.addAll(['${registrationUserData?.id}', '${conversation.user?.userid}']);

    drChatMessages.doc(time.toString()).set(ChatMessage(
            notDeletedIdentities: notDeletedIdentity,
            senderUser: ChatUser(
                username: registrationUserData?.fullname,
                date: time.toDouble(),
                isHost: false,
                isNewMsg: true,
                userid: registrationUserData?.id,
                userIdentity: registrationUserData?.identity,
                image: CommonFun.getProfileImage(images: registrationUserData?.images),
                city: registrationUserData?.live,
                age: registrationUserData?.age.toString()),
            msgType: msgType,
            msg: textMessage,
            image: image,
            video: video,
            id: conversation.user?.userid?.toString(),
            time: time.toDouble())
        .toJson());

    if (chatData.isEmpty && deletedId.isEmpty) {
      Map con = conversation.toJson();
      con[FirebaseRes.lastMsg] = CommonFun.getLastMsg(msgType: msgType, msg: textMessage ?? '');
      documentSender.set(con);
      documentReceiver.set(
        Conversation(
          block: false,
          blockFromOther: false,
          conversationId: conversation.conversationId,
          deletedId: '',
          isDeleted: false,
          isMute: false,
          lastMsg: CommonFun.getLastMsg(msgType: msgType, msg: textMessage ?? ''),
          newMsg: textMessage,
          time: time.toDouble(),
          user: ChatUser(
            username: registrationUserData?.fullname,
            date: time.toDouble(),
            isHost: registrationUserData?.isVerified == 2 ? true : false,
            isNewMsg: true,
            userid: registrationUserData?.id,
            userIdentity: registrationUserData?.identity,
            image: CommonFun.getProfileImage(images: registrationUserData?.images),
            city: registrationUserData?.live,
            age: registrationUserData?.age.toString(),
          ),
        ).toJson(),
      );
    } else {
      await documentReceiver
          .withConverter(
            fromFirestore: Conversation.fromFirestore,
            toFirestore: (Conversation value, options) => value.toFirestore(),
          )
          .get()
          .then(
        (value) {
          ChatUser? receiverUser = value.data()?.user;
          receiverUser?.isNewMsg = true;
          documentReceiver.update(
            {
              FirebaseRes.isDeleted: false,
              FirebaseRes.time: time.toDouble(),
              FirebaseRes.lastMsg: CommonFun.getLastMsg(msgType: msgType, msg: textMessage ?? ''),
              FirebaseRes.user: receiverUser?.toJson(),
            },
          );
        },
      );

      documentSender.update(
        {
          FirebaseRes.isDeleted: false,
          FirebaseRes.time: time.toDouble(),
          FirebaseRes.lastMsg: CommonFun.getLastMsg(msgType: msgType, msg: textMessage ?? '')
        },
      );
    }
    receiverUserData?.isNotification == 1
        ? ApiProvider().pushNotification(
            title: registrationUserData?.fullname ?? '',
            body: CommonFun.getLastMsg(msgType: msgType, msg: textMessage ?? ''),
            conversationId: conversation.conversationId ?? '',
            deviceType: receiverUserData?.deviceType,
            token: '${receiverUserData?.deviceToken}',
          )
        : null;
  }

  void emptyDialog() {
    Get.dialog(
      EmptyWalletDialog(
          onCancelTap: () {
            Get.back();
          },
          onContinueTap: () {
            Get.back();
            Get.bottomSheet(const BottomDiamondShop());
          },
          walletCoin: walletCoin),
    );
  }

  void getChatMsgDialog({required Function(bool isSelected) onContinueTap}) {
    Get.dialog(
      ReverseSwipeDialog(
          onCancelTap: () {
            Get.back();
          },
          onContinueTap: onContinueTap,
          isCheckBoxVisible: true,
          walletCoin: walletCoin,
          title1: S.current.message.toUpperCase(),
          title2: S.current.priceCap,
          dialogDisc: AppRes.messageDisc(settingAppData?.messagePrice),
          coinPrice: '${settingAppData?.messagePrice ?? 0}'),
    ).then((value) {
      getProfileAPi();
    });
  }

  /// Dispose Method
  @override
  void dispose() {
    documentSender
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then(
      (value) {
        var senderUser = value.data()?.user;
        senderUser?.isNewMsg = false;
        documentSender.update(
          {FirebaseRes.user: senderUser?.toJson()},
        );
      },
    );
    chatStream?.cancel();
    conUserStream?.cancel();
    scrollController.dispose();
    textMsgController.dispose();
    senderId = '';
    super.dispose();
  }
}
