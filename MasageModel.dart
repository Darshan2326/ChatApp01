class MessageModel{
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;


  String? react;
  String? rplyUser;
  String? rplyMsg;

  MessageModel({this.messageid , this.sender,this.text,this.seen,this.createdon,this.react,this.rplyUser,this.rplyMsg});
  MessageModel.fromMap(Map<String ,dynamic>map){
    messageid = map["messageid"];
    sender=map['sender'];
    text=map['text'];
    seen=map['seen'];
    react=map['react'];
    rplyUser=map["replyUser"];
    rplyMsg=map["replyMsg"];
    createdon=map['createdon'].toData();
  }
  Map<String,dynamic> toMap(){
  return{
    "messageid":messageid,
    "sender":sender,
    'text':text,
    'seen':seen,
    'createdon':createdon
    ,'react':react,
    "replyUser":rplyUser,
    "replyMsg":rplyMsg
  };
  }
}