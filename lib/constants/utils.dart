import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      for (int i = 0; i < result.files.length; i++) {
        if (result.files[i].path == null) {
          debugPrint("Skipped - ${result.files[i].name} image's path is null");
          continue;
        }
        images.add(File(result.files[i].path!));
      }
    }
  } catch (error) {
    debugPrint(error.toString());
  }

  return images;
}
