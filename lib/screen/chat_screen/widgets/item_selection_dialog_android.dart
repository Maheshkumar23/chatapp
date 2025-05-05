import 'package:flutter/material.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class ItemSelectionDialogAndroid extends StatelessWidget {
  final VoidCallback onImageBtnClick;
  final VoidCallback onVideoBtnClick;
  final VoidCallback onCloseBtnClick;

  const ItemSelectionDialogAndroid(
      {Key? key,
      required this.onCloseBtnClick,
      required this.onImageBtnClick,
      required this.onVideoBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 13),
            child: Text(
              S.current.whichItemWouldYouLikeEtc,
              style: const TextStyle(
                  color: ColorRes.grey,
                  fontSize: 16,
                  fontFamily: FontRes.medium),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),
          Expanded(
            child: InkWell(
              onTap: onImageBtnClick,
              child: Center(
                child: Text(
                  S.current.photos,
                  style:
                      const TextStyle(fontFamily: FontRes.medium, fontSize: 17),
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: InkWell(
              onTap: onVideoBtnClick,
              child: Center(
                child: Text(
                  S.current.videos,
                  style:
                      const TextStyle(fontFamily: FontRes.medium, fontSize: 17),
                ),
              ),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: onCloseBtnClick,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                S.current.close,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.blue,
                    fontFamily: FontRes.semiBold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
