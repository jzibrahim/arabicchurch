/*import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class WebService {

  static WebService _cached;

  factory WebService() {
    _cached ??= new WebService._internal();
    return _cached;
  }

  WebService._internal();

  launchWebView(String url) async {
    var flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.launch(url, fullScreen: false);
    await flutterWebviewPlugin.onDestroy.first;
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      //TODO
      print('can launch');
      await launch(url);
    } else {
      //TODO
      print('cannot launch');
      throw 'Could not launch $url';
    }
  }
}*/