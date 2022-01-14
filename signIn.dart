import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/helper/helperFunctions.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/database.dart';
import 'package:flutter_chat/signUp.dart';
import 'package:flutter_chat/ChatScreens.dart';


void signIn() => runApp(SignIn());

class SignIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pain",
      home: lol(),
    );
  }
}

class lol extends StatefulWidget {

  _lolState createState() => _lolState();
}

class _lolState extends State<lol>{

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailControl = new TextEditingController();
  TextEditingController passControl = new TextEditingController();

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  QuerySnapshot snapShotUserId;

  // All self doine stuff
  runSignIn(){

    if (formKey.currentState.validate()){
      setState((){
        isLoading = true;
      });
    }

    authMethods.signInAuth(emailControl.text, passControl.text).then((val){

      if (val != null && val != false) {

        databaseMethods.getUserByEmail(emailControl.text).then((val){
          snapShotUserId = val;
          HelperFunctions.saveUserEmail(snapShotUserId.docs[0].data()["email"]);
          HelperFunctions.saveUserName(snapShotUserId.docs[0].data()["name"]);
          Constants.myName = snapShotUserId.docs[0].data()["name"];
          // Constants.myEmail = snapShotUserId.docs[0].data()["email"];
        });

        HelperFunctions.saveUserLogIn(true);
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatScreens()
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SignIn()
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign In",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Sign In"),
          ),
          body: isLoading ? Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          ) : SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 150,
              padding: EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val){
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                            ).hasMatch(val) ? null : "Enter valid email";
                          },
                          controller: emailControl,
                          decoration: InputDecoration(
                              hintText: "Email"
                          ),
                        ),
                        TextFormField(
                          validator: (val){
                            return val.length < 6 ? "Enter a valid password": null;
                          },
                          obscureText: true,
                          controller: passControl,
                          decoration: InputDecoration(
                              hintText: "Password"
                          ),
                        ),
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: (){
                            HelperFunctions.getUserLogIn().then((val){
                              print(val);
                            });
                            runSignIn();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text("Sign In", style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don\'t have an account? "),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => SignUp()
                                  ));
                                  print("test");
                                },
                                child: Text("Register now!", style: TextStyle(
                                    decoration: TextDecoration.underline
                                ),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}