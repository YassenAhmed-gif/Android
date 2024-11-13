import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat/screens/Register_screen.dart';
import 'package:ai_chat/shared/cubit/auth_cubit/auth_cubit.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../shared/Widget/my_text_form_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 250,
                      child: Text(
                        "Sign In",
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
                      validator: (p0) {},

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
                      validator: (p0) {},
                      isPassword: true,
                      hintTxt: "Password",
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                      },
                      builder: (context, state) {
                        var cubit = AuthCubit.get(context);
                        if(state is LoginLoading){
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child:  LoadingIndicator(
                                indicatorType: Indicator.ballRotateChase,
                                colors: [Colors.black],
                                /// Required, The loading type of the widget
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              cubit.login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Dont Have account ?',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text(
                            'Sign Up',
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
            ),
          ),
        ),
      ),
    );
  }
}