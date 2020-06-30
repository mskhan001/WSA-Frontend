import '../../AllPages/UserProfile/ChangePIN_sendOTP.dart';
import '../../AllPages/UserProfile/Userprofile_api.dart';
import '../../Sidebar/SideBarLayout.dart';
import '../../bloc_Transition/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';

class Userprofile extends StatefulWidget with Navigationstates {
  String tokens;
  String phonenum;
  String name;
  Userprofile({this.tokens, this.phonenum, this.name});

  @override
  _UserprofileState createState() => _UserprofileState(tokens, phonenum, name);
}

class _UserprofileState extends State<Userprofile> {
  String tokens;
  String phonenum;
  String name;
  _UserprofileState(this.tokens, this.phonenum, this.name);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            width: size.width,
            height: size.height,
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/main_top.png',
                  width: size.width * 0.30,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('assets/images/login_bottom.png',
                    width: size.width * 0.30),
              ),
              SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text('Your Details', style: kHeadingTextStyle),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                          child: ListTile(
                              leading: Text(
                                'NAME : ',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                          child: ListTile(
                              leading: Text(
                                'CONTACT : ',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                phonenum,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                ),
                              ))),
                    ),
                    RoundButton(
                      buttonName: 'Change SAFETY PIN',
                      onPress: () {
                        print(tokens);
                        print(phonenum);
                        print(name);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ChangePin(
                                    tokens: tokens,
                                    phonenum: phonenum,
                                    name: name)));
                        // BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ChangeSafetyPinClickedEvent);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    RoundButton(
                      buttonName: 'BACK',
                      onPress: () {
                        Navigator.pop(context);
                        // Navigator.push(
                        //     context,
                        //     new MaterialPageRoute(
                        //         builder: (context) => SidebarLayout(
                        //               tokens: tokens,
                        //               phonenum: phonenum,
                        //               name: name,
                        //             )));
                      },
                    )
                  ]))
            ])));
  }
}
