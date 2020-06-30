import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future verifyotp(String otp, String sessionId) async{
  String url = 'http://2ca6c30c31e8.ngrok.io/verifyOTPSUP';
  final http.Response response = await http.post(url,
  headers: {
      HttpHeaders.contentTypeHeader: 'application/json'},
  body: jsonEncode(<String,String>{
    'OTP':otp,
    'sessionId':sessionId
    }
  ));
  if (response.statusCode == 200) {
    var convertedDatatoJson = jsonDecode(response.body);
      print(convertedDatatoJson);
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to verify otp.');
  }
}
