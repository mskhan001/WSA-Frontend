import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../global_data.dart' as server;

Future sendetails(String profilename, String userpin, String token) async {
  String url = '${server.server_url}/savedetails';
  final http.Response response = await http.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-access-tokens": token
      },
      body: jsonEncode(
          <String, String>{'profilename': profilename, 'userpin': userpin}));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    print(
        '9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');
    print(convertedDatatoJson);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}
