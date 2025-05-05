import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final IconButton? suffixIcon;

  const FormInputField({Key? key, 
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.suffixIcon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon
      ),
    );
  }
}
