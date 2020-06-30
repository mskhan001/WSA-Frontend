import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Sidebar/SideBarLayout.dart';
import 'SignIn_sendOTP.dart';
import 'signIn_verifyotp_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                                  SizedBox(height: 10.0),
                                  SizedBox(height: 30.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10.0),
                                      Container(
                                        alignment: Alignment.center,
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
                                            if (value.length != 4)
                                              return 'OTP must be of 4 digit';
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
                                            letterSpacing: 15.5,
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(top: 0),
                                            hintText: '    Enter OTP',
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
                                        print(values);
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            message = 'Please wait';
                                          });

                                          var rsp = await verifyotp2(
                                              _controller.text, values);
                                          tokens = rsp['token'];
                                          print(tokens);
                                          phonenum = rsp['phone_number'];
                                          name = rsp['profile_name'];
                                          if (rsp.containsKey('token')) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString('toke', tokens);
                                            prefs.setString(
                                                'phonenum', phonenum);
                                            prefs.setString('name', name);

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SidebarLayout(
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
                                      padding: EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
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
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(message,
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(height: 15.0),
                                  RaisedButton(
                                    elevation: 5.0,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => SignIn()));
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
                                ])))
                  ],
                ),
              )),
        )));
  }
}
