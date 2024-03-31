import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orthoscan2/utils/appmethods.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ProblemDetectionScreen extends StatefulWidget {
  static const routeName = "/problem-detection";

  const ProblemDetectionScreen({super.key});

  @override
  State<ProblemDetectionScreen> createState() => _ProblemDetectionScreenState();
}

class _ProblemDetectionScreenState extends State<ProblemDetectionScreen> {
  Interpreter? interpreter;
  @override
  void dispose() {
    interpreter!.close();
    super.dispose();
  }
  TensorImage getProcessedImage(TensorImage inputImage) {
    final imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .add(NormalizeOp(0, 255))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    File pickedImage;
    String modalOutput;

    Future runModal(File input) async {
      String output = "";
      interpreter =
          await Interpreter.fromAsset("assets/pose_landmark_full.tflite");

      interpreter!.run(input, output);
      modalOutput = output;
      print(modalOutput);
    }

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
              pickedImage = await AppMethods.pickImage(ImageSource.gallery);
              if (pickedImage != "") runModal(pickedImage);
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
            const Card(
              child: SizedBox(
                height: 250,
                width: 250,
              ),
            )
        ]),
      ),
    );
  }
}
