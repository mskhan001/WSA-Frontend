import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signUp_verify_otp.dart';
import '../api_calls/sign_in_up_api.dart';
import 'signIn_send_otp.dart';
import '../components/constants.dart';
import '../components/round_button.dart';
import '../components/round_input_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controller = TextEditingController();
  String values = "";
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
                      'Sign Up',
                      style: subHeadingTextStyle,
                    ),
                    SizedBox(height: size.height * 0.03),
                    RoundInputField(
                      hintText: 'Phone Number',
                      icon: Icons.phone_iphone,
                      validator: (value) {
                        if (value.length != 10)
                          return 'Mobile Number must be of 10 digit';
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
                      buttonName: 'SEND OTP',
                      color: primaryColor,
                      onPress: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            message = 'Please Wait';
                          });
                          var rsp = await sendotp_SignUp(_controller.text);
                          values = rsp['sessionid'];
                          if (rsp.containsKey('message')) {
                            setState(() {
                              message =
                                  "Phone number already registered! Please Sign In";
                            });
                          }
                          if (rsp.containsKey('sessionid')) {
                            print(values);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SignUpverify(values: values),
                            ));
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
                        //         builder: (context) => SignIn()));
                      },
                    )
                  ]))
            ],
          ),
        ),
      )),
    );
  }
}
