import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../global_data.dart' as server;

class SaveLocation {
  // This save the current location(latitude and longitude) along with the button that was pressed
  static Future<void> save_location(
      var tokens, var lat, var lon, var button) async {
    final String url = "${server.server_url}/savecurrentlocation";
    var body = jsonEncode({
      'lat': lat,
      'lon': lon,
      'button': button,
    });
    Response response = await post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          "x-access-tokens": tokens
        },
        body: body);
    print('REACHED HERE 3');
  }

  Future<void> get_landmarks(var lat, var lon) async {
    final String url = "${server.server_url}/getlandmarks";
    var body = jsonEncode({
      'lat': lat,
      'lon': lon,
    });
    print(body);
    Response response = await post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    // This prints the landmarks, use it wherever you want
    print(response.body);
  }
}
