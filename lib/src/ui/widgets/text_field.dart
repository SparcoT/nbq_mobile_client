import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String value;
  final FormFieldSetter onSaved;
  final FormFieldValidator<String> validator;

  AppTextField({this.label, this.onSaved, this.validator,this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      initialValue: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label
      ),
    );
  }
}
