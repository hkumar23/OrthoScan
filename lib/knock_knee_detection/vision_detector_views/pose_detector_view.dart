import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

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
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
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
    } else {
      // poses[0].landmarks.forEach((key, value) {
      //   print("$key: $value");
      // });
      final coordinates = {
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
      // print(
      //     "Left Knee: ${coordinates["lk"]!["x"]}, ${coordinates["lk"]!["y"]}");
      // print(
      //     "Left Ankle: ${coordinates["la"]!["x"]}, ${coordinates["la"]!["y"]}");
      // print(
      //     "Right Knee : ${coordinates["rk"]!["x"]}, ${coordinates["rk"]!["y"]}");
      // print(
      //     "Right Ankle: ${coordinates["ra"]!["x"]}, ${coordinates["ra"]!["y"]}");
      _text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
