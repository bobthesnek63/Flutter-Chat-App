import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/ChatScreens.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/helper/helperFunctions.dart';
import 'package:flutter_chat/signIn.dart';
import 'package:flutter_chat/signUp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: Firebase.initializeApp(),
  //
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: SignUp(),
  //   );
  // }



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState(){
    getLogInState();
    super.initState();
  }

  getLogInState() async{
    await HelperFunctions.getUserLogIn().then((val){
      print(val);
      setState(() {
        isLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print(isLoggedIn);
          if (isLoggedIn != null){
            if (isLoggedIn) {
              return chats();
            } else {
              return SignIn();
            }
          } else {
            return SignIn();
          }
        } else {
          return Container(
            color: Colors.white,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
      },
    );
  }
}


