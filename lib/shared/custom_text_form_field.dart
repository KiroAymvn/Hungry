import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({super.key, required this.hint, required this.isPassword, required this.controller});

  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  void togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value==null || value.isEmpty){
          return " please fill ${widget.hint}";
        }
        return null;
      },
      obscureText: _obscureText,
      cursorColor: AppColors.primary,
      cursorHeight: 20,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword ? GestureDetector(onTap: togglePassword, child: Icon(CupertinoIcons.eye)) : null,
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
