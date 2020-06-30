import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../global_data.dart' as server;

/*
1. /savecontact {"phone_num":, "user_name" }
2. /deletecontact {"phone_num": }
3. /getallcontacts 
*/
class SendMessageApi {
  static Future send_messages(var phone_nums, var message, var tokens) async {
    String url = "${server.server_url}/sendmessage";
    var body = jsonEncode({"phone_nums": phone_nums, "message": message});
    Response response = await post(url, body: body, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-access-tokens": tokens
    });
  }
}
