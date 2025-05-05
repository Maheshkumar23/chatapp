import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:orange_ui/common/common_ui.dart';

import 'package:orange_ui/screen/search_screen/search_screen_view_model.dart';
import 'package:orange_ui/screen/search_screen/widgets/search_bar_area.dart';
import 'package:orange_ui/screen/search_screen/widgets/user_list.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => SearchScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorRes.white,
          body: Column(
            children: [
              SearchBarArea(
                searchController: model.searchController,
                selectedTab: model.selectedTab,
                tabList: model.tabList,
                onBackBtnTap: model.onBackBtnTap,
                onSearchBtnTap: model.onSearchingUser,
                onLocationTap: model.onLocationTap,
                onTabSelect: model.onTabSelect,
              ),
              const SizedBox(height: 11),
              model.isLoading
                  ? Expanded(child: CommonUI.lottieWidget())
                  : UserList(
                      controller: model.userScrollController,
                      userList: model.searchUsers,
                      onUserTap: model.onUserTap,
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
