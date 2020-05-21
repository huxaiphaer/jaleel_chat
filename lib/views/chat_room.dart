import 'package:flutter/material.dart';
import 'package:jaleelchat/helper/authenticate.dart';
import 'package:jaleelchat/helper/constants.dart';
import 'package:jaleelchat/helper/helper_functions.dart';
import 'package:jaleelchat/services/auth.dart';
import 'package:jaleelchat/services/database.dart';
import 'package:jaleelchat/views/conversation_screen.dart';
import 'package:jaleelchat/views/search.dart';
import 'package:jaleelchat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (__context, index) {
              return ChatRoomTile(
                userName: snapshot.data.documents[index].data["chatroomId"]
                    .toString()
                    .replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoom: snapshot.data.documents[index].data["chatroomId"],
              );
            });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameInSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              await authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoom;

  const ChatRoomTile({Key key, this.userName, this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId: chatRoom,)
          )
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(width: 8),
            Text(
              userName,
              style: mediumTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
