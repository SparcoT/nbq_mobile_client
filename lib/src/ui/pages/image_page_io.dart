import 'dart:io';
import 'dart:isolate';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as im;
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';

class DecodeParam {
  final String file;
  final SendPort sendPort;

  DecodeParam(
    this.file,
    this.sendPort,
  );
}

Widget createImagePage({String image, Widget imageWidget}) => ImagePage(
      image: image,
    );

class ImagePage extends StatefulWidget {
  final String image;

  ImagePage({
    this.image,
  });

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  // final imageName = (await getDownloadsDirectory()).path +
  //     '/' +
  //     DateTime.now().millisecondsSinceEpoch.toString();

  // '.jpg';
  var loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var downloaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  static decodeIsolate(DecodeParam param) async {
    try {
      final list = param.file.split('||');
      final image = im.decodeImage((await File(list[0]).readAsBytes()));
      final file = await File(list[1]).writeAsBytes(im.encodePng(image));
      param.sendPort.send(file.path);
    } catch (e) {
      print('eeeeeeeeeee');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx, lang) => Scaffold(
        appBar: AppBar(),
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              Center(child: CircularProgressIndicator())
            else ...[
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Hero(
                  tag: widget.image,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                    // height: 300,
                    // cacheHeight: 200,
                    // cacheWidth: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                // child: Image.file(
                //   File(imageName),
                //   fit: BoxFit.fill,
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: loading ? null : _downloadImage,
                    icon: Icon(Icons.download_sharp),
                    label: Text(lang.download),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  _downloadImage() async {
    Future<Directory> downloadsDirectory = DownloadsPathProvider.downloadsDirectory;
    final imageName = (await downloadsDirectory).path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString();
    print(imageName);
    openLoadingDialog(context, 'Saving');
    try {
      await Dio().download(widget.image, imageName).then((value) async {
        setState(() => downloaded = true);
      });

      var receivePort = ReceivePort();
      // final filePath =
      //     '${(await getDownloadsDirectory()).path}/${DateTime.now().millisecondsSinceEpoch.toString()}';
      await Isolate.spawn(decodeIsolate,
          DecodeParam(imageName + '||' + imageName, receivePort.sendPort));
      // var path = await receivePort.first as String;
      // await Share.shareFiles([path]);
      // await GallerySaver.saveImage(path).then((value) {
      //   print('RRRRRRRRRRRRR');
      //   print(value);
      // }).catchError((e) {
      //   print('Error');
      //   print('Error');
      //   print(e);
      // });
      // await GallerySaver.saveImage(path).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image saved')));
      // });
      // await File(imageName).delete();
      // await File(path).delete();
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
  }
}

// class _ImageWidget extends StatelessWidget {
//   final String src;
//   final String tag;
//   final Widget image;
//   final Function onLoad;
//
//   _ImageWidget({this.tag, this.onLoad, this.src, this.image});
//
//   @override
//   Widget build(BuildContext context) {
//     print('tag: $tag');
//     return InteractiveViewer(
//       panEnabled: true,
//       child: Hero(
//         tag: tag,
//         child: Image.network(
//           src,
//           height: 500,
//           fit: BoxFit.fitWidth,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) {
//               return child;
//             }
//             return image;
//           },
//         ),
//       ),
//     );
//   }
// }
