import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/chat_and_live_stream/live_stream.dart';
import 'package:orange_ui/screen/livestream_end_screen/livestream_end_screen_view_model.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class LivestreamEndScreen extends StatefulWidget {
  final LiveStreamUser liveStreamUser;
  final String dateTime;
  final String duration;

  const LivestreamEndScreen({Key? key, required this.liveStreamUser, required this.dateTime, required this.duration})
      : super(key: key);

  @override
  State<LivestreamEndScreen> createState() => _LivestreamEndScreenState();
}

class _LivestreamEndScreenState extends State<LivestreamEndScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ViewModelBuilder<LivestreamEndScreenViewModel>.reactive(
          onViewModelReady: (model) {
            model.init(widget.liveStreamUser, widget.dateTime, widget.duration);
          },
          viewModelBuilder: () => LivestreamEndScreenViewModel(),
          builder: (context, model, child) {
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      height: Get.height / 2,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(AssetRes.worldMap),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SpinKitRipple(
                            borderWidth: 100,
                            duration: const Duration(milliseconds: 1500),
                            size: Get.width / 1.1,
                            //color: ColorRes.o,
                            itemBuilder: (BuildContext context, int index) {
                              return CircleAvatar(
                                backgroundColor: ColorRes.grey21.withOpacity(0.40),
                              );
                            },
                          ),
                          SpinKitRipple(
                            borderWidth: 50,
                            duration: const Duration(milliseconds: 1500),
                            size: Get.width / 1.5,
                            //color: ColorRes.o,
                            itemBuilder: (BuildContext context, int index) {
                              return CircleAvatar(
                                backgroundColor: ColorRes.grey21.withOpacity(0.30),
                              );
                            },
                          ),
                          ClipOval(
                            child: Image.network(
                              '${widget.liveStreamUser.userImage}',
                              height: Get.width / 2.5,
                              width: Get.width / 2.5,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return CommonUI.profileImagePlaceHolder(
                                  name: widget.liveStreamUser.fullName,
                                  heightWidth: Get.width / 2.5,
                                  borderRadius: 90,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    ScaleTransition(
                      scale: _animation,
                      child: Text(
                        S.of(context).yourLiveStreamHasBeenEndednbelowIsASummaryOf,
                        style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            SizeTransition(
                              sizeFactor: _animation,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: Text(widget.duration,
                                  style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15)),
                            ),
                            Text(
                              S.of(context).streamFor,
                              style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizeTransition(
                              sizeFactor: _animation,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: Text('${widget.liveStreamUser.joinedUser?.length ?? 0}',
                                  style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15)),
                            ),
                            Text(
                              S.of(context).users,
                              style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizeTransition(
                              sizeFactor: _animation,
                              axis: Axis.horizontal,
                              axisAlignment: -1,
                              child: Text('${widget.liveStreamUser.collectedDiamond ?? 0}',
                                  style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15)),
                            ),
                            Text(
                              '💎 ${S.of(context).collected}',
                              style: const TextStyle(fontFamily: FontRes.semiBold, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 50,
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: ColorRes.darkOrange.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              S.current.ok,
                              style: const TextStyle(
                                  color: ColorRes.darkOrange,
                                  fontFamily: FontRes.heavy,
                                  letterSpacing: 0.8,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
