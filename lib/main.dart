import 'package:flutter/material.dart';
import 'package:jaleelchat/helper/authenticate.dart';
import 'package:jaleelchat/helper/helper_functions.dart';
import 'package:jaleelchat/views/chat_room.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInInSharedPreference().then((value) {
      setState(() {
        print('-- $value');
        if (value != null) {
          userIsLoggedIn = value;
        }

        value = false;
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primaryColor: Color(0xff145C9E),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
