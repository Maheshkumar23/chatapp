import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class BottomTextField extends StatelessWidget {
  final TextEditingController commentController;
  final FocusNode commentFocus;
  final VoidCallback onMsgSend;
  final VoidCallback onGoProTap;
  final VoidCallback onGiftTap;
  final int count;

  const BottomTextField(
      {Key? key,
      required this.commentController,
      required this.commentFocus,
      required this.onMsgSend,
      required this.onGoProTap,
      required this.onGiftTap,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  width: Get.width - 60,
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: ColorRes.black.withOpacity(0.33),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: 13,
                            color: ColorRes.white.withOpacity(0.70),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          controller: commentController,
                          focusNode: commentFocus,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: S.current.comment,
                            contentPadding: const EdgeInsets.only(left: 14, bottom: 10, top: 0),
                            hintStyle: TextStyle(
                              color: ColorRes.white.withOpacity(0.45),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: onMsgSend,
                        child: Container(
                          height: 36,
                          width: 36,
                          padding: const EdgeInsets.fromLTRB(10, 9, 6, 9),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ColorRes.lightOrange,
                                ColorRes.darkOrange,
                              ],
                            ),
                          ),
                          child: Image.asset(AssetRes.share),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onGiftTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ColorRes.black.withOpacity(0.33),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 36,
                      width: 36,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorRes.darkOrange,
                            ColorRes.lightOrange,
                          ],
                        ),
                      ),
                      child: Image.asset(AssetRes.gift),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Visibility(
          visible: false,
          child: SafeArea(
            bottom: true,
            top: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 59,
                  width: Get.width,
                  padding: const EdgeInsets.fromLTRB(7, 11, 5, 12),
                  decoration: BoxDecoration(
                    color: ColorRes.black.withOpacity(0.33),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 36),
                          SizedBox(
                            width: Get.width - 155,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    S.current.youWillBeSentEtc,
                                    style: TextStyle(
                                      color: ColorRes.white.withOpacity(0.85),
                                      fontSize: 12,
                                      fontFamily: FontRes.bold,
                                    ),
                                  ),
                                  Text(
                                    S.current.subscribeToProEtc,
                                    style: TextStyle(
                                      color: ColorRes.white.withOpacity(0.70),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 31,
                            width: 31,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorRes.white.withOpacity(0.15),
                            ),
                            child: Center(
                              child: Text(
                                "$count",
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 17,
                                  fontFamily: FontRes.bold,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: onGoProTap,
                            child: Container(
                              height: 31,
                              padding: const EdgeInsets.fromLTRB(14, 3, 11, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorRes.lightOrange,
                                    ColorRes.darkOrange,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: S.current.go,
                                        style: const TextStyle(
                                          color: ColorRes.white,
                                          fontSize: 12,
                                          fontFamily: FontRes.regular,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " ${S.current.pro}",
                                        style: const TextStyle(
                                          color: ColorRes.white,
                                          fontSize: 12,
                                          fontFamily: FontRes.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
