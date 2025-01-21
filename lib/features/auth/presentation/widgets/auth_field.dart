import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObsecureText = false});

  final String hintText;
  final TextEditingController controller;
  final bool isObsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObsecureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is empty!";
        }
        return null;
      },
    );
  }
}
