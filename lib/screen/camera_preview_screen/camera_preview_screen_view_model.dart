import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange_ui/api_provider/api_provider.dart';
import 'package:orange_ui/service/pref_service.dart';
import 'package:orange_ui/utils/urls.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class CameraPreviewScreenViewModel extends BaseViewModel {
  late VideoPlayerController videoPlayerController;
  XFile xFile;
  int type;
  bool isPlaying = false;
  CameraPreviewScreenViewModel(this.xFile, this.type);

  init() {
    if (type == 1) {
      videoPlayerController = VideoPlayerController.file(File(xFile.path))
        ..initialize().then((value) {
          videoPlayerController.play();
          videoPlayerController.setLooping(true);
          notifyListeners();
        });
    }
  }

  void onCheckBtnClick() {
    // For Images
    if (type == 0) {
      createStoryApiCall(duration: 0, xFile: xFile);
    } else {
      createStoryApiCall(
          duration: videoPlayerController.value.duration.inSeconds,
          xFile: xFile);
    }
  }

  void createStoryApiCall({required XFile xFile, required int duration}) {
    ApiProvider().multiPartCallApi(
        url: Urls.aCreateStory,
        completion: (response) {
          Get.back();
          Get.back();
        },
        param: {
          Urls.userId: PrefService.userId,
          Urls.type: type,
          Urls.aDuration: duration
        },
        filesMap: {
          Urls.content: [xFile]
        });
  }

  void videoPlayPause() {
    if (videoPlayerController.value.isPlaying) {
      isPlaying = false;
      videoPlayerController.pause();
    } else {
      isPlaying = true;
      videoPlayerController.play();
    }
    notifyListeners();
  }

  void onChangeSlider(double value) {
    videoPlayerController.seekTo(
      Duration(microseconds: value.toInt()),
    );
  }

  void onChangeSliderEnd(double value) {
    if (isPlaying) {
      videoPlayerController.play();
    }
  }

  void onChangeSliderStart(double value) {
    if (isPlaying) {
      videoPlayerController.pause();
    }
  }

  @override
  void dispose() {
    if (type == 1) {
      videoPlayerController.dispose();
    }
    super.dispose();
  }
}
