import 'package:flutter/cupertino.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';

class ItemSelectionDialogIos extends StatelessWidget {
  final VoidCallback onImageBtnClickIos;
  final VoidCallback onVideoBtnClickIos;
  final VoidCallback onCloseBtnClickIos;

  const ItemSelectionDialogIos(
      {Key? key,
      required this.onCloseBtnClickIos,
      required this.onImageBtnClickIos,
      required this.onVideoBtnClickIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        S.current.whichItemWouldYouLikeEtc,
        style: const TextStyle(color: ColorRes.grey),
      ),
      actions: [
        CupertinoActionSheetAction(
          onPressed: onImageBtnClickIos,
          child: Text(S.current.photos),
        ),
        CupertinoActionSheetAction(
          onPressed: onVideoBtnClickIos,
          child: Text(S.current.videos),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: onCloseBtnClickIos,
        child: Text(S.current.close),
      ),
    );
  }
}
