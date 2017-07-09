import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';

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