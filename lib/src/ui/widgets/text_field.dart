import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String value;
  final int maxLines;
  final FormFieldSetter onSaved;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  AppTextField({this.label, this.onSaved, this.validator,this.value,this.maxLines,this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onSaved: onSaved,
      initialValue: value,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        labelText: label
      ),
    );
  }
}
