import 'package:flutter/material.dart';
import 'package:jaleelchat/helper/helper_functions.dart';
import 'package:jaleelchat/services/auth.dart';
import 'package:jaleelchat/services/database.dart';
import 'package:jaleelchat/views/chat_room.dart';
import 'package:jaleelchat/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  const SignUp({Key key, this.toggle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, dynamic> userMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      HelperFunctions.saveUserLoggedInSharedPreference(true);
      HelperFunctions.saveUserNameInSharedPreference(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailInSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        databaseMethods.uploadUsersInfo(userMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 60,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty || value.length < 4
                                    ? "Please enter the username"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Please provide password 6+ characters";
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextFieldStyle(),
                              decoration: textFieldInputDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            "Forgot Password ?",
                            style: simpleTextFieldStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC),
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign Up ',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Sign up    with Google',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have account ? ",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Sign in now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
