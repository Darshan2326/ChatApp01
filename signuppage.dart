import 'dart:math';

import 'package:chat_app_01/models/UserModel.dart';
import 'package:chat_app_01/pages/complateprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import '';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcont = TextEditingController();
  TextEditingController conpasscont = TextEditingController();

  void ChackeValues() {
    String email = emailcon.text.trim();
    String password = passcont.text.trim();
    String conformpassword = conpasscont.text.trim();

    if (email == "" || password == "" || conformpassword == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the filds")));
      // AlertDialog(
      //   title:  Text("Something's wrong"),
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: <Widget>[
      //         Text("please fill all the felds..."),
      //       ],
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       child:  Text('Okay'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // );
    } else if (password != conformpassword) {
      // print("passwords don't match");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password don't match")));
      // AlertDialog(
      //   title:  Text("Something's wrong"),
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: <Widget>[
      //         Text("Password don't match"),
      //       ],
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       child:  Text('Okay'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // );
    } else {
      Signup(email, password);
    }
  }

  void Signup(String email, String password) async {
    UserCredential? creadantial;

    try {
      creadantial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(ex.message.toString())));
      // AlertDialog(
      //   title:  Text('Somethimgd Wromg'),
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: <Widget>[
      //         Text(ex.toString()),
      //       ],
      //     ),
      //   ),
      //   actions: <Widget>[
      //     TextButton(
      //       child:  Text('Okay'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // );
    }
    if (creadantial != null) {
      String uid = creadantial.user!.uid;
      UserModel newuser = UserModel(
          uid: uid,
          email: email,
          fullname: "",
          profilepic: "",
          password: password);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ComplateProfile(userModel: newuser, firebaseUser: creadantial!.user!);
            }));
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("New User Created")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(


          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/2.jpg"), fit: BoxFit.fill)
                ),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      WavyAnimatedText("Sign up",
                          textStyle: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("WELLCOME TO ChateApp"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    height: 50,
                    child: TextField(
                      controller: emailcon,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          hintText: 'E mail',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    height: 50,
                    child: TextField(
                      controller: passcont,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    height: 50,
                    child: TextField(
                      controller: conpasscont,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, left: 10),
                          hintText: 'Conform Password',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CupertinoButton(
                          child: Text(
                            "Sign Up",
                          ),
                          color: Colors.green,
                          onPressed: () {
                            ChackeValues();
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Allready have a account? ",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: Text(
                  "Log In",
                ),
                // color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
