import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../global_data.dart' as server;

Future verifypin(String pin, var tokens) async {
  print('USER PIN IS BEING VERIFIED');
  String url = '${server.server_url}/safetypinverify';
  final http.Response response = await http.post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        "x-access-tokens": tokens
      },
      body: jsonEncode(<String, String>{
        'PIN': pin,
      }));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    print(convertedDatatoJson);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to verify otp.');
  }
}
