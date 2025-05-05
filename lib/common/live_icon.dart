import 'package:flutter/material.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';

class LiveIcon extends StatelessWidget {
  const LiveIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetRes.icLive,
      color: ColorRes.darkOrange,
    );
  }
}
