import 'package:flutter/material.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/edit_profile_screen/edit_profile_screen_view_model.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class InterestList extends StatelessWidget {
  final EditProfileScreenViewModel model;

  const InterestList({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        model.hobbiesList.isEmpty
            ? const SizedBox()
            : Text(
                S.current.interest,
                style: const TextStyle(
                  color: ColorRes.davyGrey,
                  fontSize: 15,
                  fontFamily: FontRes.extraBold,
                ),
              ),
        const SizedBox(height: 15),
        Wrap(
          alignment: WrapAlignment.center,
          children: model.hobbiesList.map<Widget>((e) {
            bool selected = model.selectedList.contains(e.id.toString());
            return InkWell(
              onTap: () {
                model.onClipTap(e.id.toString());
              },
              splashColor: ColorRes.transparent,
              highlightColor: ColorRes.transparent,
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            ColorRes.darkOrange,
                            ColorRes.darkOrange,
                          ],
                        )
                      : const LinearGradient(
                          end: Alignment.topCenter,
                          begin: Alignment.bottomCenter,
                          colors: [
                            ColorRes.lightGrey3,
                            ColorRes.lightGrey3,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  "${e.title}",
                  style: TextStyle(
                    color: selected ? ColorRes.white : ColorRes.dimGrey3,
                    fontSize: 14,
                    fontFamily: FontRes.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
