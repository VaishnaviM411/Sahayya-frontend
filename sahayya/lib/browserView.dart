import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserView extends StatefulWidget {

  String url = '';
  BrowserView({required this.url});

  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  @override
  Widget build(BuildContext context) {

    print(widget.url);

    @override
    void initState() {
      super.initState();
      // Enable hybrid composition.
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    }

    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
