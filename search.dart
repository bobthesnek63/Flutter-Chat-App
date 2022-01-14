import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ChatScreens.dart';
import 'package:flutter_chat/conversations.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/helper/helperFunctions.dart';
import 'package:flutter_chat/services/database.dart';

class Search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<Search> {

  QuerySnapshot searchSnapshot;
  startSearch(){
    databaseMethods.getUsers(usernameControl.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }
  
  createChatStartConvo(String username){

    if (username != Constants.myName) {
      List<String> users = [username, Constants.myName];
      String chatRoomId = generateChatRoomID(username, Constants.myName);
      Map<String, dynamic> chatRoomMap = {
        "ChatRoomId" : chatRoomId,
        "users" : users
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationsScreen(chatRoomId)
      ));
    }
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
            searchSnapshot.docs[index].data()["name"],
            searchSnapshot.docs[index].data()["email"]
        );
      },
    ) : Container();
  }

  generateChatRoomID(String a, String b){
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController usernameControl = new TextEditingController();

  Widget SearchTile (String name, String email){
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(email)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatStartConvo(name);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text("Message", style: TextStyle(
                color: Colors.white
              ),
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
      appBar: AppBar(
        title: Text("Find new users"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: usernameControl,
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
                      startSearch();
                    },
                      child: Icon(Icons.search)
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: searchList()
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatScreens()
          ));
        },
      ),
    );
  }
}

