import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaleelchat/helper/constants.dart';
import 'package:jaleelchat/helper/helper_functions.dart';
import 'package:jaleelchat/services/database.dart';
import 'package:jaleelchat/views/conversation_screen.dart';
import 'package:jaleelchat/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      print('whats here $val');
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print('${searchSnapshot.documents[index].data["name"]}');
              return SearchTile(
                searchSnapshot.documents[index].data["name"],
                searchSnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameInSharedPreference();

    setState(() {});
  }

  // Create a chat room. send user to conversation screen.

  createChatRoomAndStartConversation({String username}) {
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ConversationScreen(
            chatRoomId: chatRoomId,
          )));
    } else {
      print("you cannot send me message to yourself");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget SearchTile(String userName, String userEmail) {
    print(userName);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: simpleTextFieldStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextFieldStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(username: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(13)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message 1",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Color(0x54FFFFFF),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                              hintText: "Search Username",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              border: InputBorder.none),
                        )),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ]),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Image.asset(
                                  "assets/images/search_white.png")),
                        )
                      ],
                    )
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ));
  }
}
