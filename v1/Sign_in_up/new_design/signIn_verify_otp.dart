import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scbproject/AllPages/HomePage.dart';
import '../../Sidebar/SideBarLayout.dart';
import 'signIn_send_otp.dart';
import 'api_calls/signIn_verifyotp_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/constants.dart';
import '../components/round_button.dart';
import '../components/round_input_field.dart';
import '../../global_data.dart' as server;
import '../../AllPages/RegisteredContacts/edit_contacts_api.dart';

class Signinverify extends StatefulWidget {
  String values;
  Signinverify({this.values});

  @override
  _SigninverifyState createState() => _SigninverifyState(values);
}

class _SigninverifyState extends State<Signinverify> {
  String values;
  _SigninverifyState(this.values);
  String phonenum;
  String name;
  final TextEditingController _controller = TextEditingController();
  String tokens = "";
  String message = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
          width: size.width,
          height: size.height,
          child: Form(
            key: _formKey,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
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
                        'Women Safety App',
                        style: kHeadingTextStyle,
                      ),
                      Text(
                        'Sign In',
                        style: subHeadingTextStyle,
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundInputField(
                        hintText: 'OTP',
                        icon: Icons.verified_user,
                        validator: (value) {
                          if (value.length != 4)
                            return 'OTP must be of 4 digits';
                          else
                            return null;
                        },
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                      ),
                      RoundButton(
                        buttonName: 'VERIFY OTP',
                        color: primaryColor,
                        onPress: () async {
                          print(values);
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              message = 'Please wait';
                            });

                            var rsp =
                                await verifyotp2(_controller.text, values);
                            tokens = rsp['token'];

                            print(tokens);
                            phonenum = rsp['phone_number'];
                            name = rsp['profile_name'];
                            if (rsp.containsKey('token')) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('toke', tokens);
                              prefs.setString('phonenum', phonenum);
                              prefs.setString('name', name);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SidebarLayout(
                                          tokens: tokens,
                                          phonenum: phonenum,
                                          name: name)),
                                  (route) => false);
                            }

                            if (rsp.containsKey('message1')) {
                              setState(() {
                                message = "OTP expired";
                              });
                            }
                            if (rsp.containsKey('message2')) {
                              setState(() {
                                message = "OTP is incorrect";
                              });
                            }
                          }
                        },
                      ),
                      // SizedBox(height: size.height * 0.03),
                      Text(message, style: TextStyle(color: Colors.redAccent)),
                      SizedBox(height: 15.0),
                      RoundButton(
                        buttonName: "BACK",
                        onPress: () {
                          Navigator.pop(context);
                          // Navigator.push(
                          //     context,
                          //     new MaterialPageRoute(
                          //         builder: (context) => SignIn()));
                        },
                      )
                    ])),
              ],
            ),
          ),
        )));
  }
}
