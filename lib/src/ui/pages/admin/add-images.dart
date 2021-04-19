import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nbq_mobile_client/src/firebase-videos/image_model.dart';
import 'package:nbq_mobile_client/src/ui/widgets/image-picker-widget.dart';
import 'package:nbq_mobile_client/src/ui/widgets/round-drop-down-button.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import 'package:nbq_mobile_client/src/firebase-videos/firebase-storage-service.dart';

class AddImages extends StatefulWidget {
  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  PickedFile image;
  String selectedCategory;
  var key = GlobalKey<FormState>();
  List<String> categories = ["Diseños",
    "Expositores", "Marketing",
    "Sprays"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Image"),
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          padding: kIsWeb
              ? EdgeInsets.symmetric(
              vertical: 100,
              horizontal: MediaQuery.of(context).size.width / 3)
              : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ImagePickerWidget(
                    onImagePicked: (PickedFile file){
                      setState(() {
                        image = file;
                      });
                    },
                  ),
                  RoundDropDownButton(
                    hint: Text('Category'),
                    items: categories
                        .map((i) => DropdownMenuItem<String>(
                        child: Text(i), value: i))
                        .toList(),
                    value: selectedCategory,
                    onChanged: (String value){
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if (key.currentState.validate()) {
                              await performLazyTask(context, () async {
                                var imgUrl =
                                await FirebaseStorageService.uploadImage(
                                   await image.readAsBytes(), image.path);

                                await FirebaseFirestore.instance
                                    .collection('images')
                                    .add(ImageModel(
                                image: imgUrl,
                                  category: selectedCategory
                                ).toJson());
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image Uploaded Successfully'),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
