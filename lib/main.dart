import 'package:flutter/material.dart';
// import 'Sign_in_up/old_design/SignIn_sendOTP.dart';
import 'Sign_in_up/screens/signIn_send_otp.dart';
import 'Sidebar/SideBarLayout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Allpages/yes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var toke = prefs.getString('toke');
  var phonenum = prefs.getString('phonenum');
  var name = prefs.getString('name');
  var toke2 = prefs.getString('toke2');
  print(toke);
  print(phonenum);
  print(name);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: toke == null
          ? SignIn()
          : toke != null && toke2 != null
              ? MyHome2(toke, phonenum, name)
              : SidebarLayout(tokens: toke, phonenum: phonenum, name: name)));
}
