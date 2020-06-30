import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;



Future sendotp(String mobileno) async{
  String url = 'http://2ca6c30c31e8.ngrok.io/sendOTPSUP';
  final http.Response response = await http.post(url,
  headers: {
      HttpHeaders.contentTypeHeader: 'application/json'},
  body: jsonEncode(<String,String>{
    'mobileno':mobileno}
  ));
  if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
         
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}

