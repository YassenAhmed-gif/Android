import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late String content;
  late bool isbot;
  late Timestamp time;
  late String? media;

  MessageModel({
    required this.content,
    required this.time,
    required this.isbot,
    required this.media
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    content = json["Content"];
    isbot = json["isBotSender"];
    time = json["time"];
    media = json["nullable_media"];
  }

  Map<String,dynamic> toMap()=>{
    "isBotSender":isbot,
    "Content":content,
    "time":time,
    "nullable_media":media
  };
}