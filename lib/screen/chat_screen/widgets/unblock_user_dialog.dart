import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class UnblockUserDialog extends StatelessWidget {
  final VoidCallback unblockUser;
  final VoidCallback onCancelBtnClick;
  final String? name;

  const UnblockUserDialog(
      {Key? key, required this.onCancelBtnClick, required this.unblockUser, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AspectRatio(
        aspectRatio: 2.7,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Spacer(),
              Text(
                '${S.current.unBlock} $name ${S.current.toSendMessage}',
                style: const TextStyle(
                    color: ColorRes.darkGrey9, fontSize: 16, fontFamily: FontRes.medium),
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: onCancelBtnClick,
                    splashColor: ColorRes.transparent,
                    highlightColor: ColorRes.transparent,
                    child: Text(
                      S.current.cancelCap,
                      style: const TextStyle(color: ColorRes.grey, fontFamily: FontRes.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      unblockUser();
                      Get.back();
                    },
                    child: Text(
                      S.current.unblockCap,
                      style: const TextStyle(color: ColorRes.darkOrange, fontFamily: FontRes.bold),
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
