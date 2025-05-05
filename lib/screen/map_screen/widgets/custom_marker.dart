import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_ui/common/common_ui.dart';
import 'package:orange_ui/utils/asset_res.dart';

class CustomMarker extends StatefulWidget {
  final String imageUrl;
  final String name;
  final GlobalKey globalKey;

  const CustomMarker({
    Key? key,
    required this.imageUrl,
    required this.globalKey,
    required this.name,
  }) : super(key: key);

  @override
  State<CustomMarker> createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.globalKey,
      child: SizedBox(
        width: 160,
        child: Stack(
          children: [
            const SizedBox(
              width: 160,
              child: Image(image: AssetImage(AssetRes.icLocationPin)),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: SizedBox(
                  height: 75,
                  width: 75,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: '1',
                      image: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholderErrorBuilder: (context, error, stackTrace) {
                        return CommonUI.profileImagePlaceHolder(
                            name: widget.name, heightWidth: 75);
                      },
                      imageErrorBuilder: (context, error, stackTrace) {
                        return CommonUI.profileImagePlaceHolder(
                            name: widget.name, heightWidth: 75);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
