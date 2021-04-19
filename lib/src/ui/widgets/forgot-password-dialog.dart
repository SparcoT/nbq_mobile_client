import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import 'package:nbq_mobile_client/src/utils/validators.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  State createState() => new ForgotPasswordDialogState();
}

class ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  var _formKey = GlobalKey<FormState>();
  bool _autoValidate =  false;
  var email = TextEditingController();

  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text("Please provide email to reset password",style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                  validator: (value) => emailValidator(value),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(),
                  )),
            ),
          ) ,
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Builder(
                  builder: (ctx) {
                    return FlatButton(
                      color: Colors.black,
                      child: Text("Submit",style: TextStyle(
                        color: Colors.white
                      ),),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          FocusScope.of(context).requestFocus(FocusNode());
                          openLoadingDialog(context, "Submitting");
                          var res;
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                          }
                          on FirebaseAuthException catch (e) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                            print(e);
                            return;
                          }

                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check your email for resetting password.')));
                        }
                        else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                    );
                  }
              ),
            ),
          ),

        ],
      ),
    );
  }

}
