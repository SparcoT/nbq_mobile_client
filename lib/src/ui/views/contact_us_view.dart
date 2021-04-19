import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/text_field.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../utils/validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Contact {
  String name;
  String email;
  String message;

  Contact({this.message, this.email, this.name});
}

class ContactUsView extends StatefulWidget {
  final String email;

  ContactUsView({this.email});

  @override
  ContactUsViewState createState() => ContactUsViewState();
}

class ContactUsViewState extends State<ContactUsView> {
  var _termsAccepted = false;
  final formKey = GlobalKey<FormState>();
  var _contact = Contact();
  static var email = 'em1407@nbqpro.com';
  AutovalidateMode _mode = AutovalidateMode.disabled;

  void _sendMessage() async {
    if (!formKey.currentState.validate()) {
      setState(() {
        _mode = AutovalidateMode.always;
      });
      return;
    }
    formKey.currentState.save();
    await performLazyTask(context, () async {
      var headers = {
        'Authorization':
            'Bearer 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',
        'Content-Type': 'application/json',
      };

      var data = '{"personalizations": [{"to": [{"email": "$email"}]}], '
          '"from": {"email": "em1407@nbqpro.com"},"subject": "Contact From App", '
          '"content": [{"type": "text/plain", "value": "Name : ${_contact.name} Email : ${_contact.email} Message : ${_contact.message}"}]}';

      var response = await http.post(
          Uri.parse('https://api.sendgrid.com/v3/mail/send'),
          headers: headers,
          body: data);
      print(response.body);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).receivedRequest)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: formKey,
        autovalidateMode: _mode,
        child: LocalizedView(
          builder: (context, lang) => Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                lang.contact,
                style: GoogleFonts.bebasNeue(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
         kIsWeb?           Container(
           margin: const EdgeInsets.symmetric(horizontal: 400,vertical: 15),
           padding: const EdgeInsets.only(bottom: 10),
           decoration: BoxDecoration(
             color: Color(0xFFF5F5F5),
             borderRadius: BorderRadius.circular(22),
             boxShadow: [
               BoxShadow(
                 color: Colors.grey.shade400,
                 blurRadius: 3,
                 offset: Offset(0, 2),
               )
             ],
           ),
           child: Column(
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 15),
                 child: Column(
                   children: [
                     AppTextField(
                       value: _contact.name,
                       label: lang.name,
                       validator: Validators.required,
                       onSaved: (value) => _contact.name = value,
                     ),
                     AppTextField(
                       label: lang.email,
                       value: _contact.email,
                       validator: emailValidator,
                       onSaved: (value) => _contact.email = value,
                     ),
                     Padding(
                       padding: const EdgeInsets.only(top: 18),
                       child: Text(
                         lang.message,
                         style: GoogleFonts.bebasNeue(
                           fontSize: 16,
                           color: Colors.grey.shade600,
                         ),
                       ),
                     ),
                   ],
                   crossAxisAlignment: CrossAxisAlignment.start,
                 ),
               ),
               Container(
                 margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                 child: TextFormField(
                   maxLines: 4,
                   onSaved: (value) => _contact.email = value,
                   validator: Validators.required,
                   initialValue: _contact.message,
                   decoration: InputDecoration(
                     filled: true,
                     fillColor: Colors.white,
                     contentPadding: EdgeInsets.all(10),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                 ),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(16),
                   boxShadow: [
                     BoxShadow(
                       offset: Offset(2, 2),
                       color: Colors.grey.shade400,
                       blurRadius: 2,
                     )
                   ],
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(left: 7.5, right: 9),
                 child: Row(children: [
                   Checkbox(
                     value: _termsAccepted,
                     visualDensity: VisualDensity.compact,
                     onChanged: (val) =>
                         setState(() => _termsAccepted = val),
                   ),
                   Expanded(
                       child: Text(
                         lang.terms,
                         style: TextStyle(fontSize: 13),
                       )),
                   Transform.scale(
                     scale: .8,
                     child: TextButton(
                       child: Text(lang.send),
                       style: TextButton.styleFrom(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                       ),
                       onPressed: _termsAccepted ? _sendMessage : null,
                     ),
                   )
                 ]),
               )
             ],
           ),
         ):  Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 35),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        AppTextField(
                          value: _contact.name,
                          label: lang.name,
                          validator: Validators.required,
                          onSaved: (value) => _contact.name = value,
                        ),
                        AppTextField(
                          label: lang.email,
                          value: _contact.email,
                          validator: emailValidator,
                          onSaved: (value) => _contact.email = value,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: Text(
                            lang.message,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: TextFormField(
                      maxLines: 4,
                      onSaved: (value) => _contact.email = value,
                      validator: Validators.required,
                      initialValue: _contact.message,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          color: Colors.grey.shade400,
                          blurRadius: 2,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.5, right: 9),
                    child: Row(children: [
                      Checkbox(
                        value: _termsAccepted,
                        visualDensity: VisualDensity.compact,
                        onChanged: (val) =>
                            setState(() => _termsAccepted = val),
                      ),
                      Expanded(
                          child: Text(
                        lang.terms,
                        style: TextStyle(fontSize: 13),
                      )),
                      Transform.scale(
                        scale: .8,
                        child: TextButton(
                          child: Text(lang.send),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          onPressed: _termsAccepted ? _sendMessage : null,
                        ),
                      )
                    ]),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(children: [
                TextButton(
                  child: Text('WEB'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                  ),
                  onPressed: () => launch('https://nbqpro.com/en/'),
                ),
                SizedBox(width: 5),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(35, 35),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 5),
                    child: Icon(FontAwesomeIcons.facebookF, size: 27),
                  ),
                  onPressed: () =>
                      launch('https://www.facebook.com/NBQCompany/'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(35, 35),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(FontAwesomeIcons.instagram),
                  ),
                  onPressed: () =>
                      launch('https://www.instagram.com/nbqspray/'),
                ),
              ], mainAxisAlignment: MainAxisAlignment.center),
            ),
            Text(
              '''C/ Empalme 27
43712 LLORENS DEL PENEDÉS (Spain)
Tel. +34 977 677 305
            ''',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(),
            ),
          ]),
        ),
      ),
    );
  }
}
