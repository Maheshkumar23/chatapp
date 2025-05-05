import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/common/confirmation_dialog.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/live_stream.dart';
import 'package:orange_ui/model/setting.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/livestream_end_screen/livestream_end_screen.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/firebase_res.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RandomStreamingScreenViewModel extends BaseViewModel {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String channelId = '';
  String token = '';
  String? identity;
  late RtcEngine engine;
  int streamId = -1;
  bool isBroadcaster = true;
  bool muted = false;

  bool localUserJoined = false;

  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  List<LiveStreamComment> commentList = [];
  final users = <int>[];
  LiveStreamUser liveStreamUser;
  DocumentReference? collectionReference;
  RegistrationUserData? registrationUserData;
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;
  String elapsedTime = '';
  List<String> timeAdd = [];
  ScrollController scrollController = ScrollController();
  DateTime? dateTime;
  Timer? minimumUserLiveTimer;
  int countTimer = 0;
  int maxMinutes = 0;

  Appdata? settingAppData;

  RandomStreamingScreenViewModel(
      {required this.liveStreamUser, this.registrationUserData, this.settingAppData});

  void init() {
    WakelockPlus.enable();
    channelId = liveStreamUser.hostIdentity ?? '';
    token = liveStreamUser.agoraToken ?? '';
    getValueFromPrefs();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    // Create RtcEngine instance
    engine = createAgoraRtcEngine();

    // Initialize RtcEngine and set the channel profile to live broadcasting
    await engine.initialize(const RtcEngineContext(
        appId: ConstRes.agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));
    // Enable the video module
    await engine.enableVideo();
    // Enable local video preview
    await engine.startPreview();
    startWatch();

    await engine.joinChannel(
      token: token,
      channelId: channelId,
      options: const ChannelMediaOptions(
          // Set the user role as host
          // To set the user role to audience, change clientRoleBroadcaster to clientRoleAudience
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency),
      uid: 0,
    );

    // Add an event handler
    engine.registerEventHandler(
      RtcEngineEventHandler(
        // Occurs when the local user joins the channel successfully
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _updateLiveStreamUser();
          localUserJoined = true;
          notifyListeners();
        },
        // Occurs when a remote user join the channel
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          notifyListeners();
        },
        // Occurs when a remote user leaves the channel
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          notifyListeners();
        },
      ),
    );
  }

  Future<void> _updateLiveStreamUser() async {
    await db
        .collection(FirebaseRes.liveHostList)
        .doc('${registrationUserData?.id}')
        .set(liveStreamUser.toJson());
    notifyListeners();
  }

  Future<void> getValueFromPrefs() async {
    PrefService.getUserData().then((value) {
      identity = value?.identity;
    });

    PrefService.getSettingData().then((value) {
      settingAppData = value?.appdata;
      maxMinutes = (settingAppData?.maxMinuteLive ?? 0) * 60;
      notifyListeners();
    });
    initializeFireStore();
  }

  void onEndVideoTap() async {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    // Stop timer and close resources
    stopWatch();
    disClosed();
    CommonUI.getLottieLoader();
    LiveStreamUser user = liveStreamUser;

    // Delete live stream data from Firestore
    await _deleteLiveStreamData();
    Get.back();
    // Navigate to end screen
    Get.off(() => LivestreamEndScreen(
        liveStreamUser: user, dateTime: dateTime.toString(), duration: elapsedTime));
  }

  Future<void> _deleteLiveStreamData() async {
    await db.collection(FirebaseRes.liveHostList).doc('${registrationUserData?.id}').delete();
    final batch = db.batch();
    var collection = db
        .collection(FirebaseRes.liveHostList)
        .doc('${registrationUserData?.id}')
        .collection(FirebaseRes.comments);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  void disClosed() {
    // clear users
    users.clear();
    // destroy sdk and leave channel
    _dispose();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel(); // Leave the channel
    await engine.release(); // Release resources
  }

  void onEndBtnTap() async {
    Get.dialog(ConfirmationDialog(
      onTap: onEndVideoTap,
      description: S.current.areYouSureYouWantToEnd,
      textImage: '',
      textButton: S.current.end,
      dialogSize: 1.9,
      padding: const EdgeInsets.symmetric(horizontal: 40),
    ));
  }

  void onCameraTap() {
    engine.switchCamera();
  }

  void onSpeakerTap() {
    muted = !muted;
    notifyListeners();
    engine.muteLocalAudioStream(muted);
    engine.muteAllRemoteAudioStreams(muted);
  }

  void onDiamondTap() {}

  void onCommentSend() {
    if (commentController.text.trim().isNotEmpty) {
      collectionReference?.collection(FirebaseRes.comments).add(LiveStreamComment(
            id: DateTime.now().millisecondsSinceEpoch,
            userImage: CommonFun.getProfileImage(images: registrationUserData?.images),
            userId: registrationUserData?.id,
            city: registrationUserData?.live ?? '',
            isHost: false,
            comment: commentController.text.trim(),
            commentType: FirebaseRes.msg,
            userName: registrationUserData?.fullname ?? '',
          ).toJson());
    }
    commentController.clear();
    commentFocus.unfocus();
  }

  void onBackBtnTap() {
    Get.back();
  }

  void initializeFireStore() {
    collectionReference =
        db.collection(FirebaseRes.liveHostList).doc('${registrationUserData?.id}');
    listenToLiveStreamUser();
    listenToComments();
  }

  void listenToLiveStreamUser() {
    collectionReference
        ?.withConverter<LiveStreamUser>(
          fromFirestore: (snapshot, options) => LiveStreamUser.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        liveStreamUser = snapshot.data()!;
        minimumUserLiveTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
          countTimer++;
          if (countTimer == maxMinutes &&
              (liveStreamUser.watchingCount ?? 0) <= (settingAppData?.minUserLive ?? 0)) {
            timer.cancel();
            onEndVideoTap();
          }
          if (countTimer == maxMinutes) {
            countTimer = 0;
          }
        });
        notifyListeners();
      }
    });
  }

  void listenToComments() {
    collectionReference
        ?.collection(FirebaseRes.comments)
        .orderBy(FirebaseRes.id, descending: true)
        .withConverter<LiveStreamComment>(
          fromFirestore: (snapshot, options) => LiveStreamComment.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        )
        .snapshots()
        .listen((snapshot) {
      commentList.clear(); // Clear previous comments
      for (var doc in snapshot.docs) {
        commentList.add(doc.data()); // Add each comment to the list
      }
      notifyListeners(); // Notify listeners after all comments are added
    });
  }

  // void initializeFireStore() {
  //   PrefService.getUserData().then((value) {
  //     registrationUserData = value;
  //
  //     collectionReference =
  //         db.collection(FirebaseRes.liveHostList).doc('${registrationUserData?.id}');
  //
  //     collectionReference
  //         ?.withConverter(
  //           fromFirestore: LiveStreamUser.fromFirestore,
  //           toFirestore: (LiveStreamUser value, options) {
  //             return LiveStreamUser().toFirestore();
  //           },
  //         )
  //         .snapshots()
  //         .any((element) {
  //       liveStreamUser = element.data()!;
  //       minimumUserLiveTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
  //         countTimer++;
  //         if (countTimer == maxMinutes &&
  //             liveStreamUser.watchingCount! <= (settingAppData?.minUserLive ?? 0)) {
  //           timer.cancel();
  //           onEndVideoTap();
  //         }
  //         if (countTimer == maxMinutes) {
  //           countTimer = 0;
  //         }
  //       });
  //       notifyListeners();
  //       return false;
  //     });
  //     collectionReference
  //         ?.collection(FirebaseRes.comments)
  //         .orderBy(FirebaseRes.id, descending: true)
  //         .withConverter(
  //           fromFirestore: LiveStreamComment.fromFirestore,
  //           toFirestore: (LiveStreamComment value, options) {
  //             return value.toFirestore();
  //           },
  //         )
  //         .snapshots()
  //         .any((element) {
  //       commentList = [];
  //       for (int i = 0; i < element.docs.length; i++) {
  //         commentList.add(element.docs[i].data());
  //         notifyListeners();
  //       }
  //       return false;
  //     });
  //   });
  // }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      notifyListeners();
    }
  }

  void startWatch() {
    startStop = false;
    watch.start();
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    dateTime = DateTime.now();
    notifyListeners();
  }

  void stopWatch() {
    startStop = true;
    watch.stop();
    setTime();
    PrefService.saveString(FirebaseRes.time, elapsedTime);
    notifyListeners();
  }

  void setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    elapsedTime = transformMilliSeconds(timeSoFar);
    notifyListeners();
  }

  String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    minimumUserLiveTimer?.cancel();
    scrollController.dispose();
    commentController.dispose();
    timer.cancel();
    // destroy sdk and leave channel
    _dispose();
    super.dispose();
  }
}
