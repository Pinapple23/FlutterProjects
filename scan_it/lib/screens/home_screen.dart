import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scan_it/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'FirebaseImageGallery.dart';
import 'QRCodeScannerApp.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child:
                    Image.asset("images/colorPalette.png", fit: BoxFit.contain),
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: const Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
              ActionChip(
                  label: const Text("Scanner"),
                  onPressed: () {
                    scan(context);
                  }),
              ActionChip(
                  label: const Text("View"),
                  onPressed: () {
                    viewGallary(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<void> scan(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        // MaterialPageRoute(builder: (context) => QRCodeScanner()));
        MaterialPageRoute(builder: (context) => const QRCodeScannerApp()));
  }

  Future<void> viewGallary(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FirebaseImageGallery()));
  }
}
