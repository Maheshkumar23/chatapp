import 'package:flutter/material.dart';
import 'package:orange_ui/screen/get_started_screen/get_started_screen_view_model.dart';
import 'package:orange_ui/screen/get_started_screen/widget/screen1.dart';
import 'package:orange_ui/screen/get_started_screen/widget/screen2.dart';
import 'package:orange_ui/screen/get_started_screen/widget/screen3.dart';
import 'package:orange_ui/screen/get_started_screen/widget/screen4.dart';
import 'package:stacked/stacked.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GetStartedScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => GetStartedScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: model.screenIndex == 0
              ? Screen1(onTap: model.screen1NextTap, model: model)
              : model.screenIndex == 1
                  ? Screen2(onNextTap: model.screen2NextTap, onSkipTap: model.onSkipTap)
                  : model.screenIndex == 2
                      ? Screen3(onNextTap: model.screen3NextTap, onSkipTap: model.onSkipTap)
                      : model.screenIndex == 3
                          ? Screen4(onNextTap: model.screen4NextTap, onSkipTap: model.onSkipTap)
                          : const SizedBox(),
        );
      },
    );
  }
}
