import 'package:flutter/material.dart';
import 'package:jaleelchat/helper/constants.dart';
import 'package:jaleelchat/services/database.dart';
import 'package:jaleelchat/widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  const ConversationScreen({Key key, this.chatRoomId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream chatMessageStream;

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                isSendByMe: snapshot.data.documents[index].data["sendBy"] ==
                    Constants.myName,
              );
            });
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };

      print('hey $messageMap   and ${widget.chatRoomId}');
      databaseMethods.addConversationMessages(
          chatRoomId: widget.chatRoomId, messageMap: messageMap);

      messageController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Color(0x54FFFFFF),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            hintText: "Message",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
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
                            child: Image.asset("assets/images/send.png")),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  const MessageTile({Key key, this.message, this.isSendByMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
