import '../Sidebar/SideBarLayout.dart';
import 'HomePage.dart';
import '../AllPages/message.dart';
import '../AllPages/yes.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import '../AllPages/pin_enter_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Sign_in_up/components/constants.dart';
import '../Sign_in_up/components/round_button.dart';
import '../Sign_in_up/components/round_input_field.dart';

class Pin extends StatelessWidget {
  String tokens;
  String phonenum;
  String name;
  Pin(this.tokens, this.phonenum, this.name);
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PinPage(tokens, phonenum, name),
    );
  }
}

class PinPage extends StatefulWidget {
  String tokens;
  String phonenum;
  String name;
  PinPage(this.tokens, this.phonenum, this.name);

  @override
  PinPageState createState() => PinPageState(tokens, phonenum, name);
}

class PinPageState extends State<PinPage> {
  String tokens;
  String phonenum;
  String name;
  PinPageState(this.tokens, this.phonenum, this.name);
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String message = "";
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void autoPress() {
    new Future.delayed(const Duration(seconds: 10), () {
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
                      Text('Mark Yourself Safe', style: kHeadingTextStyle),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      RoundInputField(
                          icon: Icons.vpn_key,
                          hintText: 'Enter your safety PIN',
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
                          ]),
                      RoundButton(
                        buttonName: 'Submit',
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              message = 'Please wait';
                            });
                            var rsp = await verifypin(_controller.text, tokens);
                            if (rsp.containsKey('message')) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('toke2');
                              setState(() {
                                message =
                                    'We have stopped sending emergency alerts to your emergency contacts';
                                MyHome2.flag_send_location = false;
                              });
                              autoPress();
                            }
                            if (rsp.containsKey('message2')) {
                              setState(() {
                                message = "PIN is incorrect, try again";
                              });
                            }
                          }
                        },
                      ),
                      Text(message, style: TextStyle(color: Colors.redAccent)),
                      SizedBox(height: size.height * 0.03),
                      RoundButton(
                        buttonName: 'BACK',
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]))
              ]),
            )));
  }
}
