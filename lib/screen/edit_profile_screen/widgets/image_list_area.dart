import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class ImageListArea extends StatelessWidget {
  final List<Images>? imageList;
  final Function(int index) onImgRemove;
  final VoidCallback onAddBtnTap;

  const ImageListArea({
    Key? key,
    required this.imageList,
    required this.onImgRemove,
    required this.onAddBtnTap,
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
              color: ColorRes.davyGrey,
              fontSize: 15,
              fontFamily: FontRes.extraBold,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: Get.width - 105,
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
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageList?[index].id != -123
                                  ? CachedNetworkImage(
                                      imageUrl: '${ConstRes.aImageBaseUrl}${imageList?[index].image}',
                                      cacheKey: '${ConstRes.aImageBaseUrl}${imageList?[index].image}',
                                      fit: BoxFit.cover,
                                      height: 58,
                                      width: 58,
                                    )
                                  : Image.file(
                                      File(imageList![index].image!),
                                      fit: BoxFit.cover,
                                      height: 58,
                                      width: 58,
                                    ),
                            ),
                            Container(
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                //width: 130,
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
