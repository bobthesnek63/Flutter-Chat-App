import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/helper/constants.dart';

class DatabaseMethods {

  getUsers(String name) async {
    return await FirebaseFirestore.instance.collection("users").
    where("name", isEqualTo: name).get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users").
    where("email", isEqualTo: email).get();
  }

  uploadUserInfo(String name, String email){

    Map<String, String> userInfo = infoToMap(name, email);

    FirebaseFirestore.instance.collection("users").add(userInfo).
    catchError((e){
      print(e.toString());
    });
  }

  // Converts user data into map format
  infoToMap(String name, String email){

    Map<String, String> userInfoMap = {
      "name" : name,
      "email" : email
    };

    return userInfoMap;
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).
    set(chatRoomMap).catchError((e){
      print(e);
    });
  }

  addConversations(String ChatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(ChatRoomId).collection("chats").add(messageMap)
        .catchError((e){
          print(e.toString());
    });
  }

  getConversations(String ChatRoomId){
    return FirebaseFirestore.instance.collection("ChatRoom")
        .doc(ChatRoomId).collection("chats").orderBy("time", descending: false).snapshots();

  }

  getChats()  {
    return FirebaseFirestore.instance.collection("ChatRoom")
        .where("users", arrayContains: Constants.myName).snapshots();
  }
}