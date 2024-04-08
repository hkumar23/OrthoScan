import 'package:flutter/material.dart';
import 'package:orthoscan2/knock_knee_detection/vision_detector_views/pose_detector_view.dart';

import 'package:orthoscan2/widgets/side_drawer.dart';

class ProblemDetectionScreen extends StatelessWidget {
  static const routeName = "/problem-detection";

  const ProblemDetectionScreen({super.key});

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
                  builder: (context) => PoseDetectorView(),
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
