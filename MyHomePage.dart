import 'dart:developer';

import 'package:chat_app_01/models/UserModel.dart';
import 'package:chat_app_01/pages/loginpage.dart';
import 'package:chat_app_01/pages/searchpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  MyHomePage({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    // final double screenHeight=MediaQuery.of(context).size.height;
    // final double screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Messages"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>searchpage(userModel: widget.userModel, firebaseUser: widget.firebaseUser)));
              },
              icon: Icon(
                Icons.search,
                size: 30,
              ))
        ],
      ),
      body: Center(
        child: FlatButton(
          color: Colors.grey  ,
          child: Text("log out"),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          },
        ),
      ),
    );
    //   Stack(
    //     children: [
    //       Scaffold(
    //         appBar: AppBar(),
    //       ),
    //       Positioned(
    //           top:0,
    //           left: 0,
    //           right: 0,
    //           height: screenHeight/3,
    //           child: Container(
    //               decoration: BoxDecoration(
    //                 gradient: LinearGradient(
    //                   begin: Alignment.topLeft,
    //                   end: Alignment.bottomRight,
    //                   colors: [
    //                     Colors.pinkAccent,
    //                     Colors.blueAccent,
    //
    //                   ]
    //                 )
    //               ),
    //
    //           )),
    //       Positioned(
    //           top:0,
    //           left: 0,
    //           right: 0,
    //           child: AppBar(
    //             leading: IconButton(
    //               icon:Icon(Icons.arrow_back_ios,),
    //               onPressed: (){
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //
    //             actions: [
    //               IconButton(
    //                 icon:Icon(Icons.search,size:40,),
    //                 onPressed: (){},
    //               )
    //             ],
    //             backgroundColor: Colors.transparent,
    //             elevation: 0.0,
    //           )),
    //       Positioned(
    //           left: 0,
    //           right: 0,
    //           top: screenHeight*0.1,
    //           height:screenWidth*5,
    //           child: Container(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(40),
    //                 color:Colors.white,
    //               ),
    //           )),
    //     ],
    // );


  }
}
