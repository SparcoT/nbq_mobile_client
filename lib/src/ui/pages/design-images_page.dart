import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/pages/images-detail_page.dart';

import '../../app.dart';

class DesignImages extends StatefulWidget {
  @override
  _DesignImagesState createState() => _DesignImagesState();
}

class _DesignImagesState extends State<DesignImages> {
  var _loading = true;
  List<String> _folders;

  @override
  void initState() {
    super.initState();
    _updateFolders();
  }

  _updateFolders() async {
    _loading = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    final folders = await FirebaseStorage.instance.ref('_thumbnail').list();
    _folders = folders.prefixes
        .map((e) => e.name)
        .where((element) => !element.contains('_order'))
        .toList();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(width: 10),
            Text('Loading Designs'),
          ],
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth ~/ 600 + 1;

          return Scaffold(
            body: GridView.count(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 6,
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              crossAxisCount: crossAxisCount,
              children: _folders
                  .map((e) => _FolderTile(title: e, context: context))
                  .toList(),
            ),
          );
        },
      );
    }
  }

  void _handleFolderCreate() {
    showDialog(
      context: context,
      builder: (context) => _CreateFolderDialog(
        onUpdated: _updateFolders,
      ),
    );
  }
}

class _FolderTile extends Material {
  _FolderTile({String title, BuildContext context})
      : super(
          child: InkWell(
            highlightColor: AppTheme.primaryColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
            onTap: () => AppNavigation.navigateTo(
              context,
              ImagesDetailPage(title: '_thumbnail/$title'),
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset("assets/icons/folder_pink.png"),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
          ),
        );
}

class _CreateFolderDialog extends StatefulWidget {
  final VoidCallback onUpdated;

  const _CreateFolderDialog({Key key, this.onUpdated}) : super(key: key);

  @override
  __CreateFolderDialogState createState() => __CreateFolderDialogState();
}

class __CreateFolderDialogState extends State<_CreateFolderDialog> {
  var folderName = '';
  final _key = GlobalKey<FormState>();
  List<PlatformFile> _selectedImage = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 48, 40, 36),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (val) {
                    if (val == null || val == '') {
                      return 'Enter a valid folder name';
                    }

                    return null;
                  },
                  onSaved: (val) => folderName = val,
                  decoration: InputDecoration(labelText: 'Folder Name'),
                ),
                SizedBox(height: 20),
                Container(
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
                SizedBox(height: 15),
                Row(children: [
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
                    child: Text('Create'),
                    onPressed: () async {
                      if (_key.currentState.validate()) {
                        _key.currentState.save();
                      }

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
                                .ref('$folderName/$name')
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
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadingDialog extends StatefulWidget {
  final int total;
  final Stream<int> progress;
  final VoidCallback onCanceled;

  const UploadingDialog({
    this.total,
    this.progress,
    this.onCanceled,
  }) : super();

  @override
  _UploadingDialogState createState() => _UploadingDialogState();
}

class _UploadingDialogState extends State<UploadingDialog> {
  int progress = 0;

  @override
  void initState() {
    super.initState();
    widget.progress.listen((event) {
      setState(() => progress = event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('Uploading Images')),
      content: LinearProgressIndicator(
        value: progress.toDouble() / widget.total,
        valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
        backgroundColor: AppTheme.primaryColor.withOpacity(.2),
      ),
    );
  }
}

class SelectedImage extends StatelessWidget {
  final PlatformFile image;
  final VoidCallback onRemoved;

  const SelectedImage({this.image, this.onRemoved}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      clipBehavior: Clip.antiAlias,
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: onRemoved,
          child: Icon(CupertinoIcons.delete),
          style: TextButton.styleFrom(
            fixedSize: Size(50, 50),
            elevation: 10,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
            ),
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(image.bytes),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
