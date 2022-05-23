import 'dart:developer';
import 'dart:io';
import 'package:chat_app_01/models/UserModel.dart';
import 'package:chat_app_01/pages/MyHomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ComplateProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ComplateProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<ComplateProfile> createState() => _ComplateProfileState();
}

class _ComplateProfileState extends State<ComplateProfile> {
  File? imagefile;
  TextEditingController fullnamecon = TextEditingController();

  void SelectPhoto(ImageSource Sourece) async {
    XFile? pickedfile = await ImagePicker().pickImage(source: Sourece);

    if (pickedfile != null) {
      CropPhoto(pickedfile);
    }
  }

  void CropPhoto(XFile file) async {
    File? cropedimage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 10);
    // File? cropedimage = await ImageCropper().cropImage(sourcePath: file.path);
    if (cropedimage != null) {
      setState(() {
        imagefile = cropedimage;
      });
    }
  }

  void Selectprofilephoto() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picther"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    SelectPhoto(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select Photo from Galary"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    SelectPhoto(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera),
                  title: Text("Tack a Photo"),
                )
              ],
            ),
          );
        });
  }

  void Chackvalues() {
    String fullname = fullnamecon.text.trim();

    if (fullname == "" || imagefile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
    } else {
      log("Uploading photo..");
      uploaddata();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser)));
      log("navigation success change activity");
    }
  }

  void uploaddata() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("ProfilePictures")
        .child(widget.userModel.uid.toString())
        .putFile(imagefile!);

    TaskSnapshot snapshot = await uploadTask;
    String imageurl = await snapshot.ref.getDownloadURL();
    String fullname = fullnamecon.text.trim();
    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageurl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      // print("Data Uploaded");
      // log("data Uploaded");

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("sucess")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Profile"),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/2.jpg"), fit: BoxFit.fill)),
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              CupertinoButton(
                onPressed: () {
                  Selectprofilephoto();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      (imagefile != null) ? FileImage(imagefile!) : null,
                  child: (imagefile == null)
                      ? Icon(
                          Icons.person_outlined,
                          size: 60,
                        )
                      : null,
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
                  controller: fullnamecon,
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 5, left: 10),
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.black38,
                      )),
                ),
              ),
              // TextField(
              //   keyboardType: TextInputType.name,
              //   style: TextStyle(color: Colors.black87),
              //   decoration: InputDecoration(
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.only(top: 5, left: 10),
              //       hintText: 'Full Name',
              //       hintStyle: TextStyle(
              //         color: Colors.black38,
              //       )),
              // ),
              SizedBox(
                height: 20,
              ),
              CupertinoButton(
                  child: Text(
                    "Submite",
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Chackvalues();
                  })
            ],
          ),
        ),
      ),
    );
  }
}
