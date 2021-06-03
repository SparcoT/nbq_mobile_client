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
    final folders = await FirebaseStorage.instance.ref().list();
    _folders = folders.prefixes.map((e) => e.fullPath).toList();

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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _handleFolderCreate,
              icon: Icon(Icons.create_new_folder),
              label: Text('Create New Folder'),
            ),
          );
        },
      );
    }
  }

  void _handleFolderCreate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Create a new Folder')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Folder Name'
                ),
              )
            ],
          ),
        );
      },
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
