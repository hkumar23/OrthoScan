import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:orthoscan2/providers/auth.dart';
import 'package:orthoscan2/screens/feedback_screen.dart';
import 'package:orthoscan2/screens/historyandprogress_screen.dart';
import 'package:orthoscan2/screens/home_screen.dart';
import 'package:orthoscan2/screens/login_screen.dart';
import 'package:orthoscan2/screens/problem_detection_screen.dart';
import 'package:orthoscan2/screens/profile_screen.dart';
import 'package:orthoscan2/screens/signup_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Brightness themeBrightness = Brightness.dark;
  void toggleAppTheme() {
    setState(() {
      if (themeBrightness == Brightness.dark) {
        themeBrightness = Brightness.light;
      } else {
        themeBrightness = Brightness.dark;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: Consumer<Auth>(builder: (context, auth, ch) {
        // print("User Id: ${auth.userId}");
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
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // print("Snapshot: $snapshot");
                return !snapshot.hasData
                    ? LoginScreen()
                    : HomeScreen(toggleAppTheme, themeBrightness);
              }),
          // HomeScreen(toggleAppTheme,themeBrightness),
          routes: {
            HomeScreen.routeName: (context) =>
                HomeScreen(toggleAppTheme, themeBrightness),
            ProblemDetectionScreen.routeName: (context) =>
                const ProblemDetectionScreen(),
            ProfileScreen.routeName: (context) =>
                ProfileScreen(toggleAppTheme, themeBrightness),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignupScreen.routeName: (context) => SignupScreen(),
            HistoryAndProgress.routeName: (context) => HistoryAndProgress(),
            FeedbackScreen.routeName: (context) => const FeedbackScreen(),
          },
        );
      }),
    );
  }
}
