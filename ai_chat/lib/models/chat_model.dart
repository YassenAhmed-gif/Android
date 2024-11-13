import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel{
  late int chat_id;
  late String Fquestion;
  late Timestamp time;


  ChatModel({
    required this.chat_id,
    required this.Fquestion,
    required  this.time
  });

  ChatModel.fromJson(Map<String,dynamic> json){
    chat_id = json["chat_id"];
    Fquestion = json["first_Question"];
    time = json["time"];
  }

  Map<String,dynamic> toMap()=>{
    "chat_id":chat_id,
    "first_Question":Fquestion,
    "time":time,
  };
}