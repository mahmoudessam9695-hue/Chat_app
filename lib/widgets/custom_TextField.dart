import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormTextfield extends StatelessWidget {
  CustomFormTextfield({this.onChanged, this.hintText, required this.isShow});

  Function(String)? onChanged;
  final String? hintText;
  bool isShow;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        // ignore: body_might_complete_normally_nullable
        validator: (data) {
          if (data!.isEmpty) {
            return 'field is required';
          }
        },
        obscureText: isShow,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(255, 230, 223, 223)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(6),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
