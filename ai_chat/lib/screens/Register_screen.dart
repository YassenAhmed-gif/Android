import 'dart:io';

import 'package:ai_chat/shared/cubit/app_cubit/app_cubit.dart';
import 'package:ai_chat/shared/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../shared/cubit/auth_cubit/auth_cubit.dart';
import '../shared/Widget/my_text_form_field.dart';
import 'home_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {},
                builder: (context, state) {
                  var cubit = AuthCubit.get(context);
                  return Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 100,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          MyTextFormField(
                            controller: _emailController,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email cannot be empty";
                              }
                              final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (!emailValid) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            hintTxt: "E-mail",
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          MyTextFormField(
                            controller: _passwordController,
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                            ),
                            validator: (value) {},
                            isPassword: true,
                            hintTxt: "Password",
                          ),
                          const SizedBox(
                            height: 70.0,
                          ),
                          state is RegisterLoading ?const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child:  LoadingIndicator(
                                indicatorType: Indicator.ballRotateChase,
                                colors: [Colors.black],
                                /// Required, The loading type of the widget
                              ),
                            ),
                          ) : GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                  cubit.register(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatBotHomeScreen()
                                      ),
                                          (Route<dynamic> route) => false);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already Have account ?',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
