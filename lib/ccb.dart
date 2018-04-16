/*import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:arabicchurch/group_details.dart';
import 'package:arabicchurch/services/web_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> post() async {
  var url = "https://arabicchurch.ccbchurch.com/easy_email.php";

  Response response = await http.get(url, headers: {
    "source": "w_group_list",
    "ax": "create_new",
    "individual_id": "1",
    "group_id": "27",
    "individual_full_name": "Tony Zaki"
  });

  String str = '';
  str += "Response status: ${response.statusCode}\n";
  str += "Response body: ${response.body}";
  //TODO print(str);
  return str;
  //http.read("http://example.com/foobar.txt").then(print);
}

class CCBScreenRoute extends MaterialPageRoute<String> {
  CCBScreenRoute() : super(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return new CCBScreen();
      });
}

class CCBScreen extends Widget {
  WebService _webService = new WebService();

  @override
  Widget build(BuildContext context) {
    return new CCBScreen();
  }

  @override
  StatelessElement createElement() {
    return new StatelessElement(new Card(child: new RaisedButton(
      onPressed: _webService.launchWebView('http://arabicchurch.org'),
      child: new Text('Show church website'),
    )));
  }
}*/