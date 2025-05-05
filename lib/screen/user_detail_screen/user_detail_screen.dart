import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_fun.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/shimmer_screen/shimmer_screen.dart';
import 'package:orange_ui/screen/user_detail_screen/user_detail_screen_view_model.dart';
import 'package:orange_ui/screen/user_detail_screen/widgets/detail_page.dart';
import 'package:orange_ui/screen/user_detail_screen/widgets/image_selection_area.dart';
import 'package:orange_ui/screen/user_detail_screen/widgets/top_bar.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:stacked/stacked.dart';

class UserDetailScreen extends StatefulWidget {
  final bool? showInfo;
  final RegistrationUserData? userData;
  final int? userId;

  const UserDetailScreen({Key? key, this.showInfo, this.userData, this.userId}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn, reverseCurve: Curves.fastOutSlowIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserDetailScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init(model.moreInfo);
      },
      viewModelBuilder: () => UserDetailScreenViewModel(userData: widget.userData, userId: widget.userId),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              model.isLoading
                  ? ShimmerScreen.rectangular(
                      height: Get.height,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    )
                  : Container(
                      height: Get.height,
                      width: Get.width,
                      color: ColorRes.darkOrange.withOpacity(0.2),
                      child: CachedNetworkImage(
                        imageUrl:
                            CommonFun.getProfileImage(images: model.userData?.images, index: model.selectedImgIndex),
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
                          return CommonUI.profileImagePlaceHolder(
                              name: CommonUI.fullName(model.userData?.fullname),
                              heightWidth: Get.height,
                              borderRadius: 0);
                        },
                      ),
                    ),
              Column(
                children: [
                  TopBar(model: model),
                  Expanded(
                    child: !model.moreInfo
                        ? ImageSelectionArea(
                            model: model,
                            onMoreInfoTap: () {
                              model.moreInfo = true;
                              _controller.forward();
                              setState(() {});
                            },
                          )
                        : SlideTransition(
                            position: _animation,
                            transformHitTests: true,
                            child: DetailPage(
                              model: model,
                              onHideBtnTap: () {
                                _controller.reverse().then((value) {
                                  model.moreInfo = false;
                                  setState(() {});
                                });
                              },
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
