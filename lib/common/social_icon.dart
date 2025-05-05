import 'package:flutter/material.dart';
import 'package:orange_ui/utils/color_res.dart';

class SocialIcon extends StatelessWidget {
  final String icon;
  final double size;
  final VoidCallback onSocialIconTap;
  final bool isVisible;

  const SocialIcon(
      {Key? key,
      required this.size,
      required this.isVisible,
      required this.icon,
      required this.onSocialIconTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        onTap: onSocialIconTap,
        child: Container(
          height: 29,
          width: 29,
          margin: const EdgeInsets.only(right: 7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorRes.white,
          ),
          child: Center(
            child: Image.asset(icon, height: size, width: size),
          ),
        ),
      ),
    );
  }
}
