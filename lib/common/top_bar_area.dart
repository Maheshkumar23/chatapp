import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class TopBarArea extends StatelessWidget {
  final String? title;
  final String? title2;

  const TopBarArea({Key? key, this.title, this.title2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: title ?? '',
                    style: const TextStyle(
                      fontSize: 17,
                      color: ColorRes.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' ${title2 ?? ' '}',
                        style: const TextStyle(
                          fontSize: 17,
                          color: ColorRes.black,
                          fontFamily: FontRes.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 23),
              ],
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 37,
                width: 37,
                decoration: BoxDecoration(color: ColorRes.darkOrange.withOpacity(0.1), shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetRes.backArrow,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
