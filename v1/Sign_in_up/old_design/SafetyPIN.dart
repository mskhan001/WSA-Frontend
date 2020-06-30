import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SafetyPIN_api.dart';
import '../../new_reg_contacts/register_emergency_contacts.dart';

class SafetyPin extends StatefulWidget {
  String tokens;
  SafetyPin({this.tokens});
  @override
  _SafetyPinState createState() => _SafetyPinState(tokens);
}

class _SafetyPinState extends State<SafetyPin> {
  String tokens;
  _SafetyPinState(this.tokens);
  String phonenum;
  String name;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String message = "";
  final _formKey = GlobalKey<FormState>();
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
                              vertical: 120.0,
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'User Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Enter a User name and a 4 digit Safety PIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            validator: (String arg) {
                                              if (arg.length < 4)
                                                return 'Name must be more than 4 charater';
                                              else
                                                return null;
                                            },
                                            controller: _controller1,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 7,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 0),
                                              hintText: '    Enter User Name',
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0),
                                            ),
                                          ),
                                        )
                                      ]),
                                  SizedBox(height: 10.0),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              if (value.length != 4)
                                                return 'OTP must be of 4 digit';
                                              else
                                                return null;
                                            },
                                            controller: _controller2,
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
                                                  '    Enter your Safety PIN',
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    width: double.infinity,
                                    child: RaisedButton(
                                      elevation: 5.0,
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            message = 'Please wait';
                                          });
                                          var rsp = await sendetails(
                                              _controller1.text,
                                              _controller2.text,
                                              tokens);
                                          phonenum = rsp['phone_number'];
                                          name = rsp['profile_name'];
                                          if (rsp.containsKey('message')) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterContacts(
                                                      tokens: tokens,
                                                      phonenum: phonenum,
                                                      name: name),
                                            ));
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
                                        'Save Safety PIN',
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
                                ])))
                  ],
                ),
              )),
        )));
  }
}
