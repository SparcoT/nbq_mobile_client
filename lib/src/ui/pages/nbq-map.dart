import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:nbq_mobile_client/src/ui/views/contact_us_view.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/text_field.dart';
import 'package:nbq_mobile_client/src/utils/countries-consts.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import 'dart:ui' as ui;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nbq_mobile_client/src/utils/validators.dart';

class NBQMap extends StatefulWidget {
  @override
  _NBQMapState createState() => _NBQMapState();
}

class _NBQMapState extends State<NBQMap> {
  bool _initiated = true, _showAddMarker = false;

  LatLng currentLocation = LatLng(51.323946, 10.296971);
  final _markers = Set<Marker>();
  final _formKey = GlobalKey<FormState>();
  var hasAction = true;

  var deleteAction = false;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  _showContactDialog(String email, [Uint8List image]) async {
    var temp = hasAction;
    setState(() => hasAction = false);
    await showDialog(
      context: context,
      builder: (ctx) => _ShowDialog(email: email, image: image),
    );
    setState(() => hasAction = temp);
  }

  Future<void> _loadOtherMarkers() async {
    final data = (await FirebaseFirestore.instance.collection('markers').get())
        .docs
        .map((e) => {'uid': e.id, ...e.data()});

    print('OTHER MARKERS $data');

    data.forEach((element) {
      _markers.add(Marker(
        markerId: MarkerId(element['uid']),
        position: LatLng(element['lat'], element['lng']),
        onTap: () {
          if (deleteAction) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Do you want to remove it?'),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text('No'),
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('markers')
                            .doc(element['uid'])
                            .delete();

                        _markers.removeWhere(
                            (e) => e.markerId.value == element['uid']);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        infoWindow: InfoWindow(
          title: element['name'],
          snippet: element['email'],
          onTap: () async {
            _showContactDialog(element['email']);
          },
        ),
      ));
    });
  }

  Future<void> _loadMarkers() async {
    for (final element in countries) {
      final image = kIsWeb
          ? await getBytesFromAsset(
              'assets/countries_web/${element['image']}.png', 1)
          : await getBytesFromAsset(
              'assets/countries/${element['image']}.jpg', 50);

      _markers.add(Marker(
        markerId: MarkerId(element['image']),
        icon: BitmapDescriptor.fromBytes(image),
        position: LatLng(element['latitude'], element['longitude']),
        infoWindow: InfoWindow(
          title: element['name'],
          snippet: element['email'],
          onTap: () async {
            final _image = await getBytesFromAsset(
                'assets/countries/${element['image']}.jpg', 100);
            _showContactDialog(element['email'], _image);
          },
        ),
      ));
    }

    await _loadOtherMarkers();
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Image.asset(Assets.logo, height: 40),
          centerTitle: true,
          leading: IconButton(
            icon: Transform.rotate(
              angle: Localizations.localeOf(context).toString() == 'ar'
                  ? 3.14159
                  : 0,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ),
        body: _resolveMap(),
      ),
    );
  }

  _resolveMap() {
    if (_initiated) {
      return GoogleMap(
        myLocationButtonEnabled: false,
        initialCameraPosition:
            CameraPosition(target: currentLocation, zoom: 5),
        onMapCreated: (controller) {
          // _controller = controller;
        },
        compassEnabled: true,
        markers: _markers,
      );
    } else {
      return Center(
        child: Row(children: [
          SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
          SizedBox(width: 20),
          Text('Loading')
        ], mainAxisAlignment: MainAxisAlignment.center),
      );
    }
  }
}

const apiKey = "AIzaSyDdNpY6LGWgHqRfTRZsKkVhocYOaER325w";

class _ShowDialog extends StatefulWidget {
  final String email;
  final Uint8List image;

  _ShowDialog({@required this.email, this.image});

  @override
  __ShowDialogState createState() => __ShowDialogState();
}

class __ShowDialogState extends State<_ShowDialog> {
  var _contact = Contact();
  var _termsAccepted = false;
  AutovalidateMode _mode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx1, lang) => AlertDialog(
        title: Text(lang.contact),
        content: Form(
          key: formKey,
          autovalidateMode: _mode,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                if (widget.image != null) Image.memory(widget.image),
                Padding(
                  padding: const EdgeInsets.only(left: 7.5, right: 9, top: 10),
                  child: Row(
                    children: [
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

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

      var data =
          '{"personalizations": [{"to": [{"email": "${widget.email}"}]}], '
          '"from": {"email": "em1407@nbqpro.com"},"subject": "Contact From App", '
          '"content": [{"type": "text/plain", "value": "Name : ${_contact.name} Email : ${_contact.email} Message : ${_contact.message}"}]}';

      var response = await http.post(
          Uri.parse('https://api.sendgrid.com/v3/mail/send'),
          headers: headers,
          body: data);
      print(response.body);
    });
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).receivedRequest)));
  }
}
