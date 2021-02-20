import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter onSaved;
  final FormFieldValidator<String> validator;

  AppTextField({this.label, this.onSaved, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        labelText: label
      ),
    );
  }
}
