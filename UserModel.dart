class UserModel{
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? password;
  int? phonenumber;

  UserModel({this.uid,this.fullname,this.email,this.profilepic,this.password,this.phonenumber});

  UserModel.fromeMap(Map<String,dynamic>map){
    uid =map["uid"];
    fullname =map['fullname'];
    email = map['email'];
    profilepic = map ['profilepic'];
    password = map['password'];
    phonenumber=map['phonemuber'];
  }
  Map<String,dynamic> toMap(){
    return{
      "uid": uid,
      "fullname":fullname,
      'email':email,
      'profilepic':profilepic,
      'password' : password,
      'phonenumber' :phonenumber
    };
  }
}