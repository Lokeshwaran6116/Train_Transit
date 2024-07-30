import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:train_transit/pages/login_page.dart'; // Import the LoginPage
import 'firebase_options.dart'; // Ensure you have firebase_options.dart generated from FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // Remove `const` here as well
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Remove `const` here
    );
  }
}
