import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orthoscan2/utils/appmethods.dart';
import 'package:orthoscan2/widgets/side_drawer.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:ui' as ui;

class ProblemDetectionScreen extends StatefulWidget {
  static const routeName = "/problem-detection";

  const ProblemDetectionScreen({super.key});

  @override
  State<ProblemDetectionScreen> createState() => _ProblemDetectionScreenState();
}

class _ProblemDetectionScreenState extends State<ProblemDetectionScreen> {
  Interpreter? interpreter;
  int _imageWidth = 0;
  int _imageHeight = 0;
  @override
  void dispose() {
    interpreter!.close();
    super.dispose();
  }

  Future<ui.Image> getImageFromFile(File file) async {
    final bytes = await file.readAsBytes();
    final image = await decodeImageFromList(bytes);
    return image;
  }

  // Function to retrieve image dimensions
  Future<void> getImageDimensions(File imageFile) async {
    // Load image
    final image = await getImageFromFile(imageFile);

    // Get width and height
    _imageWidth = image.width;
    _imageHeight = image.height;

    // print('Image width: $width');
    // print('Image height: $height');
  }

  Future<Uint8List> _getProcessedImage(File input) async {
    // Load image
    var image = await input.readAsBytes();
    debugPrint("Image: $image");
    // Convert image to grayscale
    var grayscaleImage = _convertToGrayscale(image);
    debugPrint("Grayscale Image: $grayscaleImage");
    // Quantize pixel values to integers
    var quantizedImage = _quantizeImage(grayscaleImage);
    debugPrint("Quantized Image: $quantizedImage");
    return Uint8List.fromList(quantizedImage);
  }

  Uint8List _convertToGrayscale(Uint8List image) {
    // Your code to convert the image to grayscale

    // Get image dimensions
    int width = _imageWidth;
    int height = _imageHeight;

    // Create output buffer for grayscale image
    Uint8List grayscaleImage = Uint8List(width * height);

    // Iterate over each pixel in the image
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // Calculate pixel index in the input image
        int index = y * width + x;

        // Get RGB components of the pixel
        int r = image[index * 4];
        int g = image[index * 4 + 1];
        int b = image[index * 4 + 2];

        // Calculate grayscale value using ITU-R 601-2 luma transform
        int grayscale = (0.299 * r + 0.587 * g + 0.114 * b).round();

        // Store grayscale value in output buffer
        grayscaleImage[index] = grayscale;
      }
    }

    return grayscaleImage;
  }

  // Function to quantize pixel values to integers
  Uint8List _quantizeImage(Uint8List image) {
    // Get image dimensions
    int width = _imageWidth;
    int height = _imageHeight;

    // Create output buffer for quantized image
    Uint8List quantizedImage = Uint8List(width * height);

    // Iterate over each pixel in the image
    for (int i = 0; i < image.length; i++) {
      // Quantize pixel value to integer (0 to 255)
      quantizedImage[i] = (image[i] / 255 * 255).round();
    }

    return quantizedImage;
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    File? pickedImage;
    String modelOutput;

    Future runModel(File input) async {
      String output = "";
      interpreter =
          await Interpreter.fromAsset("assets/pose_landmark_full.tflite");
      var inputImage = await _getProcessedImage(input);
      // print(inputImage);
      interpreter!.run(inputImage, output);
      modelOutput = output;
      print(modelOutput);
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
              if (pickedImage != null) await runModel(pickedImage!);
              // await getImageDimensions(pickedImage!);
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
