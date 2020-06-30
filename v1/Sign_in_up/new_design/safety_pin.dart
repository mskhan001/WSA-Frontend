import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_calls/SafetyPIN_api.dart';
import '../../new_reg_contacts/register_emergency_contacts.dart';
import '../components/constants.dart';
import '../components/round_button.dart';
import '../components/round_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        'User Details',
                        style: kHeadingTextStyle,
                      ),
                      Text(
                        'Enter your name and a 4 digit Safety PIN',
                        style: subHeadingTextStyle.copyWith(fontSize: 15),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundInputField(
                        hintText: 'Name',
                        icon: Icons.face,
                        validator: (String arg) {
                          if (arg.length < 4)
                            return 'Name must be more than 4 charater';
                          else
                            return null;
                        },
                        controller: _controller1,
                        keyboardType: TextInputType.text,
                        // inputFormatters: [
                        //   WhitelistingTextInputFormatter.digitsOnly
                        // ],
                      ),
                      RoundInputField(
                          hintText: 'Safety PIN',
                          icon: Icons.vpn_key,
                          validator: (value) {
                            if (value.length != 4)
                              return ' Safety Pin must be of 4 digit';
                            else
                              return null;
                          },
                          controller: _controller2,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                      RoundButton(
                        buttonName: 'SAVE DETAILS',
                        color: primaryColor,
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              message = 'Please wait';
                            });
                            var rsp = await sendetails(
                                _controller1.text, _controller2.text, tokens);
                            phonenum = rsp['phone_number'];
                            name = rsp['profile_name'];
                            print(rsp);
                            print(rsp.containsKey('message'));
                            if (rsp.containsKey('message')) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('toke', tokens);
                              prefs.setString('phonenum', phonenum);
                              prefs.setString('name', name);

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisterContacts(
                                    tokens: tokens,
                                    phonenum: phonenum,
                                    name: name),
                              ));
                            }
                          }
                        },
                      ),
                      // SizedBox(height: size.height * 0.03),
                      Text(message, style: TextStyle(color: Colors.redAccent)),
                    ]))
              ],
            ),
          ),
        )));
  }
}
