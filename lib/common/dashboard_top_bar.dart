import 'package:flutter/material.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class DashboardTopBar extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback? onTitleTap;
  final VoidCallback onSearchTap;
  final VoidCallback onLivesBtnClick;
  final int? isDating;

  const DashboardTopBar(
      {Key? key,
      required this.onNotificationTap,
      this.onTitleTap,
      required this.onSearchTap,
      required this.onLivesBtnClick,
      required this.isDating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: onTitleTap,
            child: Image.asset(AssetRes.themeLabel, height: 28),
          ),
          const Spacer(),
          InkWell(
            onTap: onLivesBtnClick,
            child: Container(
              height: 37,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration:
                  BoxDecoration(color: ColorRes.darkOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset(
                    AssetRes.sun,
                    height: 20,
                    width: 20,
                    color: ColorRes.darkOrange,
                  ),
                  const SizedBox(width: 5),
                  Text(S.of(context).lives,
                      style: const TextStyle(fontFamily: FontRes.regular, fontSize: 12, color: ColorRes.darkOrange))
                ],
              ),
            ),
          ),
          if (isDating == 1) RoundedImage(onTap: onNotificationTap, image: AssetRes.bell),
          RoundedImage(onTap: onSearchTap, image: AssetRes.search),
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final VoidCallback onTap;
  final String image;

  const RoundedImage({Key? key, required this.onTap, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 37,
        width: 37,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(color: ColorRes.darkOrange.withOpacity(0.1), shape: BoxShape.circle),
        child: Center(child: Image.asset(image, height: 20, width: 20)),
      ),
    );
  }
}
