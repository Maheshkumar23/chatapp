import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/login_pwd_screen/login_pwd_screen_view_model.dart';
import 'package:orange_ui/screen/login_pwd_screen/widgets/password_card.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class LoginPwdScreen extends StatelessWidget {
  final String email;

  const LoginPwdScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginPwdScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init(email);
      },
      viewModelBuilder: () => LoginPwdScreenViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Image.asset(
                  AssetRes.loginBG,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: Get.height,
                width: Get.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: InkWell(
                          onTap: model.onBackBtnTap,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, top: 5),
                            child: Image.asset(
                              AssetRes.backArrow,
                              color: ColorRes.white,
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 6.2),
                      Center(
                        child: Image.asset(
                          AssetRes.themeLabelWhite,
                          height: 51,
                          width: 176,
                        ),
                      ),
                      SizedBox(height: Get.height / 18),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            S.current.logIn,
                            style: const TextStyle(
                              color: ColorRes.white,
                              fontSize: 25,
                              fontFamily: FontRes.extraBold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      PasswordCard(
                        pwdController: model.pwdController,
                        pwdFocus: model.pwdFocus,
                        pwdError: model.pwdError,
                        onForgotPwdTap: model.onForgotPwdTap,
                        onContinueTap: model.onContinueTap,
                        showPwd: model.showPwd,
                        onViewBtnTap: model.onViewBtnTap,
                        email: model.email,
                        onChangeEmailTap: model.onBackBtnTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
