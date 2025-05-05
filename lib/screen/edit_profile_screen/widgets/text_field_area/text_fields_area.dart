import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orange_ui/common/drop_down_box.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/edit_profile_screen/edit_profile_screen_view_model.dart';
import 'package:orange_ui/screen/edit_profile_screen/widgets/interest_list.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class TextFieldsArea extends StatelessWidget {
  final EditProfileScreenViewModel model;

  const TextFieldsArea({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ExpandedTextFieldCustom(
            controller: model.fullNameController,
            error: model.fullNameError,
            hint: S.current.enterFullName,
            model: model,
            focusNode: model.fullNameFocus,
            title: S.current.fullName,
            isExpand: false,
          ),
          ExpandedTextFieldCustom(
            controller: model.userNameController,
            error: model.userNameError,
            hint: S.current.enterUsername,
            model: model,
            focusNode: model.userNameFocus,
            title: S.of(context).username,
            isExpand: false,
          ),
          ExpandedTextFieldCustom(
              controller: model.bioController,
              error: model.bioError,
              hint: model.bioError == '' ? S.current.enterBio : model.bioError,
              model: model,
              focusNode: model.bioFocus,
              height: 65,
              maxLength: 100,
              title: S.current.bio,
              optional: ' (${S.current.optional}) (${utf8.encode(model.bioController.text).length}/100})',
              isExpand: true),
          ExpandedTextFieldCustom(
            controller: model.aboutController,
            height: 160,
            focusNode: model.aboutFocus,
            model: model,
            error: model.aboutError,
            hint: model.aboutError == '' ? S.current.enterAbout : model.aboutError,
            maxLength: 300,
            title: S.current.about,
            optional: ' (${utf8.encode(model.aboutController.text).length}/300})',
            isExpand: true,
          ),
          ExpandedTextFieldCustom(
              controller: model.addressController,
              focusNode: model.addressFocus,
              error: model.addressError,
              hint: S.current.enterAddress,
              model: model,
              optional: ' (${S.current.optional})',
              title: S.current.whereDoYouLive),
          ExpandedTextFieldCustom(
              controller: model.ageController,
              focusNode: model.ageFocus,
              error: model.ageError,
              hint: S.current.enterAge,
              model: model,
              title: S.current.age,
              keyboardType: TextInputType.number),
          RichTextCustom(title: S.current.gender),
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: model.onGenderTap,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: ColorRes.lightGrey2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.gender,
                              style: const TextStyle(
                                color: ColorRes.dimGrey3,
                                fontSize: 14,
                              ),
                            ),
                            Transform.rotate(
                              angle: model.showDropdown ? 3.1 : 0,
                              child: Image.asset(
                                AssetRes.downArrow,
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ExpandedTextFieldCustom(
                      controller: model.instagramController,
                      error: '',
                      hint: '',
                      model: model,
                      title: S.current.instagram,
                      focusNode: model.instagramFocus),
                  const SizedBox(height: 10),
                  ExpandedTextFieldCustom(
                      controller: model.facebookController,
                      error: '',
                      hint: '',
                      model: model,
                      title: S.current.facebook,
                      focusNode: model.facebookFocus),
                  const SizedBox(height: 10),
                  ExpandedTextFieldCustom(
                      controller: model.youtubeController,
                      error: '',
                      hint: '',
                      model: model,
                      title: S.current.youtube,
                      focusNode: model.youtubeFocus)
                ],
              ),
              model.showDropdown
                  ? Positioned(
                      top: 45,
                      child: DropDownBox(
                        gender: model.gender,
                        onChange: model.onGenderChange,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 15),
          InterestList(model: model),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: model.onSaveTap,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: ColorRes.lightOrange.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  S.current.save,
                  style: const TextStyle(
                    fontFamily: FontRes.bold,
                    color: ColorRes.darkOrange,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppBar().preferredSize.height),
        ],
      ),
    );
  }
}

class ExpandedTextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String error;
  final String hint;
  final EditProfileScreenViewModel model;
  final FocusNode focusNode;
  final double? height;
  final int? maxLength;
  final String title;
  final String? optional;
  final bool isExpand;
  final TextInputType keyboardType;

  const ExpandedTextFieldCustom(
      {Key? key,
      required this.controller,
      required this.error,
      required this.hint,
      required this.model,
      required this.focusNode,
      this.height,
      this.maxLength,
      required this.title,
      this.optional,
      this.isExpand = false,
      this.keyboardType = TextInputType.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichTextCustom(title: title, optional: optional),
        SizedBox(
          height: height,
          child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: ColorRes.lightGrey2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: ColorRes.transparent, width: 0.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: ColorRes.transparent, width: 0.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorRes.transparent, width: 0.0),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: error == '' ? hint : error,
                  hintStyle: TextStyle(color: error == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange),
                  counter: null,
                  counterText: ''),
              maxLines: isExpand ? null : 1,
              minLines: isExpand ? null : 1,
              expands: isExpand,
              textCapitalization: TextCapitalization.sentences,
              maxLength: maxLength,
              onChanged: model.onTextFieldChange,
              style: const TextStyle(color: ColorRes.dimGrey3, fontSize: 14),
              inputFormatters: isExpand ? [_Utf8LengthLimitingTextInputFormatter(maxLength ?? 0)] : null,
              cursorHeight: 15,
              cursorColor: ColorRes.darkGrey5,
              onTap: model.onAllScreenTap,
              textAlignVertical: TextAlignVertical.top),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class RichTextCustom extends StatelessWidget {
  final String title;
  final String? optional;

  const RichTextCustom({Key? key, required this.title, this.optional}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: ColorRes.davyGrey,
                fontSize: 15,
                fontFamily: FontRes.extraBold,
              ),
            ),
            TextSpan(
              text: optional,
              style: const TextStyle(
                color: ColorRes.dimGrey2,
                fontSize: 14,
                fontFamily: FontRes.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Utf8LengthLimitingTextInputFormatter extends TextInputFormatter {
  _Utf8LengthLimitingTextInputFormatter(this.maxLength) : assert(maxLength == -1 || maxLength > 0);

  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength > 0 && bytesLength(newValue.text) > maxLength) {
      // If already at the maximum and tried to enter even more, keep the old value.
      if (bytesLength(oldValue.text) == maxLength) {
        return oldValue;
      }
      return truncate(newValue, maxLength);
    }
    return newValue;
  }

  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    var newValue = '';
    if (bytesLength(value.text) > maxLength) {
      var length = 0;

      value.text.characters.takeWhile((char) {
        var nbBytes = bytesLength(char);
        if (length + nbBytes <= maxLength) {
          newValue += char;
          length += nbBytes;
          return true;
        }
        return false;
      });
    }
    return TextEditingValue(
      text: newValue,
      selection: value.selection.copyWith(
        baseOffset: min(value.selection.start, newValue.length),
        extentOffset: min(value.selection.end, newValue.length),
      ),
      composing: TextRange.empty,
    );
  }

  static int bytesLength(String value) {
    return utf8.encode(value).length;
  }
}
