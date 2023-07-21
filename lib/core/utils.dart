/*In this code, you have several utility functions related to UI and image handling:

showSnackBar: Displays a SnackBar with the provided content in the given BuildContext.

getNameFromEmail: Extracts the name from an email address by splitting the email string at the '@' symbol and returning the first part.

pickImages: Allows the user to pick multiple images from the device's gallery using the ImagePicker package. It returns a Future that resolves to a list of File objects representing the selected images.

pickImage: Allows the user to pick a single image from the device's gallery using the ImagePicker package. It returns a Future that resolves to a File object representing the selected image, or null if no image was selected.

These functions can be used in your Flutter application for various purposes, such as displaying notifications, extracting names from email addresses, and selecting images from the device's gallery. */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Shows a SnackBar with the provided content
void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

// Extracts the name from an email address
String getNameFromEmail(String email) {
  return email.split('@')[0];
}

// Allows the user to pick multiple images from the device's gallery
Future<List<File>> pickImages() async {
  List<File> images = [];

  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();

  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }

  return images;
}

// Allows the user to pick a single image from the device's gallery
Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(source: ImageSource.gallery);

  if (imageFile != null) {
    return File(imageFile.path);
  }

  return null;
}
