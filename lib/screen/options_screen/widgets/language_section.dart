import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class LanguageSection extends StatelessWidget {
  final VoidCallback navigateLanguage;

  const LanguageSection({Key? key, required this.navigateLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.appLanguages,
          style: const TextStyle(
            fontFamily: FontRes.bold,
            color: ColorRes.grey23,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 9),
        Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: ColorRes.grey10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: navigateLanguage,
            child: Row(
              children: [
                Text(
                  S.current.languages,
                  style: const TextStyle(
                    color: ColorRes.davyGrey,
                    fontSize: 15,
                    fontFamily: FontRes.semiBold,
                  ),
                ),
                const Spacer(),
                Transform.rotate(
                  angle: 3.2,
                  child: Image.asset(
                    AssetRes.backArrow,
                    height: 20,
                    width: 20,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
