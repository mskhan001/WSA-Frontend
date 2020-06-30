import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../AllPages/UserProfile/ChangePIN_verifyotp.dart';
import '../../AllPages/UserProfile/UserProfile.dart';
import '../../AllPages/UserProfile/changepin_sendotp_api.dart';
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';

class ChangePin extends StatefulWidget {
  String tokens;
  String phonenum;
  String name;
  ChangePin({this.tokens, this.phonenum, this.name});
  @override
  _ChangePinState createState() => _ChangePinState(tokens, phonenum, name);
}

class _ChangePinState extends State<ChangePin> {
  String tokens;
  String phonenum;
  String name;
  String values;
  String message = "";
  _ChangePinState(this.tokens, this.phonenum, this.name);
  // Widget _sendotpbutton() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(vertical: 10.0),
  //     width: double.infinity,
  //     child: RaisedButton(
  //       elevation: 5.0,
  //       onPressed: () async {
  //         setState(() {
  //           message = "Please wait";
  //         });
  //         var rsp = await sendotp(tokens);
  //         values = rsp['session_id'];
  //         print(values);
  //         if (rsp.containsKey('session_id')) {
  //           Navigator.push(
  //               context,
  //               new MaterialPageRoute(
  //                   builder: (context) => Changepinverify(
  //                       tokens: tokens,
  //                       values: values,
  //                       phonenum: phonenum,
  //                       name: name)));
  //         }
  //       },
  //       padding: EdgeInsets.all(15.0),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30.0),
  //       ),
  //       color: Colors.white,
  //       child: Text(
  //         'Send OTP',
  //         style: TextStyle(
  //           color: Color(0xFF3F51B5),
  //           letterSpacing: 1.5,
  //           fontSize: 18.0,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
                    Text(
                      'Change PIN',
                      style: kHeadingTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                          child: ListTile(
                              title: Text(
                        'If you forgot your PIN, you can change it by entering an OTP. We will send an OTP to the registered phone number.',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                        ),
                      ))),
                    ),
                    RoundButton(
                      buttonName: 'SEND OTP',
                      onPress: () async {
                        setState(() {
                          message = "Please wait";
                        });
                        var rsp = await sendotp(tokens);
                        values = rsp['session_id'];
                        print(values);
                        if (rsp.containsKey('session_id')) {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Changepinverify(
                                      tokens: tokens,
                                      values: values,
                                      phonenum: phonenum,
                                      name: name)));
                        }
                      },
                    ),
                    Text(message, style: TextStyle(color: Colors.redAccent)),
                    SizedBox(height: size.height * 0.03),
                    RoundButton(
                      buttonName: ' BACK',
                      onPress: () {
                        Navigator.pop(context);
                      },
                    )
                  ]))
            ])));
  }
}
