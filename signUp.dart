import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/helper/constants.dart';
import 'package:flutter_chat/helper/helperFunctions.dart';
import 'package:flutter_chat/services/auth.dart';
import 'package:flutter_chat/services/database.dart';
import 'package:flutter_chat/signIn.dart';
import 'package:flutter_chat/ChatScreens.dart';

void signUp() => runApp(ContextProv());

class ContextProv extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }

}

class SignUp extends StatefulWidget{

  const SignUp({Key key, this.context}) : super(key: key);
  final BuildContext context;

  @override
  _SignUpState createState() => _SignUpState();

}

class _SignUpState extends State<SignUp>{

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameControl = new TextEditingController();
  TextEditingController emailControl = new TextEditingController();
  TextEditingController passwordControl = new TextEditingController();

  runSignUp(String email, String password){
    if (formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
    }

    HelperFunctions.saveUserLogIn(true);
    HelperFunctions.saveUserName(nameControl.text);
    HelperFunctions.saveUserEmail(email);

    Constants.myName = nameControl.text;

    authMethods.signUpAuth(email, password);
    databaseMethods.uploadUserInfo(nameControl.text, emailControl.text);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ChatScreens()
    ));
  }

  @override
  Widget build(context) {

    double h = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sign Up",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Sign Up"),
          ),
          body: isLoading ? Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center
          ) :
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 50,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: h/10),
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
                            return val.isEmpty || val.length < 3 ?
                            "Enter a valid name" : null;
                          },
                          controller: nameControl,
                          decoration: InputDecoration(
                              hintText: "Full Name"
                          ),
                        ),
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
                          obscureText: true,
                          validator: (val){
                            return val.isEmpty || val.length < 6 ?
                            "Password must be 6 characters or more" : null;
                          },
                          controller: passwordControl,
                          decoration: InputDecoration(
                              hintText: "Password"
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){
                      print("Signing up");
                      // print(nameControl.text);
                      runSignUp(emailControl.text, passwordControl.text);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text("Sign Up", style: TextStyle(
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
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: (){
                            signIn();
                          },
                          child: Text("Sign In!", style: TextStyle(
                            decoration: TextDecoration.underline
                          ),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}