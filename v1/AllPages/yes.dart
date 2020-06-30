import 'dart:math';

import '../AllPages/Pin.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "dart:async";
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../global_data.dart' as server;
import '../Sign_in_up/components/constants.dart';
import 'SaveLocation.dart';

Future get_landmarks(var lat, var lon) async {
  // This will give the nearest landmarks as a Map with integers as keys
  final String url = "${server.server_url}/getlandmarks";
  var body = jsonEncode({
    'lat': lat,
    'lon': lon,
  });
  Response response = await post(url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: body);

  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

class Alert2 extends StatelessWidget {
  String tokens;
  String phonenum;
  String name;
  Alert2(this.tokens, this.phonenum, this.name);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome2(tokens, phonenum, name),
    );
  }
}

const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DESTINATION_LOCATION = LatLng(37.335685, -122.0605916);

class MyHome2 extends StatefulWidget {
  String tokens;
  String phonenum;
  String name;
  MyHome2(this.tokens, this.phonenum, this.name);
  static bool flag_send_location = true;
  @override
  State<StatefulWidget> createState() {
    return MyHome2State();
  }
}

class MyHome2State extends State<MyHome2> {
  Completer<GoogleMapController> _controller = Completer();
// Set<Marker> _markers = Set<Marker>();
  List<Marker> allmarkers = [];

  var currentlocation;
//the users initial location and current location as it moves
  LocationData currentLocation;

//A reference to the destination Location
  LocationData destinationLocation;
//wrapper around the location API
  Location location;

  void initState() {
    super.initState();
    location = new Location();
    location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });
    setInitialLocation();
    _send_location_continously();
  }

  _send_location_continously() {
    Duration two_min = Duration(seconds: 5);
    new Timer.periodic(two_min, (timer) {
      if (MyHome2.flag_send_location) {
        print('SAVING LOCATION');
        print(currentLocation);
        SaveLocation.save_location(widget.tokens, currentLocation.latitude,
            currentLocation.longitude, 'Emergency Alert');
      } else {
        timer.cancel();
      }
    });
  }

// This gives radom numbers for markers
  int generateids() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    print(rng.nextInt(100));
    return randomInt;
  }

  buildmarkers() async {
    var landmarks = await get_landmarks(
        currentLocation.latitude, currentLocation.longitude);
    for (int i = 0; i < landmarks.length; i++) {
      String str = landmarks["$i"];
      int place = str.indexOf(";");
      int latitude = str.indexOf(";", place + 1);
      int longitude = str.indexOf(";", latitude + 1);
      String name = str.substring(0, place - 1);
      String lat = str.substring(place + 1, latitude - 1);
      String lon = str.substring(latitude + 1, longitude - 1);
      allmarkers.add(Marker(
        markerId: MarkerId(generateids().toString()),
        position: LatLng(double.parse('$lat'), double.parse('$lon')),
        infoWindow: InfoWindow(title: name),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(target: SOURCE_LOCATION, zoom: 15);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "Safety App",
      //     style: TextStyle(fontSize: 30),
      //   ),
      // ),
      body: Column(children: [
        Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
                myLocationEnabled: true,
                markers: Set.from(allmarkers),
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showPinsOnMap();
                }),
          ),
          Positioned(bottom: 10, left: 5, right: 5, child: safetyButton()),
        ])
      ]),
    );
  }

  void showPinsOnMap() {
    var destposition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    // Marker markerinti = Marker(markerId: MarkerId("destpin"),position: destposition);
    //allmarkers[MarkerId("destpin")]= markerinti;
    allmarkers
        .add(Marker(markerId: MarkerId("destpin"), position: destposition));
  }

  void setInitialLocation() async {
    currentLocation == await location.getLocation();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 20);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      //Marker markerin = Marker(markerId: MarkerId("SourcePin"),position: pinPosition);
      // markers[MarkerId("SourcePin")]= markerin;
      allmarkers.removeWhere((m) => m.markerId.value == "SourcePin");
      allmarkers
          .add(Marker(markerId: MarkerId("SourcePin"), position: pinPosition));
      buildmarkers();
      allmarkers.add(
          (Marker(markerId: MarkerId("Sahithi"), position: LatLng(20, 85))));
    });
  }

  Widget safetyButton() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PinPage(widget.tokens, widget.phonenum, widget.name)));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             Pin(widget.tokens, widget.phonenum, widget.name)));
          },
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // gradient: LinearGradient(colors: [
                  //   Color(0xFF0D47A1),
                  //   Color(0xFF1976D2),
                  //   Color(0xFF42A5F5),
                  // ])
                  color: primaryColor),
              child: Center(
                  child: Text(
                "Enter Safety Pin",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              )),
            ),
          ),
        ));
  }
}
