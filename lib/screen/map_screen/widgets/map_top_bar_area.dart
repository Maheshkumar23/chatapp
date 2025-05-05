import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/dashboard_top_bar.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class MapTopBarArea extends StatelessWidget {
  final List<int> distanceList;
  final int selectedDistance;
  final Function(int value) onDistanceChange;

  const MapTopBarArea({
    Key? key,
    required this.distanceList,
    required this.selectedDistance,
    required this.onDistanceChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
            child: Container(
              height: 54,
              padding: const EdgeInsets.fromLTRB(11, 8, 8, 8),
              decoration: BoxDecoration(
                color: ColorRes.aquaHaze.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  RoundedImage(
                    onTap: () {
                      Get.back();
                    },
                    image: AssetRes.backArrow,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(AssetRes.themeLabel, height: 25, width: 75),
                  const SizedBox(width: 4),
                  Text(S.current.map, style: const TextStyle(color: ColorRes.black, fontSize: 15)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(11, 9, 11, 13),
                    decoration: BoxDecoration(
                      color: ColorRes.davyGrey.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: DropdownButton<int>(
                      underline: const SizedBox(),
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 16),
                        child: Transform.rotate(
                          angle: 4.7,
                          child: Image.asset(AssetRes.backArrow, color: ColorRes.darkGrey9, height: 20, width: 20),
                        ),
                      ),
                      isDense: true,
                      items: distanceList
                          .map<DropdownMenuItem<int>>(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  "$e ${S.current.km}",
                                  style: const TextStyle(
                                    color: ColorRes.darkGrey9,
                                    fontFamily: FontRes.semiBold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedDistance,
                      onChanged: (int? value) {
                        if (value != null) {
                          onDistanceChange(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
