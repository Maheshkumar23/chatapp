import 'package:flutter/material.dart';
import 'package:orange_ui/utils/const_res.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenViewModel extends BaseViewModel {
  WebViewController controller = WebViewController();

  void init(String url) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(ConstRes.base + url));
  }

}
