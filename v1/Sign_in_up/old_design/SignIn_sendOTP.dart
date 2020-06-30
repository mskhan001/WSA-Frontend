import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SignUp_sendOTP.dart';
import 'SignIn_senotp_api.dart';
import 'SignIn_verifyOTP.dart';

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
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3F51B5),
                      Color(0xFF3F51B5),
                      Color(0xFF3F51B5),
                      Color(0xFF3F51B5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  )),
                ),
                Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 120.0,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Safety App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              SizedBox(height: 30.0),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3F51B5),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 6.0,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      height: 60.0,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.length != 10)
                                            return 'Mobile Number must be of 10 digit';
                                          else
                                            return null;
                                        },
                                        controller: _controller,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 7,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(top: 0),
                                          hintText:
                                              '    Enter your Phone Number',
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0),
                                        ),
                                      ),
                                    )
                                  ]),
                              SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: double.infinity,
                                child: RaisedButton(
                                  elevation: 5.0,
                                  onPressed: () async {
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
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              Signinverify(values: values),
                                        ));
                                      }
                                    }
                                  },
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(
                                      color: Color(0xFF3F51B5),
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(message,
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 15.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: 'New to the App?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ])),
                              )
                            ])))
              ],
            ),
          )),
    ));
  }
}
