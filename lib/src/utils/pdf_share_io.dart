import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:share/share.dart';

Future<void> sharePDF(Document document) async {
  final path = Directory.systemTemp.path + '/order${DateTime.now()}.pdf';
  final file = File(path);
  await file.writeAsBytes(await document.save());
  await Share.shareFiles([path]);
//  await file.delete();
}
