import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Login App",
    theme: ThemeData(primarySwatch: Colors.red),
    initialRoute: LoginScreen.id,
    routes: {
      HomePage.id: (context) => const HomePage(),
      LoginScreen.id: (context) => const LoginScreen()
    },
  ));
}
