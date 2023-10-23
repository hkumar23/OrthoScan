import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:orthoscan2/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness themeBrightness=Brightness.light;
  void toggleAppTheme(){
    setState(() {
      if(themeBrightness==Brightness.dark){
        themeBrightness=Brightness.light;
      }
      else{
        themeBrightness=Brightness.dark;
      }
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor: Colors.blue,
        //   // brightness: Brightness.dark,
        //   // background:Colors.blueAccent[50],
        //   // surface: Colors.blue.shade50,
        //   // secondary: Colors.blueGrey,
        //   // primary: Colors.blue,
        //   ),
        colorSchemeSeed: Colors.teal,
        // primarySwatch: Colors.green,
        brightness: themeBrightness,
        useMaterial3: true,
      ),
      // initialRoute: HomeScreen.routeName,
      home: HomeScreen(toggleAppTheme,themeBrightness),
      routes: {
        HomeScreen.routeName : (context)=> HomeScreen(toggleAppTheme,themeBrightness),
      },
    );
  }
}

