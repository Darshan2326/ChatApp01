import 'dart:developer';

import 'package:chat_app_01/main.dart';
import 'package:chat_app_01/models/ChatRoomModel.dart';
import 'package:chat_app_01/models/UserModel.dart';
import 'package:chat_app_01/pages/chatroompage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class searchpage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  searchpage({Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  TextEditingController searchcon = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatroom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        "chatrooms").where(
        "participants.${widget.userModel.uid}", isEqualTo: true).where(
        "participants.${targetUser.uid}", isEqualTo: true).get();
    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String,dynamic>);
      chatroom = existingChatroom;
      log(chatroom.chatroomid!);
    } else {
      ChatRoomModel newchatroom = ChatRoomModel(
          chatroomid: uuid.v1(),
          Lastmessage : "",
          participants: {
          widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true,
          }
      );
      await FirebaseFirestore.instance.collection("chatrooms").doc(newchatroom.chatroomid).set(newchatroom.toMap());
      chatroom = newchatroom;
    }
    return chatroom;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Find"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchcon,
                  decoration: InputDecoration(
                      labelText: "Email Address"
                  ),
                ),
                SizedBox(height: 20,),

                CupertinoButton(
                  onPressed: () {
                    setState(() {});
                  },
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  child: Text("Search"),
                ),
                SizedBox(height: 30,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("email", isEqualTo: searchcon.text).where(
                      "email", isNotEqualTo: widget.userModel.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot = snapshot
                            .data as QuerySnapshot;
                        if (datasnapshot.docs.length > 0) {
                          Map<String, dynamic> userMap = datasnapshot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searcheduser = UserModel.fromeMap(userMap);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  searcheduser.profilepic!),
                            ),
                            title: Text(searcheduser.fullname!),
                            subtitle: Text(searcheduser.email!),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              ChatRoomModel? chatroommodel = await getChatroomModel(
                                  searcheduser);

                              if(ChatRoomModel != null){
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        chatroom(
                                          targetUser: searcheduser,
                                          userModel: widget.userModel,
                                          firebaseUser: widget.firebaseUser,
                                          chatRoomModel:ChatRoomModel(),
                                        )));

                              }


                            },
                          );
                        } else {
                          return Text("Not Found!");
                        }
                      } else if (snapshot.hasError) {
                        return Text("error found!");
                      } else {
                        return Text("Not Found!");
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
