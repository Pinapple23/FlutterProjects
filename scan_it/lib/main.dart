import 'package:flutter/material.dart';
import 'package:scan_it/screens/Auth.dart';
import 'package:scan_it/screens/ScannerScreen.dart';
import 'package:scan_it/screens/home_screen.dart';
import 'package:scan_it/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scan_it/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // home: ImgScreen(),
      routes: {
        '/': (context) => const Auth(),
        'homeScreen': (context) => ScanDocumentScreen(),
        'signupScreen': (context) => const SignupScreen(),
        'loginScreen': (context) => const LoginScreen(),
      },
    );
  }
}
