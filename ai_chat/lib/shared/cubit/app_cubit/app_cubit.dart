import 'dart:core';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ai_chat/models/user_model.dart';
import 'package:ai_chat/models/chat_model.dart';
import 'package:ai_chat/models/massage_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);
  final _database = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;
  CroppedFile? finalImage;

  static const String apiKey =
  String.fromEnvironment('CLOUDINARY_API_KEY', defaultValue: '567196992874611');
  static const String apiSecret =
  String.fromEnvironment('CLOUDINARY_API_SECRET', defaultValue: 'h0HhimkEyjQ-PrwZKigQp_IZ4yA');
  static const String cloudName =
  String.fromEnvironment('CLOUDINARY_CLOUD_NAME', defaultValue: 'dv627njp9');
  static const String folder =
  String.fromEnvironment('CLOUDINARY_FOLDER', defaultValue: 'media');
  static const String uploadPreset =
  String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET', defaultValue: '');

  final cloudinary = Cloudinary.signedConfig(
    apiKey: apiKey,
    apiSecret: apiSecret,
    cloudName: cloudName,
  );

  void pickImage()async{
    image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      emit(PickedImageSuccessfully());
    }
    else{
      emit(PickedImageWithError());
    }
  }
  void cropImage()async{
    finalImage = await ImageCropper().cropImage(
      sourcePath: image!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ],
        ),
      ],
    );
    emit(CroppedSuccesfully());
  }

  void UploadImage() async {
    final response = await
    cloudinary.upload
      (
        file: finalImage!.path,
        fileBytes: File(finalImage!.path).readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: finalImage!.toString(),
        progressCallback: (count, total) {
          print(
              'Uploading image from file with progress: $count/$total');
        });
    if(response.isSuccessful) {
      print('Get your image from with ${response.secureUrl}');
    }
  }

  List<ChatModel> allChats = [];
  void getAllChats(){
    emit(getChatsLoading());
    _database.collection("Users")
        .snapshots().listen((event) {
          allChats = [];
          for(var element in event.docs){
            print(element.data());
            if(element.id != _auth.currentUser!.uid){
              ChatModel chat = ChatModel.fromJson(element.data());
              allChats.add(chat);
            }
          }
          emit(getChatssuccess());
        }).onError((erro){
          emit(getChatsWithError());
          print("here");
          print(erro);
    });
  }
  // late int chat_id;
  //   late String Fquestion;
  //   late Timestamp time;
  void newChat({
    required int chatId,
    required String Fquestion,
    required Timestamp time
  }){

  }

  List<MessageModel> allMessages = [];
  void getAllMassages(String chatId){
    String myId = _auth.currentUser!.uid;
    emit(getMassagesLoading());
    _database
        .collection("Users")
        .doc(myId)
        .collection("Chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("time").snapshots()
        .listen((event) {
          allMessages = [];
          for(var element in event.docs){
            print(element.data());
            allMessages.add(MessageModel.fromJson(element.data()));
          }
          emit(getMassagesSuccess());
        }).onError((erro){
      emit(getMassagesWithError());
      print("here");
      print(erro);
    });
  }

  void sendMassage({
    required int messageId,
    required String chatId,
    required String content,
    required bool isBotSender,
    String? nullableMedia,
}){
    String myId = _auth.currentUser!.uid;
    String current_chat =
    MessageModel message = MessageModel(
      content: content,
      isbot: isBotSender,
      massage_id: messageId,
      nullable_media: nullableMedia!,
      time: Timestamp.now()
    );
    _database
      .collection("Users")
      .doc(myId)
      .collection("Chats")
      .doc()
  }
}


// // Cloudnary
// String cloud_name = "dawyubdmb";
// String APIK="185993718447947";
// String SECRETK="gvZLxHA9p1XBNIA7xE8YBre5nSc";
// String CLOUDINARY_URL="cloudinary://185993718447947:gvZLxHA9p1XBNIA7xE8YBre5nSc@dawyubdmb";
//
// // Gimiani
// String Gimiani_K = "AIzaSyDl5Vy0zpvDpI4WwHcl3wMYKc7L9QDtGdY";