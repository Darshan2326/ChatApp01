class ChatRoomModel{
  String? chatroomid;
  Map<String,dynamic>? participants;
  String? Lastmessage;

  ChatRoomModel({
  this.chatroomid,
  this.participants,
  this.Lastmessage,
  });
  ChatRoomModel.fromMap(Map<String,dynamic>map){
    chatroomid = map['chatroomid'];
    participants =map['participants'];
    Lastmessage = map["lastmessage"];
  }
  Map<String,dynamic> toMap(){
    return{
      "chatroomid":chatroomid,
      "participants":participants,
      "lastmessage":Lastmessage,
    };
  }

}