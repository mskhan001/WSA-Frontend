import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signUp_send_otp.dart';
import 'api_calls/SignIn_senotp_api.dart';
import 'signIn_verify_otp.dart';
import '../components/constants.dart';
import '../components/round_button.dart';
import '../components/round_input_field.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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

    return Scaffold(
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
                        var rsp = await sendotp(_controller.text);
                        values = rsp['session_id'];
                        if (rsp.containsKey('message')) {
                          setState(() {
                            message =
                                "Phone number not registered! Please Sign Up";
                          });
                        }
                        if (rsp.containsKey('session_id')) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Signinverify(values: values),
                          ));
                        }
                      }
                    },
                  ),
                  // SizedBox(height: size.height * 0.03),
                  Text(message, style: TextStyle(color: Colors.redAccent)),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('New to the App ? ',
                          style: TextStyle(color: primaryColor)),
                      GestureDetector(
                        onTap: () {
                          //Go to the SIGN Up Page
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                        child: Text('Sign Up',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ]))
          ],
        ),
      ),
    ));
  }
}
