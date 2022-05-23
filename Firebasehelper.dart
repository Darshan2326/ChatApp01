import 'package:chat_app_01/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper{

 static Future<UserModel?> getusemodelbyID (String uid) async {
    UserModel? usermodel;

    DocumentSnapshot docsnap = await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if(docsnap.data()!=null){
      usermodel = UserModel.fromeMap(docsnap.data() as Map<String,dynamic>);
    }return usermodel;
  }
}