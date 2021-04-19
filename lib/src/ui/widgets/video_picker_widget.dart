// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class VideoSelector extends StatefulWidget {
//   File video;
//
//   String videoUrl;
//   VideoSelector();
//
//   @override
//   createState() => _VideoSelectorState();
// }
//
// class _VideoSelectorState extends State<VideoSelector> {
//   // @override
//   // initState() {
//   //   super.initState();
//   //   if (widget.videos == null) {
//   //     widget.videos = Map();
//   //   }
//   // }
//
//   @override
//   build(context) => ConstrainedBox(
//     constraints: BoxConstraints.expand(height: 150),
//     child: Stack(
//       overflow: Overflow.visible,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               color: Colors.grey.shade200,
//               child: Center(
//                 child: widget.video== null
//                     ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(Icons.image),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 3),
//                     ),
//                     Text("No videos Selected!",style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w400)),
//                   ],
//                 )
//                     : ListView.builder(
//                   itemCount: widget.videos.length,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, i) => GestureDetector(
//                     onLongPress: () {
//                       showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text("Delete image?"),
//                             actions: [
//                               FlatButton(
//                                 onPressed: () => setState(() {
//                                   widget.videos.remove(widget
//                                       .videos.keys
//                                       .elementAt(i));
//                                   Navigator.of(context).pop();
//                                 }),
//                                 child: Text("Yes"),
//                               ),
//                               FlatButton(
//                                 onPressed: () =>
//                                     Navigator.of(context).pop(),
//                                 child: Text("No"),
//                               )
//                             ],
//                           ));
//                     },
//                     child: SizedBox(
//                       width: 150,
//                       height: 150,
//                       child: Image.file(
//                         File(widget.videos.values.elementAt(i)),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//               )),
//         ),
//         Positioned(
//           bottom: -15,
//           child: FlatButton(
//             padding: EdgeInsets.all(8),
//             shape: CircleBorder(),
//             color: Color(0xFF6078ea),
//             onPressed: () async {
//               FilePickerResult tempvideos;
//               try {
//                 tempvideos = await FilePicker.platform.pickFiles(
//                     type: FileType.video);
//               } on PlatformException catch (e) {
//                 // Message Display.
//               }
//               if (mounted) setState(() => widget.videos.addAll(tempvideos));
//             },
//             child: Icon(
//               Icons.add,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }