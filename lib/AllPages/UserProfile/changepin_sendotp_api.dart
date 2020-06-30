import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../global_data.dart' as server;

Future sendotp(String token) async {
  String url = '${server.server_url}/changepinsendotp';
  final http.Response response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-access-tokens": token
    },
  );
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}
