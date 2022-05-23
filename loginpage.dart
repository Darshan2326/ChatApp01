import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:chat_app_01/models/UserModel.dart';
import 'package:chat_app_01/pages/MyHomePage.dart';
import 'package:chat_app_01/pages/signuppage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app_01/models/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginemailcont = new TextEditingController();
  TextEditingController loginpasscont = new TextEditingController();

  void Chackvalue() {
    String email = loginemailcont.text.trim();
    String password = loginpasscont.text.trim();

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
    } else {
      loginsuccess(email, password);
    }
  }

  void loginsuccess(String email, String password) async {
    UserCredential? credantail;

    try {
      credantail = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (rx) {
      // print(rx.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(rx.message.toString())));
      // AlertDialog(
      //   title:  Text('Somethimgd Wromg'),
      //   content: SingleChildScrollView(
      //     child: ListBody(
      //       children: <Widget>[
      //         Text(rx.toString()),
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
    if (credantail != null) {
      String uid = credantail.user!.uid;

      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      UserModel userModel =
          UserModel.fromeMap(userData.data() as Map<String, dynamic>);

      //homepage par java nu che
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userModel: userModel,
                    firebaseUser: credantail!.user!,
                  )));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Log In sucess")));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/login2.jpg"), fit: BoxFit.fill)),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      WavyAnimatedText("Log In",
                          textStyle: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white))
                    ],
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
                      controller: loginemailcont,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          prefixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.email,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          // icon: new Icon(Icons.email,color: Colors.blue,),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 15,
                          ),
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
                      controller: loginpasscont,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          prefixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.lock,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 15),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.black38,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CupertinoButton(
                      child: Text(
                        "LogIn",
                      ),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Chackvalue();
                      }),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Hello",
                              style: GoogleFonts.aladin(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink)),
                          Text("Again!",
                              style: GoogleFonts.aladin(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink)),

                          // TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.pink),)
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bottem.jpg"), fit: BoxFit.fill)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have a account? ",
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
                child: Text(
                  "Sign In",
                ),
                // color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                })
          ],
        ),
      ),
    );
  }
}
