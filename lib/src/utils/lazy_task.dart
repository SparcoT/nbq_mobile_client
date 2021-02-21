import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pedantic/pedantic.dart';

Future<dynamic> performLazyTask(
  BuildContext context,
  Future<dynamic> Function() task, {
  String message = 'Please Wait',
  bool persistent = true,
}) async {

  FocusScope.of(context).requestFocus(FocusNode());
  FocusScope.of(context).requestFocus(FocusNode());

  if (persistent) {
    unawaited(openLoadingDialog(context, message));
  } else {
    unawaited(openLoadingDialog(context, message));
  }

  final result = await task();
  if(Navigator.canPop(context))
    Navigator?.of(context)?.pop();

  return result;
}



openLoadingDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator()
              ),
              SizedBox(height: 15),
              Text(text + "...")
            ]),
      ));
}
