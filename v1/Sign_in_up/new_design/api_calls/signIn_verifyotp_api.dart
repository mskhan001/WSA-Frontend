import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../global_data.dart' as server;

Future verifyotp2(String otp, String session_id) async {
  String url = '${server.server_url}/verifyOTPSIN';
  final http.Response response = await http.post(url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(<String, String>{'OTP': otp, 'session_id': session_id}));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    print(convertedDatatoJson);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to verify otp.');
  }
}
