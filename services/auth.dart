import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/model/GeneralUser.dart';

class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GeneralUser _userFromFirebase(User fireBaseUser){
    return fireBaseUser != null ? GeneralUser(userId: fireBaseUser.uid) : null;
  }

  Future signInAuth(String email, String password) async{

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      User fireBaseUser = result.user;
      return _userFromFirebase(fireBaseUser);

    } catch(e){
      print(e.toString());
      return false;
    }
  }

  Future signUpAuth(String email, String password) async{

    try {

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      User fireBaseUser = result.user;
      return _userFromFirebase(fireBaseUser);

    } catch(e){
      print(email);
      print(password);
      print(e.toString());
    }

  }

  Future resetPassword(String email) async{

    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e){
      print(e.toString());
    }

  }

  Future signOut() async {

    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
    }

  }

}