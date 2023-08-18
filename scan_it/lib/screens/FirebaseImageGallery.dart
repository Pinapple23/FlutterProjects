import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'home_screen.dart';

void main() {
  runApp(const MaterialApp(home: FirebaseImageGallery()));
}

class FirebaseImageGallery extends StatefulWidget {
  const FirebaseImageGallery({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirebaseImageGalleryState createState() => _FirebaseImageGalleryState();
}

class _FirebaseImageGalleryState extends State<FirebaseImageGallery> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  late List<Reference> allImageReferences = [];

  @override
  void initState() {
    super.initState();
    // Retrieve references to all images from all folders
    fetchAllImageReferences();
  }

  Future<void> fetchAllImageReferences() async {
    List<String> folderNames = [
      'Image1',
      'Image2',
      'Image3'
    ]; // Add more folder names if needed

    for (String folderName in folderNames) {
      ListResult result = await storage.ref().child(folderName).listAll();
      allImageReferences.addAll(result.items);
    }

    setState(() {}); // Trigger a rebuild after fetching data
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image Gallery'),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Number of columns in the grid
//           crossAxisSpacing: 8, // Spacing between columns
//           mainAxisSpacing: 8, // Spacing between rows
//         ),
//         itemCount: allImageReferences.length,
//         itemBuilder: (context, index) {
//           return FutureBuilder(
//             future: allImageReferences[index].getDownloadURL(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData) {
//                 return Image.network(
//                   snapshot.data as String,
//                   fit: BoxFit.cover,
//                 );
//               } else if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else {
//                 return Container();
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallary'),
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
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 8, // Spacing between columns
                mainAxisSpacing: 8, // Spacing between rows
              ),
              itemCount: allImageReferences.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: allImageReferences[index].getDownloadURL(),
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
