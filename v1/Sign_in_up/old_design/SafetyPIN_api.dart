import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;



Future sendetails(String profilename, String userpin, String token) async{
  String url = 'http://2ca6c30c31e8.ngrok.io/savedetails';
  final http.Response response = await http.post(url,
  headers: {
     HttpHeaders.contentTypeHeader: 'application/json',
      "x-access-tokens":
          token
  },
  body: jsonEncode(<String,String>{
    'profilename': profilename,
    'userpin': userpin
    }
  ));
  if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);         
    return convertedDatatoJson;
  } else {
    throw Exception('Failed to send otp.');
  }
}

