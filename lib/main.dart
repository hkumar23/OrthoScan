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
        // backgroundColor: Colors.grey.shade200,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          surface: Colors.green.shade50,
          secondary: Colors.greenAccent,
          // primary: Colors.green,
          ),
        primarySwatch: Colors.green,
        // brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))
          )
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          )
        ),
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

