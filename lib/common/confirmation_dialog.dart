import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:orange_ui/utils/style_res.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback? onTap;
  final String description;
  final double? dialogSize;
  final String? textButton;
  final String? textImage;
  final String? heading;
  final EdgeInsets? padding;

  const ConfirmationDialog(
      {Key? key,
      required this.onTap,
      required this.description,
      this.dialogSize,
      this.textButton,
      this.textImage,
      this.heading,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: padding,
      backgroundColor: ColorRes.white,
      child: AspectRatio(
        aspectRatio: dialogSize ?? 1.8,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorRes.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                heading ?? '${S.current.areYouSure}?',
                style: const TextStyle(
                    fontFamily: FontRes.bold, fontSize: 18, color: ColorRes.davyGrey),
              ),
              const Spacer(),
              Text(
                description,
                style: const TextStyle(
                    color: ColorRes.dimGrey3, fontFamily: FontRes.regular, fontSize: 14),
              ),
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 9),
                          Text(
                            S.current.cancel,
                            style: const TextStyle(
                                fontFamily: FontRes.semiBold,
                                fontSize: 13,
                                color: ColorRes.davyGrey),
                          ),
                          const SizedBox(width: 9),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          gradient: StyleRes.linearGradient),
                      child: Row(
                        children: [
                          Text(
                            textButton ?? S.current.delete,
                            style: const TextStyle(
                                fontFamily: FontRes.semiBold, fontSize: 13, color: ColorRes.white),
                          ),
                          const SizedBox(width: 2),
                          Image.asset(
                            textImage ?? AssetRes.icBin,
                            color: ColorRes.white,
                            height: 17,
                            width: 17,
                            errorBuilder: (context, error, stackTrace) {
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
