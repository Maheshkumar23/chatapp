import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_ui/common/drop_down_box.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/screen/starting_profile_screen/widet/text_field_area/text_field_controller.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class TextFieldsArea extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController bioController;
  final TextEditingController ageController;
  final FocusNode addressFocus;
  final FocusNode bioFocus;
  final FocusNode ageFocus;
  final String gender;
  final bool showDropdown;
  final VoidCallback onGenderTap;
  final VoidCallback onTextFieldTap;
  final Function(String value) onGenderChange;
  final String addressError;
  final String bioError;
  final String ageError;

  TextFieldsArea(
      {Key? key,
      required this.addressController,
      required this.bioController,
      required this.ageController,
      required this.addressFocus,
      required this.bioFocus,
      required this.ageFocus,
      required this.gender,
      required this.onGenderTap,
      required this.showDropdown,
      required this.onTextFieldTap,
      required this.onGenderChange,
      required this.ageError,
      required this.addressError,
      required this.bioError})
      : super(key: key);

  final TextFieldController controller = Get.put(TextFieldController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.current.whereDoYouLive,
                      style: const TextStyle(
                        color: ColorRes.davyGrey,
                        fontSize: 15,
                        fontFamily: FontRes.extraBold,
                      ),
                    ),
                    TextSpan(
                      text: " (${S.current.optional})",
                      style: const TextStyle(
                        color: ColorRes.dimGrey2,
                        fontSize: 14,
                        fontFamily: FontRes.bold,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ColorRes.lightGrey2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: addressController,
                  focusNode: addressFocus,
                  onTap: onTextFieldTap,
                  onChanged: controller.onAddressChange,
                  style: const TextStyle(
                      color: ColorRes.dimGrey3, fontSize: 15, fontFamily: FontRes.semiBold),
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: addressError == '' ? S.current.enterAddress : addressError,
                    hintStyle: TextStyle(
                      color: addressError == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange,
                      fontSize: 14,
                      fontFamily: FontRes.semiBold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: S.current.bio,
                          style: const TextStyle(
                            color: ColorRes.davyGrey,
                            fontSize: 15,
                            fontFamily: FontRes.extraBold,
                          ),
                        ),
                        TextSpan(
                          text: ' (${S.current.optional})',
                          style: const TextStyle(
                            color: ColorRes.dimGrey2,
                            fontSize: 14,
                            fontFamily: FontRes.bold,
                          ),
                        ),
                        TextSpan(
                          text: " (${controller.bio.value.length}/100)",
                          style: const TextStyle(
                            color: ColorRes.dimGrey2,
                            fontSize: 14,
                            fontFamily: FontRes.bold,
                          ),
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 6),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: ColorRes.lightGrey2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: bioController,
                  focusNode: bioFocus,
                  onTap: onTextFieldTap,
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  maxLength: 100,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: controller.onBioChange,
                  style: const TextStyle(
                      color: ColorRes.dimGrey3, fontSize: 15, fontFamily: FontRes.semiBold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10, top: 9),
                    counterText: "",
                    hintText: bioError == '' ? S.current.enterBio : bioError,
                    hintStyle: TextStyle(
                      color: bioError == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange,
                      fontSize: 14,
                      fontFamily: FontRes.semiBold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                S.current.age,
                style: const TextStyle(
                  color: ColorRes.davyGrey,
                  fontSize: 15,
                  fontFamily: FontRes.extraBold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ColorRes.lightGrey2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: ageController,
                  focusNode: ageFocus,
                  onChanged: controller.onAgeChange,
                  onTap: onTextFieldTap,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: ColorRes.dimGrey3, fontSize: 15, fontFamily: FontRes.semiBold),
                  decoration: InputDecoration(
                    hintText: ageError == '' ? S.current.enterAge : ageError,
                    hintStyle: TextStyle(
                      color: ageError == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange,
                      fontSize: 14,
                      fontFamily: FontRes.semiBold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.current.gender,
                      style: const TextStyle(
                        color: ColorRes.davyGrey,
                        fontSize: 15,
                        fontFamily: FontRes.extraBold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onGenderTap,
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
                                  gender,
                                  style: const TextStyle(
                                    color: ColorRes.dimGrey3,
                                    fontSize: 14,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: showDropdown ? 3.1 : 0,
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
                      const SizedBox(height: 110),
                    ],
                  ),
                  showDropdown
                      ? Positioned(
                          top: 45,
                          left: 0,
                          child: DropDownBox(
                            gender: gender,
                            onChange: onGenderChange,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
