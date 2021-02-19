import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// TODO(arish) refactor and implement email sending scenario
class ContactUsView extends StatefulWidget {
  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  var _termsAccepted = false;

  void _sendMessage() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Text(
            'Contacto',
            style: GoogleFonts.bebasNeue(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
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
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'NAME'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'EMAIL'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      'MENSAJE',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: TextFormField(
                maxLines: 4,
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
                  onChanged: (val) => setState(() => _termsAccepted = val),
                ),
                Expanded(
                  child: Text(
                    'Acepto las condiciones de uso.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Transform.scale(
                  scale: .8,
                  child: TextButton(
                    child: Text('ENVIAR'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: _termsAccepted ? _sendMessage : null,
                  ),
                )
              ]),
            )
          ]),
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
              onPressed: () => launch('https://www.facebook.com/NBQCompany/'),
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
              onPressed: () => launch('https://www.instagram.com/nbqcompany/'),
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
    );
  }
}
