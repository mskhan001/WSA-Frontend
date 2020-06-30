import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;



Future sendotp(String phone_num) async{
  String url = 'http://2ca6c30c31e8.ngrok.io/sendOTPSIN';
  final http.Response response = await http.post(url,
  headers: {
      HttpHeaders.contentTypeHeader: 'application/json'},
  body: jsonEncode(<String,String>{
    'phone_num': phone_num}
  ));
  if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);         
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}

