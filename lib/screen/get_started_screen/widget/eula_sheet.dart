import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:orange_ui/generated/l10n.dart';
import 'package:orange_ui/utils/color_res.dart';
import 'package:orange_ui/utils/font_res.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EulaSheet extends StatelessWidget {
  final VoidCallback eulaAcceptClick;

  const EulaSheet({Key? key, required this.eulaAcceptClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };

    UniqueKey key = UniqueKey();
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 50 * 2),
            child: WebViewWidget(
              key: key,
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith('https://www.youtube.com/')) {
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(
                    Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/')),
              gestureRecognizers: gestureRecognizers,
            ),
          ),
          SafeArea(
            top: false,
            child: TextButton(
              onPressed: eulaAcceptClick,
              style: TextButton.styleFrom(
                backgroundColor: ColorRes.darkOrange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                S.of(context).accept,
                style: const TextStyle(
                  color: ColorRes.white,
                  fontFamily: FontRes.semiBold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
