import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  late int massage_id;
  late String content;
  late Timestamp time;
  late bool isbot;
  late String nullable_media;

  MessageModel({
    required this.massage_id,
    required this.content,
    required this.time,
    required this.isbot,
    required this.nullable_media
  });

  MessageModel.fromJson(Map<String,dynamic> json){
    massage_id = json["massage_id"];
    content = json["Content"];
    isbot = json["isBotSender"];
    nullable_media = json["nullable_media"];
    time = json["time"];
  }

  Map<String,dynamic> toMap()=>{
    "massage_id":massage_id,
    "Content":content,
    "time":time,
    "isBotSender":isbot,
    "nullable_media":nullable_media
  };
}