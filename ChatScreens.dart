import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/conversations.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/helper/helperFunctions.dart';
import 'package:flutter_chat/search.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/database.dart';
import 'package:flutter_chat/signIn.dart';

class chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreens(),
    );
  }
}


class ChatScreens extends StatefulWidget{
  _ChatScreens createState() => _ChatScreens();
}

class _ChatScreens extends State<ChatScreens>{

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserName();
      setState(() {
        chatRoomStream = databaseMethods.getChats();
      });
  }

  // getChats() async {
  //
  // }

  Widget ChatsList(){
    return chatRoomStream != null ? StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return ChatTile(
                snapshot.data.docs[index].data()["ChatRoomId"]
            );
          }) : Container();
      },
    ) : Container(
        child: CircularProgressIndicator(),
      alignment: Alignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              HelperFunctions.saveUserLogIn(false);
              HelperFunctions.saveUserName(null);
              HelperFunctions.saveUserEmail(null);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => SignIn()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: ChatsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => Search()
          ));
        },
      )

    );
  }
}

class ChatTile extends StatelessWidget {

  final String chatRoomId;
  ChatTile(this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationsScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 16),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 35),
                child: Icon(Icons.person),
                decoration: BoxDecoration(
                    color: Colors.grey,
                borderRadius: BorderRadius.all(
                    Radius.circular(100)
                )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatRoomId, style: TextStyle(
                  color: Colors.black,
                  fontSize: 17
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}



