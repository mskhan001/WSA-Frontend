import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../global_data.dart' as server;

/*
1. /savecontact {"phone_num":, "user_name" }
2. /deletecontact {"phone_num": }
*/
class ContactApi {
  final List registeredContacts;
  ContactApi({this.registeredContacts});

  String url = "${server.server_url}/savecontact";

  Future<void> save_emergency_contact(String token) async {
    Response response = await post(url,
        body: jsonEncode(registeredContacts),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "x-access-tokens": token
        });

    print(response.body);
  }
}
