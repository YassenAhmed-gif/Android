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
import 'package:ai_chat/models/chat_model.dart';
import 'package:ai_chat/models/massage_model.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentChatId = 0;
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

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
    apiKey: "567196992874611",
    apiSecret: "h0HhimkEyjQ-PrwZKigQp_IZ4yA",
    cloudName: "dv627njp9",
  );

  void pickImage()async{
    image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      emit(PickedImageSuccessfully());
    }
    else{
      emit(PickedImageWithError(error: "error in picking image!"));
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

   String? UploadImage(){

     final response = cloudinary.upload(
         file: finalImage!.path,
             fileBytes: File(finalImage!.path).readAsBytesSync(),
             resourceType: CloudinaryResourceType.image,
             folder: folder,
             fileName: finalImage!.toString(),
             progressCallback: (count, total) {
               print(
                   'Uploading image from file with progress: $count/$total');
             }).then((value) {
               emit(UploadSuccess());
               return value.url;
             });
   }

  void sendUserMessage({required String message}) {
    if(finalImage == null){
      MessageModel messageModel = MessageModel(
        content: message,
        time: Timestamp.now(),
        isbot: false,
        media: null,
      );
      _database
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("Chats")
          .doc(currentChatId.toString())
          .collection("messages")
          .add(messageModel.toMap())
          .then((value) {
        emit(sendMessagesuccess());

        getGeminiResponse(prom: message).then((value) {
          messageModel = MessageModel(
              content: value!,
              time: Timestamp.now(),
              isbot: true,
              media: null);
          _database
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .collection("Chats")
              .doc(currentChatId.toString())
              .collection("messages")
              .add(messageModel.toMap())
              .then((v) {
            emit(sendMessagesuccess());
          }).catchError((error) {
            emit(sendMessageError(error: error.toString()));
          });
        }).catchError((error) {
          emit(sendMessageError(error: error.toString()));
        });
      }).catchError((error) {
        emit(sendMessageError(error: error.toString()));
      });
    }
    else {
      MessageModel messageModel = MessageModel(
        content: message,
        isbot: false,
        time: Timestamp.now(),
        media: UploadImage()
      );
    }
  }

  List<ChatModel> chats = [];
  void getAllChats(){
    if(_auth.currentUser != null) {
      String myId = _auth.currentUser!.uid;
      emit(getAllChatsLoading());
      _database
          .collection("Users")
          .doc(myId)
          .collection("Chats")
          .orderBy("time")
          .snapshots()
          .listen((event) {
        chats = [];
        for (var element in event.docs) {
          print(element.data());
          chats.add(ChatModel.fromJson(element.data()));
        }
        emit(getAllChatsSuccess());
      });
    }
  }

  void getCurrentChatId() {
    if (_auth.currentUser != null) {
      _database
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .collection("Chats")
          .snapshots()
          .listen((event) {
        if (currentChatId != 0) {
          if (event.docs.isNotEmpty) {
            currentChatId = event.docs.length;
          } else {
            currentChatId++;
          }
        }
        emit(getChatIdSuccess());
      }).onError((error) {
        emit(getChatIdError(error: error.toString()));
      });
    }
  }

  void newChat({required String FQ}){

    String myId = _auth.currentUser!.uid;
    if(_auth.currentUser != null){
      ChatModel chatModel = ChatModel(
          Fquestion: FQ,
          time: Timestamp.now(),
          chat_id: chats.length
      );

      _database
          .collection("Users")
          .doc(myId)
          .collection("Chats")
          .add(chatModel.toMap())
          .then((value) => emit(newChatSuccess()))
          .catchError((error){
        emit(newChatError(error: error.toString()));
      });
    }
  }

  Future<String?> getGeminiResponse({required String prom}) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "AIzaSyA8rNH_x3qdsRqgrQnz3t10zYMUyxG4SW0",
    );

    final content = [Content.text(prom)];
    final response = await model.generateContent(content);

    return response.text;
  }

  List<MessageModel> allMessages = [];
  void getAllMessage() {
    String myId = _auth.currentUser!.uid;
    emit(getAllMessagesLoading());
    _database
        .collection("Users")
        .doc(myId)
        .collection("Chats")
        .doc(currentChatId.toString())
        .collection("messages")
        .orderBy("time")
        .snapshots()
        .listen((event) {
      allMessages = [];
      for (var element in event.docs) {
        print(element.data());
        allMessages.add(MessageModel.fromJson(element.data()));
      }
      emit(getAllMessagesSuccess());
    });
  }

  // int currentChatId = 0;
  // final _database = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;
  //
  // List<ChatModel> chats = [];
  // void getAllChats(){
  //   String myId = _auth.currentUser!.uid;
  //   emit(getAllChatsLoading());
  //   _database
  //     .collection("Users")
  //     .doc(myId)
  //     .collection("Chats")
  //     .orderBy("time")
  //     .snapshots()
  //     .listen((event) {
  //       chats = [];
  //       for(var element in event.docs){
  //         print(element.data());
  //         chats.add(ChatModel.fromJson(element.data()));
  //       }
  //       emit(getAllChatsSuccess());
  //     });
  // }
  //
  // void getCurrentChatId(){
  //   if(_auth.currentUser != null){
  //     _database
  //       .collection("Users")
  //         .doc(_auth.currentUser!.uid)
  //         .collection("Chats")
  //         .snapshots()
  //         .listen((event) {
  //           if(currentChatId != 0){
  //             if(event.docs.isNotEmpty){
  //               currentChatId = event.docs.length;
  //             } else {
  //               currentChatId++;
  //             }
  //           }
  //           emit(getChatIdSuccess());
  //         }).onError((error) {
  //           emit(getChatIdError(error: error.toString()));
  //         });
  //   }
  // }
  //
  // void newChat({required String FQ}){
  //   String myId = _auth.currentUser!.uid;
  //   ChatModel chatModel = ChatModel(
  //       Fquestion: FQ,
  //       time: Timestamp.now(),
  //       chat_id: chats.length
  //   );
  //
  //   _database
  //       .collection("Users")
  //       .doc(myId)
  //       .collection("Chats")
  //       .add(chatModel.toMap())
  //       .then((value) => emit(newChatSuccess()))
  //       .catchError((error){
  //         emit(newChatError(error: error.toString()));
  //       });
  // }
  //
  // List<MessageModel> allMessages = [];
  // void getAllMassages(){
  //   String myId = _auth.currentUser!.uid;
  //   emit(getAllMessagesLoading());
  //   _database
  //     .collection("Users")
  //     .doc(myId)
  //     .collection("Chats")
  //     .doc(currentChatId.toString())
  //     .collection("messages")
  //     .orderBy("time")
  //     .snapshots()
  //     .listen((event) {
  //       if (event.docs.isNotEmpty){
  //         allMessages = [];
  //         for (var element in event.docs) {
  //           // Debugging: Print the raw data from each document
  //           print("Document data: ${element.data()}");
  //
  //           // Try parsing each document to MessageModel
  //           try {
  //             allMessages.add(MessageModel.fromJson(element.data()));
  //           } catch (e) {
  //             print("Error parsing message data: $e");
  //           }
  //         }
  //         emit(getAllMessagesSuccess());
  //       } else{
  //         print("No messages found for currentChatId: $currentChatId");
  //         emit(getAllChatsSuccess());
  //       }
  //     }).onError((error){
  //      print("Error getting messages: $error");
  //      emit(getAllChatsError(error: error.toString()));
  //   });
  // }
  //
  // void sendMessage({required String message}) {
  //   MessageModel messageModel = MessageModel(
  //     content: message,
  //     time: Timestamp.now(),
  //     isbot: false,
  //     media: null,
  //   );
  //   _database
  //       .collection("Users")
  //       .doc(_auth.currentUser!.uid)
  //       .collection("Chats")
  //       .doc(currentChatId.toString())
  //       .collection("messages")
  //       .add(messageModel.toMap())
  //       .then((value) {
  //     emit(sendMessagesuccess());
  //
  //     getGeminiResponse(prom: message).then((value) {
  //       messageModel = MessageModel(
  //           content: value!,
  //           time: Timestamp.now(),
  //           isbot: true,
  //           media: null);
  //       _database
  //           .collection("Users")
  //           .doc(_auth.currentUser!.uid)
  //           .collection("Chats")
  //           .doc(currentChatId.toString())
  //           .collection("messages")
  //           .add(messageModel.toMap())
  //           .then((v) {
  //         emit(sendMessagesuccess());
  //       }).catchError((error) {
  //         emit(sendMessageError(error: error.toString()));
  //       });
  //     }).catchError((error) {
  //       emit(sendMessageError(error: error.toString()));
  //     });
  //   }).catchError((error) {
  //     emit(sendMessageError(error: error.toString()));
  //   });
  // }
  //
  // Future<String?> getGeminiResponse({required String prom}) async {
  //   print("hallo from gemini");
  //   print(prom);
  //   final model = GenerativeModel(
  //       model: "gemini-1.5-flash-latest",
  //       apiKey: "AIzaSyA8rNH_x3qdsRqgrQnz3t10zYMUyxG4SW0"
  //   );
  //   print("after model");
  //   final content = [Content.text(prom)];
  //   final response = await model.generateContent(content);
  //   print(response.text);
  //   return response.text;
  // }

  // final ImagePicker picker = ImagePicker();
  // XFile? image;
  // CroppedFile? finalImage;
  //
  // static const String apiKey =
  // String.fromEnvironment('CLOUDINARY_API_KEY', defaultValue: '567196992874611');
  // static const String apiSecret =
  // String.fromEnvironment('CLOUDINARY_API_SECRET', defaultValue: 'h0HhimkEyjQ-PrwZKigQp_IZ4yA');
  // static const String cloudName =
  // String.fromEnvironment('CLOUDINARY_CLOUD_NAME', defaultValue: 'dv627njp9');
  // static const String folder =
  // String.fromEnvironment('CLOUDINARY_FOLDER', defaultValue: 'media');
  // static const String uploadPreset =
  // String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET', defaultValue: '');
  //
  // final cloudinary = Cloudinary.signedConfig(
  //   apiKey: apiKey,
  //   apiSecret: apiSecret,
  //   cloudName: cloudName,
  // );
  //
  // void pickImage()async{
  //   image = await picker.pickImage(source: ImageSource.gallery);
  //   if(image != null){
  //     emit(PickedImageSuccessfully());
  //   }
  //   else{
  //     emit(PickedImageWithError());
  //   }
  // }
  // void cropImage()async{
  //   finalImage = await ImageCropper().cropImage(
  //     sourcePath: image!.path,
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Colors.deepOrange,
  //         toolbarWidgetColor: Colors.white,
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.square,
  //         ],
  //       ),
  //       IOSUiSettings(
  //         title: 'Cropper',
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.square,
  //         ],
  //       ),
  //     ],
  //   );
  //   emit(CroppedSuccesfully());
  // }
  //
  // void UploadImage() async {
  //   final response = await
  //   cloudinary.upload
  //     (
  //       file: finalImage!.path,
  //       fileBytes: File(finalImage!.path).readAsBytesSync(),
  //       resourceType: CloudinaryResourceType.image,
  //       folder: folder,
  //       fileName: finalImage!.toString(),
  //       progressCallback: (count, total) {
  //         print(
  //             'Uploading image from file with progress: $count/$total');
  //       });
  //   if(response.isSuccessful) {
  //     print('Get your image from with ${response.secureUrl}');
  //   }
  // }
}


// // Cloudnary
// String cloud_name = "dawyubdmb";
// String APIK="185993718447947";
// String SECRETK="gvZLxHA9p1XBNIA7xE8YBre5nSc";
// String CLOUDINARY_URL="cloudinary://185993718447947:gvZLxHA9p1XBNIA7xE8YBre5nSc@dawyubdmb";
//
// // Gimiani
// String Gemini_K = "AIzaSyDl5Vy0zpvDpI4WwHcl3wMYKc7L9QDtGdY";