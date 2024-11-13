import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final String hintTxt;
  final Icon prefixIcon;
  final TextEditingController controller;
  final String?Function(String?) validator;
  final bool isPassword;
  const MyTextFormField({super.key,
    required this.hintTxt,
    required this.controller,
    this.isPassword = false,
    required this.prefixIcon,
    required this.validator
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool secureText = false;

  @override
  void initState() {
    super.initState();
    secureText = widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      obscureText: secureText,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.hintTxt,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,

            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,

            ),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword ? IconButton(
            onPressed: (){
              setState(() {
                secureText = !secureText;
              });
            },
            icon: Icon(
              secureText ?
              Icons.visibility_off_outlined:
              Icons.visibility_outlined,
            ),
          ):null
      ),
    )
    ;
  }
}