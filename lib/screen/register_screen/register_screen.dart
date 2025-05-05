import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/register_screen/register_screen_view_model.dart';
import 'package:orange_ui/screen/register_screen/widgets/register_card.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:stacked/stacked.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterScreenViewModel>.reactive(
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => RegisterScreenViewModel(),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 15, top: AppBar().preferredSize.height),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        AssetRes.backArrow,
                        width: 25,
                        height: 25,
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          children: [
                            SizedBox(height: Get.height * 0.07),
                            Image.asset(
                              AssetRes.themeLabelWhite,
                              height: 51,
                              width: 176,
                            ),
                            SizedBox(height: Get.height / 18),
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                Text(
                                  S.current.register,
                                  style: const TextStyle(
                                    color: ColorRes.white,
                                    fontSize: 25,
                                    fontFamily: FontRes.extraBold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RegisterCard(
                              model: model,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
