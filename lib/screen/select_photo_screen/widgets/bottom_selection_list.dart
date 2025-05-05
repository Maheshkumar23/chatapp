import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class BottomSelectionList extends StatelessWidget {
  final List<File>? imageList;
  final int selectedIndex;
  final Function(int index) onImgRemove;
  final VoidCallback onPlayBtnTap;
  final VoidCallback onAddBtnTap;

  const BottomSelectionList({
    Key? key,
    required this.imageList,
    required this.onImgRemove,
    required this.onPlayBtnTap,
    required this.onAddBtnTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            S.current.photosCap,
            style: const TextStyle(
              color: ColorRes.dimGrey3,
              fontFamily: FontRes.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          margin: EdgeInsets.only(bottom: Get.height / 30),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: Get.width - 170,
                height: 58,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList?.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        onImgRemove(index);
                      },
                      child: Container(
                        height: 58,
                        width: 58,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(imageList![index].path)),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 31,
                            width: 31,
                            decoration: BoxDecoration(
                              color: ColorRes.white.withOpacity(0.30),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                AssetRes.bin,
                                height: 16,
                                width: 15,
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 130,
                height: 58,
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    InkWell(
                      onTap: onAddBtnTap,
                      child: Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: ColorRes.lightGrey3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Image.asset(AssetRes.plus, height: 17, width: 17),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    InkWell(
                      onTap: onPlayBtnTap,
                      child: Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: ColorRes.lightGrey3,
                          borderRadius: BorderRadius.circular(10),
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
                          child: Image.asset(
                            AssetRes.playButton,
                            color: ColorRes.white,
                            height: 17,
                            width: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
