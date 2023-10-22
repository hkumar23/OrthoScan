import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:orthoscan2/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          // brightness: Brightness.dark,
          background: Colors.blue.shade50,
          // surface: Colors.blue.shade50,
          secondary: Colors.blueGrey,
          // primary: Colors.blue,
          ),
        // primarySwatch: Colors.green,
        // brightness: Brightness.light,
        useMaterial3: true,
      ),
      // initialRoute: HomeScreen.routeName,
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName : (context)=> HomeScreen(),
      },
    );
  }
}

