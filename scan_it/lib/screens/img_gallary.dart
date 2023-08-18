import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home_screen.dart';

void main() {
  runApp(const MaterialApp(
      home: ImageGallery(
    folderName: '',
  )));
}

class ImageGallery extends StatefulWidget {
  final String folderName;

  const ImageGallery({required this.folderName, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  late List<Reference> imageReferences;

  @override
  void initState() {
    super.initState();
    fetchImageReferences();
  }

  Future<void> fetchImageReferences() async {
    ListResult result = await storage.ref().child(widget.folderName).listAll();
    imageReferences = result.items;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Similar Creations'),
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
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imageReferences.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: imageReferences[index].getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Image.network(
                        snapshot.data as String,
                        fit: BoxFit.cover,
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
