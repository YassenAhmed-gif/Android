import 'package:ai_chat/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat/models/user_model.dart';
import 'package:ai_chat/shared/cubit/app_cubit/app_cubit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class HomeScreen extends StatefulWidget {
  final UserModel User;
  final ChatModel Chat;
  const HomeScreen({super.key, required this.User, required this.Chat});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      AppCubit.get(context).getAllMassages(chatId);
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text("chat with me")
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      bool isboot = FirebaseAuth.instance.currentUser!.uid ==
                          cubit.allMessages[index].senderId;
                      return BubbleSpecialThree(
                        text: cubit.allMessages[index].content,
                        color: isboot
                            ? const Color(0xFF1B97F3)
                            : const Color(0xFFE8E8EE),
                        tail: false,
                        isSender: isboot,
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
                              hintText: "Enter yout message ....",
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () async {

                                },
                                icon: const Icon(
                                  Icons.location_on,
                                ),
                              ),
                            ),
                          ),
                        ),
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