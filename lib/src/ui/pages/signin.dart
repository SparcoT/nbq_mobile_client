import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/ui/pages/admin/add-video.dart';
import 'package:nbq_mobile_client/src/ui/pages/admin/test-videos_web.dart';
import 'package:nbq_mobile_client/src/ui/widgets/forgot-password-dialog.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';

import 'admin/admin-home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<ScaffoldState> scaffold = new GlobalKey<ScaffoldState>();

  bool remember = false;
  bool autovalidate = false;
  final formkey = GlobalKey<FormState>();
  bool _obscuretext = true;

  Widget InputField(
      String label, String label1, TextEditingController con, Icon icon) {
    return TextFormField(
      controller: con,
      cursorColor: Color.fromRGBO(11, 142, 54, 1),
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        //labelText: label,
        icon: icon,
        hintText: label1,
        contentPadding: EdgeInsets.all(5),
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: 'Poppins',
          color: Color.fromRGBO(150, 150, 150, 1.0),
        ),
        focusColor: Color.fromRGBO(11, 142, 54, 1),
      ),
    );
  }

  MaterialButton Button(String label, Color color, Color color1) {
    return MaterialButton(
      onPressed: () async {
        if (formkey.currentState.validate()) {
          openLoadingDialog(context, "Signing In");
          try {
            UserCredential userCredential =
                await _auth.signInWithEmailAndPassword(
                    email: email.text.trim(), password: password.text);
            User user = userCredential.user;
            Navigator.of(context).pop();
            AppNavigation.navigateToPage(context, AppPages.adminHome);
            // Navigate to add videos page
          } on FirebaseAuthException catch (error) {
            Navigator.pop(context);
            scaffold.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(error.message),
              duration: Duration(seconds: 2),
            ));
            return;
          }
        } else {
          setState(() {
            autovalidate = true;
          });
        }
      },
      color: color,
      height: 45,
      minWidth: 150,
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 5,
      child: Text(
        label,
        style: TextStyle(
            fontSize: 19,
            fontFamily: 'Poppins',
            color: color1,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffold,
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Stack(
          children: [
            Center(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  Form(
                                      key: formkey,
                                      autovalidate: autovalidate,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: email,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Email is required";
                                              }
                                              return null;
                                            },
                                            cursorColor:
                                                Color.fromRGBO(11, 142, 54, 1),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              //labelText: label,
                                              icon: Icon(Icons.email),
                                              hintText: "Email",
                                              contentPadding: EdgeInsets.all(5),
                                              hintStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    150, 150, 150, 1.0),
                                              ),
                                              focusColor: Color.fromRGBO(
                                                  11, 142, 54, 1),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            obscureText: _obscuretext,
                                            controller: password,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Password is required";
                                              }
                                              return null;
                                            },
                                            cursorColor:
                                                Color.fromRGBO(11, 142, 54, 1),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                child: Icon(_obscuretext
                                                    ? Icons.visibility_off
                                                    : Icons.visibility),
                                                onTap: () {
                                                  setState(() {
                                                    _obscuretext =
                                                        !_obscuretext;
                                                  });
                                                },
                                              ),
                                              //labelText: label,
                                              icon: Icon(Icons.lock),
                                              hintText: "Password",
                                              contentPadding: EdgeInsets.all(5),
                                              hintStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                color: Color.fromRGBO(
                                                    150, 150, 150, 1.0),
                                              ),
                                              focusColor: Color.fromRGBO(
                                                  11, 142, 54, 1),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Button("Sign In", Colors.black,
                                              Colors.white),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ForgotPasswordDialog();
                                                });
                                          },
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Colors.black, //Color.fromRGBO(242, 129, 59, 1),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
