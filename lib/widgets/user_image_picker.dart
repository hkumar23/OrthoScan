import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.pickImagefn, {super.key});
  final void Function(File? pickedImage) pickImagefn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;
  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      // maxWidth: 150,
    );
    setState(() {
      pickedImage = File(image!.path);
    });
    widget.pickImagefn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                  )
                ]),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: pickedImage != null
                  ? FileImage(pickedImage!)
                  : const NetworkImage(
                          "https://i.pinimg.com/736x/20/c0/0f/20c00f0f135c950096a54b7b465e45cc.jpg")
                      as ImageProvider,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 2),
              Text(
                "Add Image",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
