import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'safety_pin.dart';
import 'signUp_send_otp.dart';
import '../api_calls/sign_in_up_api.dart';
import '../components/constants.dart';
import '../components/round_button.dart';
import '../components/round_input_field.dart';
import '../../global_data.dart' as server;

class SignUpverify extends StatefulWidget {
  String values;
  SignUpverify({this.values});
  @override
  _SignUpverifyState createState() => _SignUpverifyState(values);
}

class _SignUpverifyState extends State<SignUpverify> {
  final TextEditingController _controller = TextEditingController();
  String values;
  String tokens = "";
  String message = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _SignUpverifyState(this.values);
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
                        'Sign Up',
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
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              message = 'Please wait';
                            });
                            var rsp = await verifyotp_SignUp(
                                _controller.text, values);
                            tokens = rsp['token'];
                            print(tokens);
                            if (rsp.containsKey('token')) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SafetyPin(tokens: tokens),
                              ));
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
                          setState(() {
                            message = "";
                          });
                          Navigator.pop(context);
                          // Navigator.push(
                          //     context,
                          //     new MaterialPageRoute(
                          //         builder: (context) => SignUp()));
                        },
                      )
                    ])),
              ],
            ),
          ),
        )));
  }
}
