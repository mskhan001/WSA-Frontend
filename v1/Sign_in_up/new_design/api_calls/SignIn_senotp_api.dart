import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../global_data.dart' as server;

Future sendotp(String phone_num) async {
  String url = '${server.server_url}/sendOTPSIN';
  print('here 123');
  final http.Response response = await http.post(url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(<String, String>{'phone_num': phone_num}));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}
