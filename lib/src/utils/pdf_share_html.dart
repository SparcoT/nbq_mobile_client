import 'dart:html' as html;
import 'dart:convert';
import 'package:pdf/widgets.dart';

Future<void> sharePDF(Document document) async {
  final content = base64Encode(await document.save());
  html.AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64,$content")
    ..setAttribute("download", "order${DateTime.now()}.pdf")
    ..click();
}
