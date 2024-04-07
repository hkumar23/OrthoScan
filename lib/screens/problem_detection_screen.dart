import 'package:flutter/material.dart';
import 'package:orthoscan2/google_mlkit_pose_detection/pose_detector_view.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class ProblemDetectionScreen extends StatefulWidget {
  static const routeName = "/problem-detection";

  const ProblemDetectionScreen({super.key});

  @override
  State<ProblemDetectionScreen> createState() => _ProblemDetectionScreenState();
}

class _ProblemDetectionScreenState extends State<ProblemDetectionScreen> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    // File? pickedImage;
    // print(args);
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: Text(args),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PoseDetectorView(),
                ),
              );
            },
            child: Card(
              // borderOnForeground: true,
              child: Container(
                alignment: Alignment.center,
                height: 250,
                width: 250,
                child: const Text(
                  "Upload Image from Gallery for Detection",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          if (args != "Interactive Exercises")
            GestureDetector(
              onTap: () async {},
              child: const Card(
                child: SizedBox(
                  height: 250,
                  width: 250,
                ),
              ),
            )
        ]),
      ),
    );
  }
}
