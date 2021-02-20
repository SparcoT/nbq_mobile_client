import 'package:flutter/material.dart';

class ShadowedBox extends Container {
  ShadowedBox({double width, double height, Widget child})
      : super(
          width: width,
          child: child,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
        );
}
