import '../bloc_Transition/transitions.dart';
import 'package:flutter/material.dart';

class EmergencyNotification extends StatelessWidget with Navigationstates {
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Emergency Notification",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
