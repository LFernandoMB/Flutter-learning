import 'package:flutter/services.dart';

class Webview2Egov {
  static const MethodChannel _channel = MethodChannel('webview2_egov');

  static Future<void> showWebView(String url) async {
    await _channel.invokeMethod('showWebView', {'url': url});
  }
}
