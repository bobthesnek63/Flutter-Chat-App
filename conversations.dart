import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ChatScreens.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/services/database.dart';

class ConversationsScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationsScreen(this.chatRoomId);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState(chatRoomId);
}

class _ConversationsScreenState extends State<ConversationsScreen> {

  final String chatRoomName;
  _ConversationsScreenState(this.chatRoomName);

  TextEditingController messageControl = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatMessageStream;

  Widget messageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, snapshot){
        if(snapshot.data == null){
          return CircularProgressIndicator();
        } else {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
              return MessageTile(snapshot.data.docs[index].data()["message"],
                  snapshot.data.docs[index].data()["sender"] == Constants.myName);
            },
          );
        }
      },
    );
  }

  sendMessage(){
    if (!messageControl.text.isEmpty) {
      Map<String, dynamic> messageMap = {
        "message" : messageControl.text,
        "sender" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversations(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    chatMessageStream = databaseMethods.getConversations(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // GestureDetector(
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(
          //       builder: (context) => ChatScreens()
          //     ));
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //     child: Icon(Icons.arrow_back),
          //   ),
          // )
        ],
        title: Text(chatRoomName),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 75,
          child: Stack(
            children: [
              messageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: messageControl,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.white
                                ),
                                border: InputBorder.none,
                                hintText: "Enter Name"
                            ),
                          )
                      ),
                      GestureDetector(
                          onTap: (){
                            sendMessage();
                            messageControl.text = "";
                          },
                          child: Icon(Icons.send)
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String messageString;
  final bool isSentByMe;
  MessageTile(this.messageString, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isSentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            bottomLeft: Radius.circular(23),
            topRight: Radius.circular(23),
          ) : BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          ),
          color: isSentByMe ? Colors.blue : Colors.grey
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(messageString,
          style: TextStyle(
          color: Colors.white,
            fontSize: 17
        ),
        ),
      ),
    );
  }
}

