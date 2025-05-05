import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/model/user/registration_user.dart';
import 'package:orange_ui/screen/verification_screen/widget/doc_type_drop_down.dart';
import 'package:orange_ui/utils/asset_res.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';

class VerificationCenterArea extends StatelessWidget {
  final FocusNode fullNameFocus;
  final TextEditingController fullNameController;
  final String fullNameError;
  final bool showDropdown;
  final String docType;
  final VoidCallback onDocTypeTap;
  final Function(String value) onDocChange;
  final VoidCallback onTakePhotoTap;
  final VoidCallback onDocumentTap;
  final File? selfieImage;
  final RegistrationUserData? userIdentity;
  final String? imagesName;
  final VoidCallback onSubmitBtnClick;
  final bool isDocFile;
  final bool isSelfie;

  const VerificationCenterArea(
      {Key? key,
      required this.userIdentity,
      required this.fullNameFocus,
      required this.fullNameError,
      required this.fullNameController,
      required this.docType,
      required this.showDropdown,
      required this.onDocChange,
      required this.onDocTypeTap,
      required this.onTakePhotoTap,
      required this.onDocumentTap,
      required this.selfieImage,
      required this.imagesName,
      required this.onSubmitBtnClick,
      required this.isSelfie,
      required this.isDocFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${userIdentity?.fullname} ',
                    style: const TextStyle(fontFamily: FontRes.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    AssetRes.tickMark,
                    height: 17,
                    width: 17,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  S.current.verifiedAccountsHaveBlueEtc,
                  style: const TextStyle(fontFamily: FontRes.regular),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  S.current.fullNameCap,
                  style: const TextStyle(
                    color: ColorRes.davyGrey,
                    fontSize: 15,
                    fontFamily: FontRes.extraBold,
                  ),
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ColorRes.lightGrey2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: fullNameController,
                  focusNode: fullNameFocus,
                  style: const TextStyle(
                    color: ColorRes.dimGrey3,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: fullNameError == '' ? S.current.enterFullName : fullNameError,
                    hintStyle: TextStyle(
                      color: fullNameError == "" ? ColorRes.dimGrey2 : ColorRes.darkOrange,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 10, left: 10),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  S.current.docType,
                  style: const TextStyle(
                    color: ColorRes.davyGrey,
                    fontSize: 15,
                    fontFamily: FontRes.extraBold,
                  ),
                ),
              ),
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onDocTypeTap,
                        highlightColor: ColorRes.transparent,
                        splashColor: ColorRes.transparent,
                        child: Container(
                          height: 45,
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
                                  docType,
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
                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: imagesName == null || imagesName!.isEmpty ? true : false,
                        child: InkWell(
                          onTap: onDocumentTap,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorRes.darkOrange,
                                  width: 2,
                                  style: !isDocFile ? BorderStyle.none : BorderStyle.solid),
                              color: ColorRes.lightGrey2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              S.current.selectDocument,
                              style: const TextStyle(
                                color: ColorRes.dimGrey3,
                                fontSize: 14,
                              ),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: imagesName == null || imagesName!.isEmpty ? false : true,
                        child: InkWell(
                          onTap: onDocumentTap,
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: ColorRes.lightGrey2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      '$imagesName',
                                      style: const TextStyle(
                                        color: ColorRes.dimGrey3,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  decoration:
                                      BoxDecoration(color: ColorRes.lightGrey, borderRadius: BorderRadius.circular(30)),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: ColorRes.dimGrey3,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          S.current.yourSelfie,
                          style: const TextStyle(
                            color: ColorRes.davyGrey,
                            fontSize: 15,
                            fontFamily: FontRes.extraBold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: selfieImage == null || selfieImage!.path.isEmpty
                            ? InkWell(
                                onTap: onTakePhotoTap,
                                child: SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: DottedBorder(
                                    color: ColorRes.davyGrey,
                                    borderType: BorderType.RRect,
                                    dashPattern: const [8, 8],
                                    radius: const Radius.circular(5),
                                    strokeWidth: 2,
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: ColorRes.darkOrange,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(
                                    selfieImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AssetRes.imageWarning,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                  showDropdown
                      ? Positioned(
                          top: 50,
                          child: DocTypeDropDown(
                            docType: docType,
                            onChange: onDocChange,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: onTakePhotoTap,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: ColorRes.lightGrey2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      S.current.takePhoto,
                      style: const TextStyle(
                        color: ColorRes.dimGrey3,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: onSubmitBtnClick,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: ColorRes.lightOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      S.current.submit,
                      style: const TextStyle(
                        fontFamily: FontRes.bold,
                        color: ColorRes.darkOrange,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
