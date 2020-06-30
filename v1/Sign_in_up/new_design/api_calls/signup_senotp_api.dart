import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../global_data.dart' as server;

Future sendotp(String mobileno) async {
  String url = '${server.server_url}/sendOTPSUP';
  final http.Response response = await http.post(url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(<String, String>{'mobileno': mobileno}));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);

    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}
