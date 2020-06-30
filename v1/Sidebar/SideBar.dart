import 'dart:async';
//import 'package:flutter/rendering.dart';
import 'package:scbproject/AllPages/HomePage.dart';
import 'package:scbproject/Sign_in_up/components/constants.dart';

import '../AllPages/UserProfile/UserProfile.dart';
import '../bloc_Transition/transitions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "../AllPages/RegisteredContacts/EditRegisteredContacts.dart";
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../Sidebar/MenuItem.dart";
import '../Sign_in_up/new_design/signIn_send_otp.dart';
//import 'package:flutter/animation.dart';

class Sidebar extends StatefulWidget {
  String tokens;
  String phonenum;
  String name;
  Sidebar({this.tokens, this.phonenum, this.name});
  @override
  State<StatefulWidget> createState() {
    return _SidebarState(tokens, phonenum, name);
  }
}

class _SidebarState extends State<Sidebar>
    with SingleTickerProviderStateMixin<Sidebar> {
  String tokens;
  _SidebarState(this.tokens, this.phonenum, this.name);
  String phonenum;
  String name;

  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationduration = const Duration(milliseconds: 500);

  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationduration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationstatus = _animationController.status;
    final isAnimatedCompleted = animationstatus == AnimationStatus.completed;
    if (isAnimatedCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
        initialData: false,
        stream: isSidebarOpenedStream,
        builder: (context, isSideBarOpenedAsync) {
          return AnimatedPositioned(
            duration: _animationduration,
            top: screenWidth * 0.05,
            bottom: screenWidth * 0.05,
            left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
            right: isSideBarOpenedAsync.data
                ? screenWidth * 0.2
                : screenWidth - 45,
            child: Row(children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey.shade200,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      ListTile(
                        title: Text('Women Safety App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                              color: primaryColor,
                            )),
                      ),
                      Divider(
                        height: 30,
                        color: primaryColor,
                      ),
                      MenuItem(
                          icon: Icons.account_box,
                          title: "User Profile",
                          onTap: () {
                            onIconPressed();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Userprofile(
                                  tokens: tokens,
                                  phonenum: phonenum,
                                  name: name),
                            ));
                          }),
                      MenuItem(
                        icon: Icons.contacts,
                        title: "Registered Contacts",
                        onTap: () {
                          onIconPressed();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditRegisteredContacts(tokens: tokens),
                          ));
                        },
                      ),
                      MenuItem(
                        icon: Icons.notifications_active,
                        title: "Emergency Notifications",
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context).add(
                              NavigationEvents
                                  .EmergencyNotificationClickedEvent);
                        },
                      ),
                      MenuItem(
                        icon: Icons.home,
                        title: "Home",
                        onTap: () {
                          onIconPressed();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => MyHomePage(),
                          // ));
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.MyHomePageClickedEvent);
                          onIconPressed();
                        },
                      ),
                      MenuItem(
                        icon: Icons.exit_to_app,
                        title: "Log out",
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('toke');
                          prefs.remove('phonenum');
                          prefs.remove('name');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (route) => false);
                        },
                      )
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment(0, -1),
                  child: (GestureDetector(
                      onTap: () {
                        onIconPressed();
                      },
                      child: ClipPath(
                        clipper: CustomMenuClipper(),
                        child: Container(
                          width: 35,
                          height: 80,
                          color: Colors.white,
                          alignment: Alignment.centerLeft,
                          child: AnimatedIcon(
                            progress: _animationController.view,
                            icon: AnimatedIcons.menu_close,
                            color: primaryColor,
                            size: 25,
                          ),
                        ),
                      ))))
            ]),
          );
        });
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 8, 20);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
