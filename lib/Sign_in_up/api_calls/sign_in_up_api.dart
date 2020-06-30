import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../global_data.dart' as server;

// Sign In - Receive Session ID
Future sendotp_SignIn(String phone_num) async {
  String url = '${server.server_url}/sendOTPSIN';
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

// Sign In - Receive token
Future verifyotp_SignIn(String otp, String session_id) async {
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

// Sign Up - Receive Session ID
Future sendotp_SignUp(String mobileno) async {
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

// Sign Up - Receive token
Future verifyotp_SignUp(String otp, String sessionId) async {
  String url = '${server.server_url}/verifyOTPSUP';
  final http.Response response = await http.post(url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode(<String, String>{'OTP': otp, 'sessionId': sessionId}));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
    print(convertedDatatoJson);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to verify otp.');
  }
}
