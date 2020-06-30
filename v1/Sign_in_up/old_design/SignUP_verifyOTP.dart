import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SafetyPIN.dart';
import 'SignUp_sendOTP.dart';
import 'signup_verifyotp_api.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                        vertical: 80.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10.0),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3F51B5),
                                  borderRadius: BorderRadius.circular(10.0),
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
                                    if (value.length != 4)
                                      return 'OTP must be of 4 digit';
                                    else
                                      return null;
                                  },
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 15.5,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 0),
                                    hintText: "Enter OTP",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 30.0),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      message = 'Please wait';
                                    });
                                    var rsp = await verifyotp(
                                        _controller.text, values);
                                    tokens = rsp['token'];
                                    print(tokens);
                                    if (rsp.containsKey('token')) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SafetyPin(tokens: tokens),
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
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                                child: Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    color: Color(0xFF3F51B5),
                                    letterSpacing: 1.5,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          SizedBox(height: 30.0),
                          Text(message, style: TextStyle(color: Colors.white)),
                          SizedBox(height: 15.0),
                          RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              setState(() {
                                message = "";
                              });
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Colors.white,
                            child: Text(
                              'Back',
                              style: TextStyle(
                                color: Color(0xFF3F51B5),
                                letterSpacing: 1.5,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
