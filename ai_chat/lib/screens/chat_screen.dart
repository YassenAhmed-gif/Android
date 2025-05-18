import 'dart:io';

import 'package:ai_chat/models/chat_model.dart';
import 'package:ai_chat/models/massage_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat/models/user_model.dart';
import 'package:ai_chat/shared/cubit/app_cubit/app_cubit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speech.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllMessage();
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  CircleAvatar(
                    // backgroundImage: NetworkImage(
                    //   widget.receiverUser.imageLink,
                    // ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'NexGen bot',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      MessageModel currMessage = cubit.allMessages[index];
                      return BubbleSpecialThree(
                        text: cubit.allMessages[index].content,
                        color: !currMessage.isbot
                            ? const Color(0xFF1B97F3)
                            : const Color(0xFFE8E8EE),
                        tail: false,
                        isSender: !currMessage.isbot,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10.0,
                      );
                    },
                    itemCount: cubit.allMessages.length,
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   height: 60,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(12),
                //     child: Image.asset(
                //       cubit.finalImage!.path,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Message cannot be empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your message ....",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        IconButton(
                            onPressed: () {
                              // cubit.pickImage();
                              // cubit.cropImage();
                            },
                            icon: const Icon(Icons.attachment)
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        _controller.text !=""?
                        FloatingActionButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.sendUserMessage(
                                message: _controller.text,
                              );
                              _controller.clear();
                            }
                          },
                          backgroundColor: Colors.blue,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ) :
                            GestureDetector(
                              onLongPress: () {
                                _startListening();
                              },
                              onLongPressEnd: (details) {
                                _stopListening();
                                cubit.sendUserMessage(message: _lastWords);
                              },
                              child: Container(
                                color: Colors.blue,
                                height: 50,
                                width: 50,
                                child: const Icon(
                                    Icons.mic,
                                  color: Colors.white,
                                ),
                              )
                            )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}