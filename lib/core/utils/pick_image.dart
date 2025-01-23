import 'dart:io';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(BuildContext context) async {
  // Show bottom sheet to select camera or gallery
  final selectedSource = await showModalBottomSheet<ImageSource>(
    context: context,
    isScrollControlled: true, // To allow full height if needed
    backgroundColor: Colors.transparent, // Make the background transparent
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Colors.blue,
                size: 30,
              ),
              title: Text(
                'Camera',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context, ImageSource.camera);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.image,
                color: Colors.green,
                size: 30,
              ),
              title: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );

  if (selectedSource != null) {
    // Pick the image based on the selected source
    try {
      final xFile = await ImagePicker().pickImage(source: selectedSource);
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  return null;
}
