import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../AllPages/UserProfile/ChangePIN_sendOTP.dart';
import '../../AllPages/UserProfile/changepin_verifyotp_api.dart';
import '../../AllPages/UserProfile/EnterPIN.dart';
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';
import '../../Sign_in_up/components/round_input_field.dart';

class Changepinverify extends StatefulWidget {
  String tokens;
  String values;
  String phonenum;
  String name;
  Changepinverify({this.tokens, this.values, this.phonenum, this.name});
  @override
  _ChangepinverifyState createState() =>
      _ChangepinverifyState(tokens, values, phonenum, name);
}

class _ChangepinverifyState extends State<Changepinverify> {
  String tokens;
  String values;
  String phonenum;
  String name;
  String message = "";
  _ChangepinverifyState(this.tokens, this.values, this.phonenum, this.name);
  final TextEditingController _controller = TextEditingController();
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
                      Text('Change PIN', style: kHeadingTextStyle),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      RoundInputField(
                          validator: (value) {
                            if (value.length != 4)
                              return 'OTP must be of 4 digit';
                            else
                              return null;
                          },
                          hintText: 'Enter OTP',
                          icon: Icons.verified_user,
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                      RoundButton(
                        buttonName: 'Verify OTP',
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              message = 'Please wait';
                            });
                            var rsp = await verifyotp(
                                _controller.text, values, tokens);
                            if (rsp.containsKey('message')) {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Enterpin(
                                          tokens: tokens,
                                          values: values,
                                          phonenum: phonenum,
                                          name: name)));
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
                      Text(message, style: TextStyle(color: Colors.redAccent)),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      RoundButton(
                        buttonName: 'BACK',
                        onPress: () {
                          Navigator.pop(context);
                        },
                      )
                    ]))
              ]),
            )));
  }
}
