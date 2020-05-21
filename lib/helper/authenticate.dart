import 'package:flutter/material.dart';
import 'package:jaleelchat/views/signin.dart';
import 'package:jaleelchat/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSigIn = true;

  void toggleView() {
    setState(() {
      showSigIn = !showSigIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSigIn) {
      return SignIn(toggle: toggleView);
    } else {
      return SignUp(
        toggle: toggleView,
      );
    }
  }
}
