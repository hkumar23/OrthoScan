import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppMethods {
  static Future<File> pickImage(ImageSource imageSource) async {
    // print("Picking image");
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: imageSource,
      // imageQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    return File(image!.path);
  }
}
