// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_it/screens/img_gallary.dart';
import 'home_screen.dart';

class ImageUploadPage extends StatefulWidget {
  final String folderName;

  const ImageUploadPage({required this.folderName, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
        storage.ref().child('${widget.folderName}/${DateTime.now()}.png');
    UploadTask uploadTask = storageReference.putFile(_imageFile!);

    await uploadTask.whenComplete(() {
      print('Image uploaded to Firebase Storage');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImageGallery(folderName: widget.folderName),
        ),
      );
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      print('Error uploading image: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your Creation'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen()), // Replace with your homepage widget
              );
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text('No Image Selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
      home: ImageUploadPage(
    folderName: '',
  )));
}
