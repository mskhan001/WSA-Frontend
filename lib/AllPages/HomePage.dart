import 'dart:io';
import 'dart:math';
import '../AllPages/yes.dart';
import '../bloc_Transition/transitions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "dart:async";
import 'SaveLocation.dart';
import 'package:geolocator/geolocator.dart';
import '../AllPages/popup_card.dart';
import 'popup_card.dart';
import 'package:http/http.dart';
import '../global_data.dart' as server;
import 'dart:convert';
import '../Sign_in_up/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DESTINATION_LOCATION = LatLng(37.335685, -122.0605916);

class MyHomePage extends StatefulWidget with Navigationstates {
  String tokens;
  String phonenum;
  String name;
  MyHomePage({this.tokens, this.phonenum, this.name});
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState(tokens, phonenum, name);
  }
}

class MyHomePageState extends State<MyHomePage> {
  String tokens;
  String phonenum;
  String name;
  MyHomePageState(this.tokens, this.phonenum, this.name);

  Completer<GoogleMapController> _controller = Completer();
  // Set<Marker> _markers = Set<Marker>();
  List<Marker> _markers = [];
  var currentlocation;
  //the users initial location and current location as it moves
  LocationData currentLocation;
  //A reference to the destination Location
  LocationData destinationLocation;
  //wrapper around the location API
  Location location = new Location();
  StreamSubscription<LocationData> locationSubscription;
  void initState() {
    super.initState();
    setInitialLocation();
    // location = new Location();
    // print('THIS IS THE CURRENT LOCATION 1 $currentLocation');
    try {
      // print('WAS HERE');
      locationSubscription =
          location.onLocationChanged.listen((LocationData cLoc) {
        // print('THIS IS THE CURRENT LOCATION 2 $currentLocation');
        currentLocation = cLoc;
        // print('THIS IS THE CURRENT LOCATION 3 $currentLocation');
        updatePinOnMap();
      });
    } catch (e) {
      print('THERE WAS AN ERROR');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationSubscription.cancel();
    print('HOME PAGE STATE WAS DISPOSED');
  }

  int generateids() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
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
      _markers.add(Marker(
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                    myLocationEnabled: true,
                    markers: Set.from(_markers),
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      // showPinsOnMap();
                    }),
              ),
              Positioned(
                  bottom: 10,
                  left: 5,
                  right: 5,
                  child: EmergencyAlert_Button()),
              Positioned(
                  bottom: 70, left: 5, right: 5, child: ShareLocation_Button()),
              Positioned(
                top: 70,
                right: 5,
                child: NearestLandmark_Button(),
              )
            ])
          ]),
        ),
      ),
    );
  }

  void showPinsOnMap() {
    var destposition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    _markers.add(Marker(markerId: MarkerId("destpin"), position: destposition));
  }

// Called in initState()
// This sets the initial location
  void setInitialLocation() async {
    try {
      Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentlocation = currloc;
        });
      });
    } catch (e) {
      print('GEOLOCATOR ERROR');
    }
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 10);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers
          .add(Marker(markerId: MarkerId('sourcePin'), position: pinPosition));
    });
  }

  Widget EmergencyAlert_Button() {
    return MapScreenButton(
      buttonName: 'Emergency Alert !',
      onTap: () async {
        // Popup for Selecting the contacts through Radio Buttons
        var result = await showDialog(
            context: context, builder: (context) => PopupCard(tokens));

        if (result == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('toke2', tokens);

          // This saves the current location every 2 minutes until stopped into the database
          // Duration two_min = Duration(seconds: 2);
          // new Timer.periodic(two_min, (timer) {
          //   SaveLocation.save_location(tokens, currentLocation.latitude,
          //       currentLocation.longitude, 'Emergency Alert');
          // });

          // Takes you to the new Emergency Page
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHome2(tokens, phonenum, name)),
              (route) => false);
        }
      },
    );
  }

  Widget ShareLocation_Button() {
    return MapScreenButton(
      buttonName: 'Share Location',
      onTap: () async {
        // Write the code for sharing location
        // The code for popup comes here
        var result = await showDialog(
            context: context, builder: (context) => PopupCard(tokens));
        // await Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => PopupCard(tokens)));
        // This saves the current location only once into the database
        if (result == true) {
          SaveLocation.save_location(tokens, currentLocation.latitude,
              currentLocation.longitude, 'Share Location');
        }
      },
    );
  }

  Widget NearestLandmark_Button() {
    return MapScreenButton(
      buttonName: 'Nearest Landmarks',
      onTap: () {
        // Write code for getting Nearest Landmarks
        setState(() {
          setState(() {
            buildmarkers();
          });
        });
      },
    );
  }
}

class MapScreenButton extends StatelessWidget {
  final String buttonName;
  final Function onTap;

  MapScreenButton({this.buttonName, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: InkWell(
          onTap: onTap,
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
                buttonName,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  // fontWeight: FontWeight.w500
                ),
              )),
            ),
          ),
        ));
  }
}
