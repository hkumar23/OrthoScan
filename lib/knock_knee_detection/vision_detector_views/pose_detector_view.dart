import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:orthoscan2/knock_knee_detection/vision_detector_views/utils.dart';
import 'package:orthoscan2/models/coordinates.dart';

import 'detector_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  int _percentText = 0; //BYME:

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      percentText: _percentText, //BYME:
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    // print("IMAGE METADATA: ${inputImage.metadata!.size.height}");
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
      _percentText = 0;
    });
    final poses = await _poseDetector.processImage(inputImage);
    // print(poses[0]);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
      _percentText = await percentOfKnockKnees();
      print("You have $_percentText% knock knees.");
    } else {
      // poses[0].landmarks.forEach((key, value) {
      //   print("$key: $value");
      // });

      final coordinatesMap = {
        "left_knee": {
          "x": poses[0].landmarks[PoseLandmarkType.leftKnee]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.leftKnee]!.y,
        },
        "left_ankle": {
          "x": poses[0].landmarks[PoseLandmarkType.leftAnkle]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.leftAnkle]!.y,
        },
        "right_knee": {
          "x": poses[0].landmarks[PoseLandmarkType.rightKnee]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.rightKnee]!.y,
        },
        "right_ankle:": {
          "x": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.rightAnkle]!.y,
        },
        "left_hip:": {
          "x": poses[0].landmarks[PoseLandmarkType.leftHip]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.leftHip]!.y,
        },
        "right_hip:": {
          "x": poses[0].landmarks[PoseLandmarkType.rightHip]!.x,
          "y": poses[0].landmarks[PoseLandmarkType.rightHip]!.y,
        },
      };
      // print(percentOfKnockKnees());
      // print(obj);
      // print(coordinates);
      _text = 'Poses found: ${poses.length}\n\n';
      _percentText = await percentOfKnockKnees(); //BYME:
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
      // Coordinates obj = Coordinates.fromJson(coordinatesMap);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
