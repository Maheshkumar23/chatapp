import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/screen/camera_preview_screen/camera_preview_screen_view_model.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/style_res.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class CameraPreviewScreen extends StatelessWidget {
  final XFile xFile;
  final int type;

  const CameraPreviewScreen({Key? key, required this.xFile, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CameraPreviewScreenViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => CameraPreviewScreenViewModel(xFile, type),
      builder: (context, model, child) => Scaffold(
        backgroundColor: ColorRes.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            type == 0
                ? Image.file(File(xFile.path))
                : !model.videoPlayerController.value.isInitialized
                    ? const SizedBox()
                    : AspectRatio(
                        aspectRatio: model.videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(model.videoPlayerController)),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        gradient: StyleRes.linearGradient),
                    child: const Icon(Icons.close, color: ColorRes.white, size: 25),
                  ),
                ),
              ),
            ),
            type == 0
                ? const SizedBox()
                : Align(
                    alignment: Alignment.center,
                    child: ValueListenableBuilder(
                      valueListenable: model.videoPlayerController,
                      builder: (context, VideoPlayerValue value, child) => AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: value.isPlaying ? 1.0 : 1.0,
                        child: InkWell(
                          onTap: model.videoPlayPause,
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                color: ColorRes.black.withOpacity(0.4)),
                            alignment: Alignment.center,
                            child: Image.asset(value.isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                                color: ColorRes.white, width: 20, height: 20, alignment: Alignment.centerRight),
                          ),
                        ),
                      ),
                    ),
                  ),
            SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    type == 0
                        ? const SizedBox()
                        : ValueListenableBuilder(
                            valueListenable: model.videoPlayerController,
                            builder: (context, VideoPlayerValue value, child) => Container(
                              height: 50,
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  color: ColorRes.black.withOpacity(0.4)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 35,
                                    child: Text(
                                      CommonFun.printDuration(value.position),
                                      style: const TextStyle(
                                          color: ColorRes.white,
                                          fontFamily: FontRes.light,
                                          fontSize: 12,
                                          letterSpacing: 0.5),
                                    ),
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        trackHeight: 2,
                                        overlayShape: SliderComponentShape.noOverlay,
                                      ),
                                      child: Slider(
                                          value: value.position.inMicroseconds.toDouble(),
                                          max: value.duration.inMicroseconds.toDouble(),
                                          activeColor: ColorRes.darkOrange,
                                          onChanged: model.onChangeSlider,
                                          onChangeEnd: model.onChangeSliderEnd,
                                          onChangeStart: model.onChangeSliderStart,
                                          inactiveColor: ColorRes.dimGrey3),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    CommonFun.printDuration(value.duration),
                                    style: const TextStyle(
                                        color: ColorRes.white,
                                        fontFamily: FontRes.light,
                                        fontSize: 12,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    InkWell(
                      onTap: model.onCheckBtnClick,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: AppBar().preferredSize.height / 2),
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            gradient: StyleRes.linearGradient),
                        child: const Icon(Icons.check_rounded, color: ColorRes.white, size: 32),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
