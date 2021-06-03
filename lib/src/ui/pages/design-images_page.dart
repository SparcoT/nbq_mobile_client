import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/firebase-videos/firebase-storage-service.dart';
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
    final folders = await FirebaseStorage.instance.ref().list();
    _folders = folders.prefixes.map((e) => e.fullPath).toList();

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CreateFolderDialog();

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
          final crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;

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
            floatingActionButton: kIsWeb
                ? FloatingActionButton.extended(
                    onPressed: _handleFolderCreate,
                    icon: Icon(Icons.create_new_folder),
                    label: Text('Create New Folder'),
                  )
                : null,
          );
        },
      );
    }
  }

  void _handleFolderCreate() {
    showDialog(
      context: context,
      builder: (context) => _CreateFolderDialog(),
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
              ImagesDetailPage(title: title),
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
  const _CreateFolderDialog({Key key}) : super(key: key);

  @override
  __CreateFolderDialogState createState() => __CreateFolderDialogState();
}

class __CreateFolderDialogState extends State<_CreateFolderDialog> {
  List<PlatformFile> _selectedImage = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // title: Center(child: Text('Create a new Folder')),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 48, 40, 36),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Folder Name'),
              ),
              SizedBox(height: 20),
              Container(
                constraints: BoxConstraints.expand(height: 200),
                color: Colors.grey.shade200,
                child: _selectedImage.isEmpty
                    ? Center(
                        child: Text(
                          'Select At least one image to proceed',
                        ),
                      )
                    : ListView.builder(
                        itemCount: _selectedImage.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SelectedImage(image: _selectedImage[index]);
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
                Spacer(),
                TextButton(
                  child: Text('Create'),
                  onPressed: () async {
                    final task = FirebaseStorage.instance.ref('').putData([]);

                    task.snapshotEvents.listen((event) {
                      event.bytesTransferred;
                    });
                    // if (_selectedImage == null) return;
                    // await FirebaseStorageService.uploadImage(
                    //     _selectedImage.bytes, _selectedImage.path);
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedImage extends StatefulWidget {
  final PlatformFile image;

  const SelectedImage({this.image}) : super();

  @override
  _SelectedImageState createState() => _SelectedImageState();
}

class _SelectedImageState extends State<SelectedImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4)
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Image.memory(
        widget.image.bytes,
        fit: BoxFit.cover,
      ),
    );
  }
}
