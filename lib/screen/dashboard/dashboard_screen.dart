import 'package:flutter/material.dart';
import 'package:orange_ui/screen/dashboard/dashboard_screen_view_model.dart';
import 'package:orange_ui/screen/dashboard/widgets/bottom_bar.dart';
import 'package:orange_ui/screen/explore_screen/explore_screen.dart';
import 'package:orange_ui/screen/feed_screen/feed_screen.dart';
import 'package:orange_ui/screen/message_screen/message_screen.dart';
import 'package:orange_ui/screen/profile_screen/profile_screen.dart';
import 'package:orange_ui/screen/randoms_screen/randoms_screen.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => DashboardScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          bottomNavigationBar: BottomBar(
            pageIndex: model.pageIndex,
            onBottomBarTap: model.onBottomBarTap,
            settingAppData: model.settingAppData,
          ),
          body: SafeArea(
            bottom: false,
            child: model.pageIndex == 0
                ? const ExploreScreen()
                : model.pageIndex == 1
                    ? const RandomsScreen()
                    : model.pageIndex == 2
                        ? const FeedScreen()
                        : model.pageIndex == 3
                            ? const MessageScreen()
                            : const ProfileScreen(),
          ),
        );
      },
    );
  }
}
