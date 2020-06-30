import '../bloc_Transition/transitions.dart';
import 'package:flutter/material.dart';

class LogOut extends StatelessWidget with Navigationstates {
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "You are Successfully Loggedout",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
