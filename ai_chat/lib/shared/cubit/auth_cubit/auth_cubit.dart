import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat/models/user_model.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  UserModel? user_model;
  void register({
    required String password,
    required String email,
  }) {
    emit(RegisterLoading());
    _auth.createUserWithEmailAndPassword(
        email: email,
        password: password).then((onValue) {
      _database.collection("users").doc(
          onValue.user!.uid
      ).set({
        "email": email
      }).then((onValue) {
        emit(RegisterSuccess());
      }).catchError((error) {
        emit(RegisterWithError());
      });
    });
  }

  void login({required String email,required String password}){
    emit(LoginLoading());
    _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value){
      _database
          .collection("users")
          .doc(value.user!.uid).get().
      then((element){
        user_model = UserModel.fromJson(element.data()!);
        emit(LoginSuccess());
      }).catchError((error){
        emit(LoginWithError());
      });
    }).catchError((error){
      emit(LoginWithError());
    });
  }
}

/*import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:ai_chat/shared/constants/con.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  final cloudinary = Cloudinary.signedConfig(
    apiKey: APIK,
    apiSecret: SECRETK,
    cloudName: cloud_name,
  );
  final ImagePicker picker=ImagePicker() ;
  XFile?image;
  void register({
    required String email,
    required String password
  }){
    emit(RegisterLoading());
    try{

    }catch(e){
      emit(RegisterWithError());
    }
  }
}
*/