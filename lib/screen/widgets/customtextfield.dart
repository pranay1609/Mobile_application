import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController customcomtroller;
  late final String placeholder;
  int maxliness;
  CustomTextField(this.customcomtroller, this.placeholder,
      {this.maxliness = 1});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: widget.placeholder == 'Enter password' ? true : false,
        maxLines: widget.maxliness,
        validator: (val) {
          if (val!.isEmpty) {
            return widget.placeholder + ' Required';
          } else if (widget.placeholder == "Description" && val.length < 300) {
            return " Description filed should not less than 300 character ";
          } else {
            return null;
          }
        },
        controller: widget.customcomtroller,
        textAlign: TextAlign.start,
        keyboardType: widget.maxliness == 5
            ? TextInputType.multiline
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.placeholder,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              width: 1,
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}
