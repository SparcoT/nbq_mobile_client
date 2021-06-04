import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/ui/pages/design-images_page.dart';

import 'package:nbq_mobile_client/src/ui/pages/image_page.dart'
    if (dart.library.io) 'package:nbq_mobile_client/src/ui/pages/image_page_io.dart'
    if (dart.library.html) 'package:nbq_mobile_client/src/ui/pages/image_page_web.dart';

class ImagesDetailPage extends StatefulWidget {
  final String title;

  ImagesDetailPage({this.title});

  @override
  _ImagesDetailPageState createState() => _ImagesDetailPageState();
}

class _ImagesDetailPageState extends State<ImagesDetailPage> {
  var _loading = true;
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  _getImages() async {
    _loading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    await FirebaseStorage.instance.ref(widget.title).list().then((value) async {
      images = [];
      for (var i = 0; i < value.items.length; i++) {
        images.add((await value.items[i].getDownloadURL()));
      }
    });
    _loading = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : images.isEmpty
              ? Center(child: Text('No Data'))
              : LayoutBuilder(builder: (context, constraints) {
                  return GridView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final _image = images[index];
                      final child = Image.network(
                        _image,
                        // fit: BoxFit.cover,
                        cacheHeight: 200,
                        cacheWidth: 200,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      return InkWell(
                        onTap: () {
                          return AppNavigation.navigateTo(
                            context,
                            createImagePage(image: _image, imageWidget: child),
                          );
                        },
                        child: Hero(
                          tag: _image,
                          child: child,
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  );
                }),
      floatingActionButton: kIsWeb
          ? FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _UploadFolderImages(
                    title: widget.title,
                    onUpdated: _getImages,
                  ),
                );
              },
              icon: Icon(Icons.photo),
              label: Text('Upload Images'),
            )
          : null,
    );
  }

// Widget imgGrid(List<ImageModel> images)=>GridView.builder(
//   itemCount: images.length,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: kIsWeb ? 5 : 2,
//     crossAxisSpacing: kIsWeb ? 12 : 4.0,
//     mainAxisSpacing: kIsWeb ? 12.0 : 4.0,
//   ),
//   itemBuilder: (ctx, index) {
//     final _image = images[index].image;
//     final image = Image.network(
//       _image,
//       fit: BoxFit.fill,
//       // height: 300,
//       cacheHeight: 200,
//       cacheWidth: 200,
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) {
//           return child;
//         }
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//
//     return InkWell(
//       onTap: () {
//         return AppNavigation.navigateTo(
//           context,
//           createImagePage(image: _image, imageWidget: image),
//         );
//       },
//       child: Hero(tag: _image, child: image),
//     );
//   },
// );
}

class _UploadFolderImages extends StatefulWidget {
  final String title;
  final VoidCallback onUpdated;

  const _UploadFolderImages({
    Key key,
    @required this.title,
    this.onUpdated,
  }) : super(key: key);

  @override
  __UploadFolderImagesState createState() => __UploadFolderImagesState();
}

class __UploadFolderImagesState extends State<_UploadFolderImages> {
  List<PlatformFile> _selectedImage = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 48, 40, 36),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15),
                constraints: BoxConstraints.expand(height: 200),
                color: Colors.grey.shade200,
                child: _selectedImage.isEmpty
                    ? Center(
                        child: Text('Select At least one image to proceed'),
                      )
                    : ListView.builder(
                        itemCount: _selectedImage.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemBuilder: (context, index) {
                          return SelectedImage(
                            image: _selectedImage[index],
                            onRemoved: () {
                              _selectedImage.removeAt(index);
                              setState(() {});
                            },
                          );
                        },
                      ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      primary: AppTheme.primaryColor,
                      padding: kIsWeb ? EdgeInsets.all(17) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: BorderSide(color: AppTheme.primaryColor),
                    ),
                    label: Text('Add Image'),
                    icon: Icon(Icons.upload_outlined),
                    onPressed: () async {
                      final _files = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );
                      if (_selectedImage == null) return;
                      _selectedImage.addAll(_files.files);
                      setState(() {});
                    },
                  ),
                  // UploadingDialog(),
                  Spacer(),
                  TextButton(
                    child: Text('Upload'),
                    onPressed: () async {
                      final total = _selectedImage.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.size);

                      final controller = StreamController<int>();
                      showDialog(
                        context: context,
                        builder: (context) => UploadingDialog(
                          total: total,
                          progress: controller.stream,
                        ),
                      );
                      for (int i = 0; i < _selectedImage.length; ++i) {
                        var name = _selectedImage[i].name;
                        name = DateTime.now().toString() + name.split('.').last;

                        await (FirebaseStorage.instance
                                .ref('${widget.title}/$name')
                                .putData(_selectedImage[i].bytes)
                                  ..snapshotEvents.listen((event) =>
                                      controller.add(event.bytesTransferred)))
                            .then((val) {});
                      }

                      controller.close();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      widget.onUpdated();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
