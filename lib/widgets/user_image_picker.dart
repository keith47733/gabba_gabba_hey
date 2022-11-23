import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../styles/layout.dart';
import 'show_error_dialog.dart';

class UserImagePicker extends StatefulWidget {
	final Function(File pickedImage) imagePick;
	const UserImagePicker(this.imagePick, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? pickedImageX;
  File? pickedImage;

  Future pickImage() async {
    try {
      final pickedImageX = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImageX == null) return;
      setState(() {
        pickedImage = File(pickedImageX.path);
      });
			widget.imagePick(pickedImage!);
    } on PlatformException catch (error) {
      showErrorDialog(context, 'Error', error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: pickedImage == null ? null : FileImage(pickedImage!),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          radius: MediaQuery.of(context).size.width * 0.30 / 2,
        ),
        const SizedBox(height: Layout.SPACING / 2),
        GestureDetector(
          onTap: pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                size: Layout.ICONSIZE,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: Layout.SPACING / 2),
              Text(
                'Add image',
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Layout.SPACING),
      ],
    );
  }
}
