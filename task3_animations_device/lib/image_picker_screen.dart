import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  XFile? _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (_image == null) {
      imageWidget = const Text("No image selected");
    } else {
      imageWidget = kIsWeb
          ? Image.network(_image!.path) // For web
          : Image.file(File(_image!.path)); // For mobile
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pick Image"), 
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,),
      body: Center(child: imageWidget),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: const Icon(Icons.photo_library),
      ),
    );
  }
}
