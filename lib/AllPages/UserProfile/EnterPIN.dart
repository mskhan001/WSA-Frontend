import '../../bloc_Transition/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Sidebar/SideBarLayout.dart';
import '../../AllPages/UserProfile/enterpin_api.dart';
import '../../Sign_in_up/components/constants.dart';
import '../../Sign_in_up/components/round_button.dart';
import '../../Sign_in_up/components/round_input_field.dart';

class Enterpin extends StatefulWidget with Navigationstates {
  String tokens;
  String values;
  String phonenum;
  String name;
  Enterpin({this.tokens, this.values, this.phonenum, this.name});
  @override
  _EnterpinState createState() =>
      _EnterpinState(tokens, values, phonenum, name);
}

class _EnterpinState extends State<Enterpin> {
  String tokens;
  String values;
  String phonenum;
  String name;
  _EnterpinState(this.tokens, this.values, this.phonenum, this.name);
  String message = "";
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void autoPress() {
    new Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SidebarLayout(
                  tokens: tokens, phonenum: phonenum, name: name)),
          (route) => false);
    });
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
                      Text('New PIN', style: kHeadingTextStyle),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      RoundInputField(
                          icon: Icons.vpn_key,
                          hintText: 'Enter New PIN',
                          validator: (value) {
                            if (value.length != 4)
                              return 'OTP must be of 4 digit';
                            else
                              return null;
                          },
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                      RoundInputField(
                          icon: Icons.vpn_key,
                          hintText: 'Re-enter New PIN',
                          validator: (value) {
                            if (value.length != 4)
                              return 'OTP must be of 4 digit';
                            else
                              return null;
                          },
                          controller: _controller2,
                          // obscureText: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly
                          ]),
                      RoundButton(
                        buttonName: 'Confirm New PIN',
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            if (_controller1.text == _controller2.text) {
                              setState(() {
                                message = 'Please wait';
                              });

                              var rsp =
                                  await enterpin(_controller1.text, tokens);
                              if (rsp.containsKey('message')) {
                                setState(() {
                                  message = 'PIN changed!';
                                });
                                autoPress();
                              }
                            }
                            if ((_controller1.text) != _controller2.text) {
                              setState(() {
                                message = "PINs do not match, Try again";
                              });
                            }
                          }
                        },
                      ),
                      Text(message, style: TextStyle(color: Colors.redAccent)),
                    ]))
              ]),
            )));
  }
}
