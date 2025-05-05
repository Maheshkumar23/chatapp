import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/buttons.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

import '../../../generated/l10n.dart';

class PasswordCard extends StatelessWidget {
  final TextEditingController pwdController;
  final FocusNode pwdFocus;
  final String pwdError;
  final bool showPwd;
  final VoidCallback onContinueTap;
  final VoidCallback onForgotPwdTap;
  final VoidCallback onViewBtnTap;
  final VoidCallback onChangeEmailTap;
  final String email;

  const PasswordCard(
      {Key? key,
      required this.pwdController,
      required this.pwdFocus,
      required this.pwdError,
      required this.showPwd,
      required this.onContinueTap,
      required this.onForgotPwdTap,
      required this.onViewBtnTap,
      required this.email,
      required this.onChangeEmailTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorRes.black.withOpacity(0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileBox(),
              const SizedBox(height: 30),
              Container(
                height: 44,
                width: Get.width,
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: TextField(
                  focusNode: pwdFocus,
                  controller: pwdController,
                  obscureText: !showPwd,
                  style: const TextStyle(
                    fontFamily: FontRes.semiBold,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 14, top: 10),
                    border: InputBorder.none,
                    hintText: pwdError == "" ? S.current.password : pwdError,
                    suffixIcon: InkWell(
                      onTap: onViewBtnTap,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Text(
                          showPwd ? S.current.hide : S.current.view,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ColorRes.darkGrey,
                            fontSize: 13,
                            fontFamily: FontRes.bold,
                          ),
                        ),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: pwdError == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange,
                      fontSize: 14,
                      fontFamily: FontRes.semiBold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SubmitButton1(title: S.current.continueText, onTap: onContinueTap),
              const SizedBox(height: 28),
              InkWell(
                onTap: onForgotPwdTap,
                child: Text(
                  S.current.forgotYourPassword,
                  style: const TextStyle(
                    color: ColorRes.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileBox() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.enterThePasswordForTheAccountNwithTheEmailBelow,
            style: const TextStyle(
              color: ColorRes.white,
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(
                    color: ColorRes.white,
                    fontSize: 17,
                    fontFamily: FontRes.semiBold,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: onChangeEmailTap,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(color: ColorRes.white, borderRadius: BorderRadius.circular(30)),
                  child: Image.asset(
                    AssetRes.edit,
                    width: 20,
                    height: 20,
                    color: ColorRes.darkOrange,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
