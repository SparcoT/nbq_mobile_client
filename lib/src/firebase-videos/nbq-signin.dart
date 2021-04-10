import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/firebase-videos/service.dart';
import 'package:nbq_mobile_client/src/ui/pages/home_page.dart';
import 'package:nbq_mobile_client/src/utils/validators.dart';

class NbqSignIn extends StatefulWidget {
  @override
  _NbqSignInState createState() => _NbqSignInState();
}

class _NbqSignInState extends State<NbqSignIn> {
  String email, password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  onSaved: (email) => this.email = email,
                  decoration: InputDecoration(
                    labelText: 'username',
                    border: OutlineInputBorder(),
                  ),
                  validator: emailValidator,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    onSaved: (password) => this.password = password,
                    decoration: InputDecoration(
                      labelText: 'password',
                      border: OutlineInputBorder(),
                    ),
                    validator: Validators.required,
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        final result = await FirebaseService()
                            .signIn(email: email, password: password)
                            .catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        });
                        if (result != null) {
                          AppNavigation.navigateTo(context, HomePage());
                        }
                      }
                    },
                    child: Text("Signin"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
