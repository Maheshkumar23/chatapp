import 'package:flutter/material.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

import '../../../model/user/registration_user.dart';

class HobbiesClips extends StatelessWidget {
  final List<Interest> hobbiesList;
  final List<String?> selectedList;
  final Function(String value) onClipTap;
  final double paddingLeft;
  final double paddingRight;

  const HobbiesClips({
    Key? key,
    required this.hobbiesList,
    required this.selectedList,
    required this.onClipTap,
    this.paddingLeft = 22,
    this.paddingRight = 13,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: hobbiesList.map<Widget>((e) => clip(e)).toList(),
      ),
    );
  }

  Widget clip(Interest label) {
    bool selected = selectedList.contains(label.id.toString());
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          onClipTap(label.id.toString());
        },
        child: Container(
          padding: const EdgeInsets.only(right: 22, left: 22, top: 10, bottom: 8),
          decoration: BoxDecoration(
            color: selected ? ColorRes.white : ColorRes.darkOrange.withOpacity(0.06),
            borderRadius: BorderRadius.circular(30),
            gradient: selected
                ? const LinearGradient(
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                    colors: [
                      ColorRes.darkOrange,
                      ColorRes.darkOrange,
                    ],
                  )
                : null,
          ),
          child: Text(
            label.title!,
            style: TextStyle(
              color: selected ? ColorRes.white : ColorRes.darkOrange,
              fontSize: 15,
              fontFamily: FontRes.bold,
            ),
          ),
        ),
      ),
    );
  }
}
