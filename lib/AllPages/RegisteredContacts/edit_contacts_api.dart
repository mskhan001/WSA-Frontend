import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../global_data.dart' as server;

/*
1. /savecontact {"phone_num":, "user_name" }
2. /deletecontact {"phone_num": }
3. /getallcontacts 
*/
class EditContactsApi {
  static Future registered_contacts(String token) async {
    String url = "${server.server_url}/getallcontacts";
    Response response = await get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      "x-access-tokens": token
    });

    return (jsonDecode(response.body));
  }

  static Future<void> delete_contact(var phone_num, String token) async {
    String url = "${server.server_url}/deletecontact";
    var body = jsonEncode({
      'phone_num': phone_num,
    });
    Response response = await post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "x-access-tokens": token
        },
        body: body);
  }

  static Future<void> save_emergency_contact(
      List registeredContacts, String token) async {
    String url = "${server.server_url}/savecontact";
    Response response = await post(url,
        body: jsonEncode(registeredContacts),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "x-access-tokens": token
        });
  }
}
